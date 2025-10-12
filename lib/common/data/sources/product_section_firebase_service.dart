import 'package:bluedock/common/data/models/product/product_selection_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class ProductSectionFirebaseService {
  Future<Either> getProductCategories();
  Future<Either> getProductSelection(ProductSelectionReq req);
}

class ProductSectionFirebaseServiceImpl extends ProductSectionFirebaseService {
  final _db = FirebaseFirestore.instance.collection('Products');

  @override
  Future<Either> getProductCategories() async {
    try {
      final listData = await _db.orderBy('index').get();
      if (listData.docs.isEmpty) {
        return Left('Product Categories Not Found');
      }

      return Right(listData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> getProductSelection(ProductSelectionReq req) async {
    try {
      final q = req.keyword.trim().toLowerCase();
      final docRef = _db.doc(req.categoryId).collection('Selection');

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
