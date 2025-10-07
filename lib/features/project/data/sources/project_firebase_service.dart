import 'package:bluedock/features/project/data/models/selection/product_selection_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
// import 'package:firebase_auth/firebase_auth.dart';

abstract class ProjectFirebaseService {
  Future<Either> getProjectSelection(String title);
  Future<Either> getCategorySelection();
  Future<Either> getProductSelection(ProductSelectionReq req);
}

class ProjectFirebaseServiceImpl extends ProjectFirebaseService {
  // final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Selection
  @override
  Future<Either> getProjectSelection(String title) async {
    try {
      final listData = await _db
          .collection('Projects')
          .doc('Selection')
          .collection(title)
          .orderBy('title')
          .get();

      if (listData.docs.isEmpty) {
        return Left('Selection Not Found');
      }

      return Right(listData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }

  // Categories
  @override
  Future<Either> getCategorySelection() async {
    try {
      final listData = await _db.collection('Products').orderBy('index').get();
      if (listData.docs.isEmpty) {
        return Left('Product Categories Not Found');
      }

      return Right(listData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }

  // Product
  @override
  Future<Either> getProductSelection(ProductSelectionReq req) async {
    try {
      final q = req.keyword.trim().toLowerCase();
      final docRef = _db
          .collection('Products')
          .doc(req.categoryId)
          .collection('Selection');

      if (q.isEmpty) {
        final snap = await docRef.orderBy('productModel').get();

        return Right(snap.docs.map((e) => e.data()).toList());
      }

      final snap = await docRef.where('searchKeywords', arrayContains: q).get();

      return Right(snap.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }
}
