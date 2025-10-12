import 'package:bluedock/common/domain/entities/staff_entity.dart';
import 'package:bluedock/common/helper/authError/auth_error_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserFirebaseService {
  Future<Either> logout();

  Future<Either> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<Either> getAppMenu(StaffEntity user);
}

class UserFirebaseServiceImpl extends UserFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  @override
  Future<Either> logout() async {
    try {
      await _auth.signOut();
      return Right('Logout Successfull');
    } catch (_) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return Left('User not logged in');

      final hasEmailProvider = user.providerData.any(
        (p) => p.providerId == 'password',
      );
      if (!hasEmailProvider || user.email == null) {
        return Left('This account does not use email/password sign-in');
      }

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);

      final staffRef = _db.collection('Staff').doc(user.uid);
      await _db.runTransaction((tx) async {
        final snap = await tx.get(staffRef);
        final data = snap.data() ?? {};
        final currentVersion = (data['passwordVersion'] ?? 0) as int;

        tx.set(staffRef, {
          'passwordChangedAt': FieldValue.serverTimestamp(),
          'passwordVersion': currentVersion + 1,
          'updatedBy': user.email,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });

      return Right('Password changed successfully');
    } on FirebaseAuthException catch (e) {
      final msg = mapAuthError(e);
      return Left(msg);
    }
  }

  @override
  Future<Either> getAppMenu(StaffEntity user) async {
    try {
      final db = FirebaseFirestore.instance;

      final roleSnap = await db.collection('Roles').doc(user.role.roleId).get();
      if (!roleSnap.exists) return const Left('Role not found');

      final roleData = roleSnap.data()!;
      final roleId = roleSnap.id;
      final List<String> menuIds = List<String>.from(
        roleData['listAppMenu'] ?? const [],
      );

      await db.collection('Staff').doc(user.staffId).set({
        'roleId': roleId,
        'role': {...roleData, 'roleId': roleId},
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (menuIds.isEmpty) return const Right(<Map<String, dynamic>>[]);

      final Map<String, Map<String, dynamic>> dataById = {};
      for (int i = 0; i < menuIds.length; i += 10) {
        final chunk = menuIds.sublist(
          i,
          (i + 10 > menuIds.length) ? menuIds.length : i + 10,
        );
        final snap = await db
            .collection('AppMenu')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        for (final d in snap.docs) {
          dataById[d.id] = d.data();
        }
      }

      final List<Map<String, dynamic>> orderedData = [
        for (final id in menuIds)
          if (dataById.containsKey(id)) dataById[id]!,
      ];

      int toIndex(dynamic v) {
        if (v is int) return v;
        if (v is num) return v.toInt();
        if (v is String) return int.tryParse(v) ?? 1 << 30;
        return 1 << 30;
      }

      orderedData.sort(
        (a, b) => toIndex(a['index']).compareTo(toIndex(b['index'])),
      );

      return Right(orderedData);
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
