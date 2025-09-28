import 'package:bluedock/common/helper/authError/auth_error_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserFirebaseService {
  Future<Either> getUser();
  Future<Either> logout();

  Future<Either> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}

class UserFirebaseServiceImpl extends UserFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  @override
  Future<Either> getUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return Left('USER_NOT_LOGGED_IN');

      final snap = await _db.collection('Staff').doc(user.uid).get();
      if (!snap.exists) {
        await _auth.signOut();
        return Left('STAFF_NOT_FOUND');
      }

      return Right(snap.data());
    } catch (e) {
      return Left('Please try again');
    }
  }

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
}
