import 'package:bluedock/features/product/data/models/product/product_req.dart';
import 'package:bluedock/features/product/data/models/selection/selection_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ProductFirebaseService {
  Future<Either> deleteProduct(ProductReq product);
  Future<Either> favoriteProduct(ProductReq product);
  Future<Either> getSelection(SelectionReq selection);
  Future<Either> getProductCategories();
}

class ProductFirebaseServiceImpl extends ProductFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Selection
  @override
  Future<Either> getSelection(SelectionReq selection) async {
    try {
      final listData = await _db
          .collection('Products')
          .doc(selection.productTitle)
          .collection(selection.selectionTitle)
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

  // Product
  @override
  Future<Either> deleteProduct(ProductReq product) async {
    try {
      final docRef = _db
          .collection('Products')
          .doc(product.productCategoriesTitle)
          .collection('Items')
          .doc(product.productId);

      final catDocRef = _db
          .collection('ProductCategories')
          .doc(product.productCategoriesId);

      await _db.runTransaction((tx) async {
        final productSnap = await tx.get(docRef);
        if (!productSnap.exists) {
          throw Exception('Product not found');
        }

        tx.delete(docRef);

        tx.set(catDocRef, {
          'totalProduct': FieldValue.increment(-1),
        }, SetOptions(merge: true));
      });

      return const Right('Product has been removed successfully.');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> favoriteProduct(ProductReq product) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return const Left('User is not logged in.');

      final userEmail = _auth.currentUser?.email ?? '';

      final docRef = _db
          .collection('Products')
          .doc(product.productCategoriesTitle)
          .collection('Items')
          .doc(product.productId);

      var nowFav = false;

      await _db.runTransaction((tx) async {
        final snap = await tx.get(docRef);
        if (!snap.exists) throw Exception('Product not found');

        final data = snap.data() ?? const <String, dynamic>{};

        final current = List<String>.from(
          data['favorites'] ?? const <String>[],
        );
        final alreadyFav = current.contains(uid);
        nowFav = !alreadyFav;

        tx.update(docRef, {
          'favorites': nowFav
              ? FieldValue.arrayUnion([uid])
              : FieldValue.arrayRemove([uid]),
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': userEmail,
        });
      });

      return Right(nowFav ? 'Added to favorites.' : 'Removed from favorites.');
    } catch (_) {
      return const Left('Please try again');
    }
  }

  // Product Categories
  @override
  Future<Either> getProductCategories() async {
    try {
      final listData = await _db
          .collection('ProductCategories')
          .orderBy('index')
          .get();
      if (listData.docs.isEmpty) {
        return Left('Product Categories Not Found');
      }

      return Right(listData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }
}
