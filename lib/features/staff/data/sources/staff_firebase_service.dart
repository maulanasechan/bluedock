import 'package:bluedock/common/helper/authError/auth_error_helper.dart';
import 'package:bluedock/features/staff/data/models/staff_form_req.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';

abstract class StaffFirebaseService {
  Future<Either> addStaff(StaffFormReq staff);
  Future<Either> getAllStaff();
  Future<Either> deleteStaff(String staffId);
  Future<Either> updateStaff(StaffFormReq staff);
  Future<Either> searchStaffByName(String query);
}

class StaffFirebaseServiceImpl extends StaffFirebaseService {
  List<String> _buildWordPrefixes(String name) {
    final words = name
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty);

    final out = <String>[];
    for (final w in words) {
      var buf = '';
      for (var i = 0; i < w.length; i++) {
        buf += w[i];
        out.add(buf);
      }
    }
    return out.toSet().toList();
  }

  @override
  Future<Either> addStaff(StaffFormReq staff) async {
    try {
      final primary = Firebase.app();
      final secondary = await Firebase.initializeApp(
        name: 'secondary',
        options: primary.options,
      );

      final secondaryAuth = FirebaseAuth.instanceFor(app: secondary);

      final cred = await secondaryAuth.createUserWithEmailAndPassword(
        email: staff.email,
        password: staff.password,
      );

      await FirebaseFirestore.instance
          .collection('Staff')
          .doc(cred.user!.uid)
          .set({
            'staffId': cred.user!.uid,
            'fullName': staff.fullName,
            'fullNameWordPrefixes': _buildWordPrefixes(staff.fullName),
            'nik': staff.nik,
            'nip': staff.nip,
            'email': staff.email,
            'address': staff.address,
            'role': staff.role?.toJson(),
            'image': cred.user!.photoURL,
            'phoneNumber': staff.phoneNumber,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': null,
            'lastOnline': null,
            'lastLogin': null,
            'updatedBy': '',
          });

      await secondaryAuth.signOut();
      await secondary.delete();

      return Right('Staff has been added successfully.');
    } on FirebaseAuthException catch (e) {
      final msg = mapAuthError(e);
      return Left(msg);
    } catch (_) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> getAllStaff() async {
    try {
      var listData = await FirebaseFirestore.instance
          .collection('Staff')
          .orderBy('fullName')
          .get();
      return Right(listData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> deleteStaff(String staffId) async {
    try {
      final firestore = FirebaseFirestore.instance;

      await firestore.collection('Staff').doc(staffId).delete();

      return Right('Remove product succesfull');
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> updateStaff(StaffFormReq staff) async {
    try {
      final db = FirebaseFirestore.instance;
      final staffRef = db.collection('Staff').doc(staff.staffId);
      final adminEmail = FirebaseAuth.instance.currentUser?.email ?? '';

      final snap = await staffRef.get();
      if (!snap.exists) return Left('Staff not found');

      await staffRef.set({
        'fullName': staff.fullName,
        'fullNameWordPrefixes': _buildWordPrefixes(staff.fullName),
        'nik': staff.nik,
        'nip': staff.nip,
        'address': staff.address,
        'phoneNumber': staff.phoneNumber,
        'role': staff.role?.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': adminEmail,
      }, SetOptions(merge: true));

      return Right('Staff updated successfully');
    } catch (_) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> searchStaffByName(String query) async {
    try {
      final q = query.trim().toLowerCase();

      if (q.isEmpty) {
        final snap = await FirebaseFirestore.instance
            .collection('Staff')
            .orderBy('fullName')
            .get();

        return Right(snap.docs.map((e) => e.data()).toList());
      }

      final snap = await FirebaseFirestore.instance
          .collection('Staff')
          .where('fullNameWordPrefixes', arrayContains: q)
          .get();

      return Right(snap.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }
}
