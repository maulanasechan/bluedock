import 'package:bluedock/features/product/data/models/sperreAirCompressor/sperre_air_compressor_form_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ProductFirebaseService {
  Future<Either> getProductCategories();
  Future<Either> addSperreAirCompressor(SperreAirCompressorReq req);
  Future<Either> searchSperreAirCompressor(String query);
}

class ProductFirebaseServiceImpl extends ProductFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  List<String> _buildWordPrefixes(String text) {
    final t = text.trim().toLowerCase();
    if (t.isEmpty) return const [];
    final parts = t.split(RegExp(r'\s+'));
    final out = <String>[];
    for (final p in parts) {
      for (var i = 1; i <= p.length; i++) {
        out.add(p.substring(0, i));
      }
    }
    return out.toSet().toList();
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

  // Sperre Air Compressor
  @override
  Future<Either> searchSperreAirCompressor(String query) async {
    try {
      final q = query.trim().toLowerCase();

      final base = _db
          .collection('Products')
          .doc('Sperre Air Compressor')
          .collection('Items');

      if (q.isEmpty) {
        final snap = await base.orderBy('productType').get();
        return Right(snap.docs.map((e) => e.data()).toList());
      }

      final snap = await base.where('searchKeywords', arrayContains: q).get();

      return Right(snap.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> addSperreAirCompressor(SperreAirCompressorReq req) async {
    try {
      final userEmail = _auth.currentUser?.email ?? '';

      final colRef = _db
          .collection('Products')
          .doc('Sperre Air Compressor')
          .collection('Items');

      final productId = req.productId.isNotEmpty
          ? req.productId
          : colRef.doc().id;

      final productMap = <String, dynamic>{
        'productId': productId,
        'productUsage': req.productUsage,
        'productType': req.productType,
        'coolingSystem': req.coolingSystem,
        'productTypeCode': req.productTypeCode,
        'chargingCapacity50Hz1500rpm': req.chargingCapacity50Hz1500rpm,
        'maxDeliveryPressure': req.maxDeliveryPressure,
        'favorites': req.favorites,
        'quantity': req.quantity,
        'image': req.image,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': null,
        'createdBy': userEmail,
        'updatedBy': '',
        'searchKeywords': _buildPrefixesFromAllFields(req),
      };

      await colRef.doc(productId).set(productMap, SetOptions(merge: true));

      final catDocRef = _db
          .collection('ProductCategories')
          .doc('aP9xG7kLmQzR2VtYcJwE');
      await catDocRef.set({
        'totalProduct': FieldValue.increment(1),
      }, SetOptions(merge: true));

      return const Right('Product has been added successfully.');
    } catch (_) {
      return const Left('Please try again');
    }
  }

  List<String> _buildPrefixesFromAllFields(SperreAirCompressorReq req) {
    final all = [
      req.productUsage,
      req.productType,
      req.coolingSystem,
      req.productTypeCode,
      req.chargingCapacity50Hz1500rpm,
      req.maxDeliveryPressure,
    ].where((e) => e.trim().isNotEmpty).join(' ');
    return _buildWordPrefixes(all);
  }
}
