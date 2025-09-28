import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class RoleFirebaseService {
  Future<Either> getRoles();
}

class RoleFirebaseServiceImpl extends RoleFirebaseService {
  @override
  Future<Either> getRoles() async {
    try {
      var listRoles = await FirebaseFirestore.instance
          .collection('Roles')
          .orderBy('title')
          .get();
      return Right(listRoles.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please Try Again');
    }
  }
}
