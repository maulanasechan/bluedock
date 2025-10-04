import 'package:bluedock/common/helper/buildPrefix/build_prefixes_helper.dart';
import 'package:bluedock/common/helper/stringTrimmer/string_trimmer_helper.dart';
import 'package:bluedock/features/product/data/models/sperreScrewCompressor/sperre_screw_compressor_form_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class SperreScrewCompressorFirebaseService {
  Future<Either> addSperreScrewCompressor(SperreScrewCompressorReq req);
  Future<Either> searchSperreScrewCompressor(String query);
  Future<Either> updateSperreScrewCompressor(SperreScrewCompressorReq req);
}

class SperreScrewCompressorFirebaseServiceImpl
    extends SperreScrewCompressorFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance
      .collection('Products')
      .doc('Zx4nB8qHtUvL5rOaWsKd');

  @override
  Future<Either> searchSperreScrewCompressor(String query) async {
    try {
      final uid = _auth.currentUser?.uid;
      final q = query.trim().toLowerCase();

      final base = _db.collection('Items');

      final snap = q.isEmpty
          ? await base.orderBy('productType').get()
          : await base.where('searchKeywords', arrayContains: q).get();

      final items = snap.docs.map((d) {
        final m = d.data();
        m['productId'] = m['productId'] ?? d.id;
        return m;
      }).toList();

      final favs = <Map<String, dynamic>>[];
      final others = <Map<String, dynamic>>[];

      for (final m in items) {
        final favList = List<String>.from(m['favorites'] ?? const <String>[]);
        final isFav = uid != null && favList.contains(uid);
        (isFav ? favs : others).add(m);
      }

      int byType(Map<String, dynamic> a, Map<String, dynamic> b) =>
          (a['productType'] ?? '').toString().compareTo(
            (b['productType'] ?? '').toString(),
          );
      favs.sort(byType);
      others.sort(byType);

      final seen = <String>{};
      final result = <Map<String, dynamic>>[];

      void addUnique(List<Map<String, dynamic>> src) {
        for (final m in src) {
          final id = (m['productId'] ?? '').toString();
          if (id.isEmpty) continue;
          if (seen.add(id)) result.add(m);
        }
      }

      addUnique(favs);
      addUnique(others);

      return Right(result);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> addSperreScrewCompressor(SperreScrewCompressorReq req) async {
    try {
      final userEmail = _auth.currentUser?.email ?? '';

      final colRef = _db.collection('Items');
      final selRef = _db.collection('Selection');

      final productId = req.productId.isNotEmpty
          ? req.productId
          : colRef.doc().id;

      final selectionMap = <String, dynamic>{
        'productId': productId,
        'productModel': req.productTypeCode,
        'image': req.image,
        'quantity': req.quantity,
      };

      final productMap = <String, dynamic>{
        'productId': productId,
        'productUsage': req.productUsage,
        'productType': req.productType,
        'coolingSystem': req.coolingSystem,
        'productTypeCode': req.productTypeCode,
        'chargingCapacity8Bar': "${req.chargingCapacity8Bar} m3/h",
        'chargingCapacity10Bar': '${req.chargingCapacity10Bar} m3/h',
        'chargingCapacity12_5Bar': '${req.chargingCapacity12_5Bar} m3/h',
        'favorites': req.favorites,
        'quantity': req.quantity,
        'image': req.image,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': null,
        'createdBy': userEmail,
        'updatedBy': '',
        'searchKeywords': _buildAllPrefixes(req),
      };

      await colRef.doc(productId).set(productMap, SetOptions(merge: true));
      await selRef.doc(productId).set(selectionMap, SetOptions(merge: true));

      await _db.set({
        'totalProduct': FieldValue.increment(1),
      }, SetOptions(merge: true));

      return const Right('Product has been added successfully.');
    } catch (_) {
      return const Left('Please try again');
    }
  }

  List<String> _buildAllPrefixes(SperreScrewCompressorReq req) {
    final all = [
      req.productUsage,
      req.productType,
      req.coolingSystem,
      req.productTypeCode,
      req.chargingCapacity8Bar,
      req.chargingCapacity10Bar,
      req.chargingCapacity12_5Bar,
    ].where((e) => e.trim().isNotEmpty).join(' ');
    return buildWordPrefixes(all);
  }

  @override
  Future<Either> updateSperreScrewCompressor(
    SperreScrewCompressorReq req,
  ) async {
    try {
      final userEmail = _auth.currentUser?.email ?? '';

      if (req.productId.isEmpty) {
        return const Left('Product ID is required for update.');
      }

      final docRef = _db.collection('Items').doc(req.productId);
      final selRef = _db.collection('Selection').doc(req.productId);

      final selectionMap = <String, dynamic>{
        'productId': req.productId,
        'productModel': req.productTypeCode,
        'image': req.image,
        'quantity': req.quantity,
      };

      final updateMap = <String, dynamic>{
        'productId': req.productId,
        'productUsage': req.productUsage,
        'productType': req.productType,
        'coolingSystem': req.coolingSystem,
        'productTypeCode': req.productTypeCode,
        'chargingCapacity8Bar':
            "${stripSuffix(req.chargingCapacity8Bar, 'm3/h')} m3/h",
        'chargingCapacity10Bar':
            "${stripSuffix(req.chargingCapacity10Bar, 'm3/h')} m3/h",
        'chargingCapacity12_5Bar':
            "${stripSuffix(req.chargingCapacity12_5Bar, 'm3/h')} m3/h",
        'favorites': req.favorites,
        'image': req.image,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': userEmail,
        'searchKeywords': _buildAllPrefixes(req),
      };

      updateMap.removeWhere((_, v) => v == null);

      await docRef.set(updateMap, SetOptions(merge: true));
      await selRef.set(selectionMap, SetOptions(merge: true));

      return const Right('Product has been updated successfully.');
    } catch (_) {
      return const Left('Please try again');
    }
  }
}
