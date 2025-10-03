import 'package:bluedock/common/helper/buildPrefix/build_prefixes_helper.dart';
import 'package:bluedock/common/helper/stringTrimmer/format_thousand_helper.dart';
import 'package:bluedock/common/helper/stringTrimmer/string_trimmer_helper.dart';
import 'package:bluedock/features/product/data/models/detegasaIncenerator/detegasa_incenerator_form_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class DetegasaInceneratorFirebaseService {
  Future<Either> addDetegasaIncenerator(DetegasaInceneratorReq req);
  Future<Either> searchDetegasaIncenerator(String query);
  Future<Either> updateDetegasaIncenerator(DetegasaInceneratorReq req);
}

class DetegasaInceneratorFirebaseServiceImpl
    extends DetegasaInceneratorFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _id = 'Detegasa Incenerator';
  final _catId = 'L9cX2bTfVgP5zRjYhMwQ';

  @override
  Future<Either> searchDetegasaIncenerator(String query) async {
    try {
      final uid = _auth.currentUser?.uid;
      final q = query.trim().toLowerCase();

      final base = _db.collection('Products').doc(_id).collection('Items');

      final snap = q.isEmpty
          ? await base.orderBy('productUsage').get()
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
          (a['productUsage'] ?? '').toString().compareTo(
            (b['productUsage'] ?? '').toString(),
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
  Future<Either> addDetegasaIncenerator(DetegasaInceneratorReq req) async {
    try {
      final userEmail = _auth.currentUser?.email ?? '';

      final colRef = _db.collection('Products').doc(_id).collection('Items');

      final productId = req.productId.isNotEmpty
          ? req.productId
          : colRef.doc().id;

      final productMap = <String, dynamic>{
        'productId': productId,
        'productUsage': req.productUsage,
        'productModel': req.productModel,
        'heatGenerate': "${formatWithCommas(req.heatGenerate)} KCAL/Hr",
        'powerRating': "${formatWithCommas(req.powerRating)} KW",
        'imoSludge': "${req.imoSludge} L/H",
        'solidWaste': "${req.solidWaste} kg/h",
        'maxBurnerConsumption': "${req.maxBurnerConsumption} kg/h",
        'maxElectricPower': "${req.maxElectricPower} KW",
        'approxInceneratorWeight':
            "${formatWithCommas(req.approxInceneratorWeight)} kg",
        'fanWeight': req.fanWeight,
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

      final catDocRef = _db.collection('ProductCategories').doc(_catId);
      await catDocRef.set({
        'totalProduct': FieldValue.increment(1),
      }, SetOptions(merge: true));

      return const Right('Product has been added successfully.');
    } catch (_) {
      return const Left('Please try again');
    }
  }

  List<String> _buildAllPrefixes(DetegasaInceneratorReq req) {
    final all = [
      req.productUsage,
      req.productModel,
      req.heatGenerate,
      req.powerRating,
      req.imoSludge,
      req.solidWaste,
      req.maxBurnerConsumption,
      req.maxElectricPower,
      req.approxInceneratorWeight,
      req.fanWeight,
    ].where((e) => e.trim().isNotEmpty).join(' ');
    return buildWordPrefixes(all);
  }

  @override
  Future<Either> updateDetegasaIncenerator(DetegasaInceneratorReq req) async {
    try {
      final userEmail = _auth.currentUser?.email ?? '';

      if (req.productId.isEmpty) {
        return const Left('Product ID is required for update.');
      }

      final docRef = _db
          .collection('Products')
          .doc(_id)
          .collection('Items')
          .doc(req.productId);

      final updateMap = <String, dynamic>{
        'productId': req.productId,
        'productUsage': req.productUsage,
        'productModel': req.productModel,
        'heatGenerate':
            "${formatWithCommas(stripSuffix(req.heatGenerate, 'KCAL/Hr'))}  KCAL/Hr",
        'powerRating':
            "${formatWithCommas(stripSuffix(req.powerRating, 'KW'))} KW",
        'imoSludge': "${stripSuffix(req.imoSludge, 'L/H')} L/H",
        'solidWaste': "${stripSuffix(req.solidWaste, 'kg/h')} kg/h",
        'maxBurnerConsumption':
            "${stripSuffix(req.maxBurnerConsumption, 'kg/h')} kg/h",
        'maxElectricPower': "${stripSuffix(req.maxElectricPower, 'KW')} KW",
        'approxInceneratorWeight':
            "${formatWithCommas(stripSuffix(req.approxInceneratorWeight, 'kg'))} kg",
        'fanWeight': req.fanWeight,
        'favorites': req.favorites,
        'image': req.image,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': userEmail,
        'searchKeywords': _buildAllPrefixes(req),
      };

      updateMap.removeWhere((_, v) => v == null);

      await docRef.set(updateMap, SetOptions(merge: true));

      return const Right('Product has been updated successfully.');
    } catch (_) {
      return const Left('Please try again');
    }
  }
}
