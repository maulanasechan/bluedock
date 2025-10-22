import 'package:bluedock/common/helper/authError/auth_error_helper.dart';
import 'package:bluedock/features/login/data/models/login_form_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class LoginFirebaseService {
  Future<Either> login(LoginFormReq user);
  Future<bool> isLoggedIn();
  Future<Either> sendPasswordReset(String email);
}

class LoginFirebaseServiceImpl extends LoginFirebaseService {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<String?> _getFcmToken() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    return await messaging.getToken();
  }

  Future<void> _listenTokenRefresh(String uid) async {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      if (newToken.isEmpty) return;
      final staffRef = db.collection('Staff').doc(uid);
      await staffRef.update({
        'tokenNotif': newToken, // latest token
        'tokens': FieldValue.arrayUnion([newToken]), // historical/multi-device
        'lastOnline': FieldValue.serverTimestamp(),
      });
    });
  }

  @override
  Future<Either> login(LoginFormReq user) async {
    try {
      final cred = await auth.signInWithEmailAndPassword(
        email: user.email.trim(),
        password: user.password,
      );
      final uid = cred.user!.uid;

      final staffRef = db.collection('Staff').doc(uid);
      final snap = await staffRef.get();
      if (!snap.exists) {
        await auth.signOut();
        return Left('You are not authenticated');
      }
      final token = await _getFcmToken();

      await db.runTransaction((tx) async {
        final fresh = await tx.get(staffRef);
        if (!fresh.exists) {
          throw Exception('You are not authenticated');
        }
        tx.update(staffRef, {
          'lastOnline': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          if (token != null && token.isNotEmpty) ...{'tokenNotif': token},
        });
      });
      await _listenTokenRefresh(uid);

      return Right('Login was successfull.');
    } on FirebaseAuthException catch (e) {
      final msg = mapAuthError(e);
      return Left(msg);
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    if (auth.currentUser == null) {
      return false;
    }

    try {
      final staffDoc = db.collection('Staff').doc(auth.currentUser!.uid);
      final snapshot = await staffDoc.get();

      if (snapshot.exists) {
        await staffDoc.update({'lastOnline': FieldValue.serverTimestamp()});
        return true;
      } else {
        await FirebaseAuth.instance.signOut();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either> sendPasswordReset(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return Right('Password reset email was send');
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
