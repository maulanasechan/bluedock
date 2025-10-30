import 'package:bluedock/common/helper/buildPrefix/build_prefixes_helper.dart';
import 'package:bluedock/features/inventories/data/models/inventory_form_req.dart';
import 'package:bluedock/features/inventories/data/models/search_inventory_req.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class InventoryFirebaseService {
  Future<Either> searchInventory(SearchInventoryReq query);
  Future<Either> getInventoryById(String query);
  Future<Either> addInventory(InventoryFormReq query);
  Future<Either> updateInventory(InventoryFormReq query);
  Future<Either> deleteInventory(InventoryEntity query);
  Future<Either> favoriteInventory(String req);
}

class InventoryFirebaseServiceImpl extends InventoryFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  List<String> _buildAllPrefixes(InventoryFormReq req) {
    final all = [
      req.stockName,
      req.partNo,
      req.productCategory?.title,
      req.productSelection?.productModel,
    ].where((e) => e!.trim().isNotEmpty).join(' ');
    return buildWordPrefixes(all);
  }

  @override
  Future<Either> searchInventory(SearchInventoryReq req) async {
    try {
      final user = _auth.currentUser;
      final uid = user?.uid ?? '';
      final emailLower = (user?.email ?? '').toLowerCase();

      final q = req.keyword.trim().toLowerCase();
      final cat = req.category.trim();
      final mdl = req.model.trim();

      String safeRoleTitle(Map<String, dynamic>? m) {
        if (m == null) return '';
        final t = (m['title'] ?? '').toString();
        return t.toLowerCase().replaceAll(RegExp(r'\s+'), '');
      }

      // ---- role check (PD bisa lihat semua) ----
      final meDoc = await _db.collection('Staff').doc(uid).get();
      final Map<String, dynamic> me = meDoc.data() ?? <String, dynamic>{};

      final roleTitle = safeRoleTitle(
        (me['role'] as Map?)?.cast<String, dynamic>(),
      );
      final isPD = roleTitle == 'presidentdirector';

      // ---- base collection Inventories ----
      final col = _db.collection('Inventories');
      Query<Map<String, dynamic>> qRef = col;

      final QuerySnapshot<Map<String, dynamic>> snap = q.isEmpty
          ? await qRef.get()
          : await qRef.where('searchKeywords', arrayContains: q).get();

      // ---- map data & normalisasi id ----
      final raw = snap.docs.map((d) {
        final m = d.data();
        m['inventoryId'] = (m['inventoryId'] ?? d.id).toString();
        return m;
      }).toList();

      // ---- visibility (kalau ada kebijakan khusus) ----
      bool visibleForMe(Map<String, dynamic> m) {
        if (isPD) return true;
        if (uid.isEmpty) return false;

        // OPTIONAL: jika ada ownerId pada inventory
        final ownerId = (m['createdBy'] ?? '').toString();
        if (ownerId.isNotEmpty && ownerId == uid) return true;

        // OPTIONAL: jika ada listTeam mirip project (jarang untuk inventory)
        final lt = m['listTeam'];
        if (lt is List) {
          for (final it in lt) {
            if (it is Map) {
              final mm = it.cast<String, dynamic>();
              final sid = (mm['staffId'] ?? mm['staffID'] ?? mm['uid'] ?? '')
                  .toString();
              if (sid == uid) return true;

              final mail = (mm['email'] ?? mm['mail'] ?? '')
                  .toString()
                  .toLowerCase();
              if (mail.isNotEmpty && mail == emailLower) return true;
            }
          }
        }

        // Jika tidak ada aturan, default-nya terlihat
        return true;
      }

      final visible = <Map<String, dynamic>>[];
      for (final m in raw) {
        if (visibleForMe(m)) visible.add(m);
      }

      // ---- filter category & model (client-side, aman untuk skema dinamis) ----
      bool matchCategory(Map<String, dynamic> m) {
        if (cat.isEmpty) return true;
        final pc =
            (m['productCategory'] as Map?)?.cast<String, dynamic>() ?? {};
        final name = (pc['name'] ?? pc['title'] ?? '').toString();
        final id = (pc['id'] ?? pc['categoryId'] ?? '').toString();
        return id == cat || name.toLowerCase() == cat.toLowerCase();
      }

      bool matchModel(Map<String, dynamic> m) {
        if (mdl.isEmpty) return true;
        final ps =
            (m['productSelection'] as Map?)?.cast<String, dynamic>() ?? {};
        final name = (ps['name'] ?? ps['title'] ?? '').toString();
        final id = (ps['id'] ?? ps['productId'] ?? '').toString();
        return id == mdl || name.toLowerCase() == mdl.toLowerCase();
      }

      bool matchKeywordLocally(Map<String, dynamic> m) {
        if (q.isEmpty) return true;
        // backup kalau tidak pakai searchKeywords:
        final stockName = (m['stockName'] ?? '').toString().toLowerCase();
        final partNo = (m['partNo'] ?? '').toString().toLowerCase();
        return stockName.contains(q) || partNo.contains(q);
      }

      final filtered = visible
          .where(
            (m) => matchCategory(m) && matchModel(m) && matchKeywordLocally(m),
          )
          .toList();

      // ---- favorites-first ----
      final favs = <Map<String, dynamic>>[];
      final others = <Map<String, dynamic>>[];
      for (final m in filtered) {
        final favList = (m['favorites'] is List)
            ? List<String>.from(m['favorites'] as List)
            : const <String>[];
        final isFav = uid.isNotEmpty && favList.contains(uid);
        (isFav ? favs : others).add(m);
      }

      // ---- sort by stockName ----
      int byStockName(Map<String, dynamic> a, Map<String, dynamic> b) =>
          (a['stockName'] ?? '').toString().compareTo(
            (b['stockName'] ?? '').toString(),
          );

      favs.sort(byStockName);
      others.sort(byStockName);

      // ---- unique by inventoryId ----
      final seen = <String>{};
      final result = <Map<String, dynamic>>[];
      void addUnique(List<Map<String, dynamic>> src) {
        for (final m in src) {
          final id = (m['inventoryId'] ?? '').toString();
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
  Future<Either> getInventoryById(String inventoryId) async {
    try {
      if (inventoryId.isEmpty) return const Left('Inventory ID is required');

      final doc = await _db.collection('Inventories').doc(inventoryId).get();

      if (!doc.exists) return const Left('Inventory not found');

      final data = doc.data()!;
      data['inventoryId'] = data['inventoryId'] ?? doc.id; // normalize
      return Right(data);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> addInventory(InventoryFormReq req) async {
    try {
      final userEmail = _auth.currentUser?.email ?? '';

      final colRef = _db.collection('Inventories');

      final inventoryId = req.inventoryId.isNotEmpty
          ? req.inventoryId
          : colRef.doc().id;

      final inventoryMap = <String, dynamic>{
        'inventoryId': inventoryId,
        'stockName': req.stockName,
        'productCategory': req.productCategory?.toJson(),
        'productSelection': req.productSelection?.toJson(),
        'price': req.price,
        'currency': req.currency,
        'quantity': req.quantity,
        'deliveryQuantity': req.deliveryQuantity,
        'partNo': req.partNo,
        'arrivalDate': req.arrivalDate,
        'maintenancePeriod': req.maintenancePeriod,
        'maintenanceCurrency': req.maintenanceCurrency,

        'favorites': req.favorites,

        // metadata
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': userEmail,
        'updatedAt': null,
        'updatedBy': null,
        'searchKeywords': _buildAllPrefixes(req),
      };

      final batch = _db.batch();
      batch.set(colRef.doc(inventoryId), inventoryMap, SetOptions(merge: true));
      await batch.commit();

      return const Right('Project has been added successfully.');
    } catch (_) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> updateInventory(InventoryFormReq req) async {
    try {
      final userEmail = _auth.currentUser?.email ?? '';
      final colRef = _db.collection('Inventories').doc(req.inventoryId);

      final inventoryMap = <String, dynamic>{
        'stockName': req.stockName,
        'productCategory': req.productCategory?.toJson(),
        'productSelection': req.productSelection?.toJson(),

        'price': req.price,
        'currency': req.currency,
        'quantity': req.quantity,
        'deliveryQuantity': req.deliveryQuantity,
        'partNo': req.partNo,

        'arrivalDate': req.arrivalDate,

        'favorites': req.favorites,

        // metadata update
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': userEmail,
        'searchKeywords': _buildAllPrefixes(req),
      };

      final batch = _db.batch();
      batch.set(colRef, inventoryMap, SetOptions(merge: true));
      await batch.commit();

      return const Right('Inventory has been updated successfully.');
    } catch (_) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> deleteInventory(InventoryEntity req) async {
    try {
      await _db.collection('Inventories').doc(req.inventoryId).delete();

      return Right('Remove project succesfull');
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> favoriteInventory(String req) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return const Left('User is not logged in.');

      final docRef = _db.collection('Inventories').doc(req);

      var nowFav = false;

      await _db.runTransaction((tx) async {
        final snap = await tx.get(docRef);
        if (!snap.exists) throw Exception('Inventory not found');

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
        });
      });

      return Right(nowFav ? 'Added to favorites.' : 'Removed from favorites.');
    } catch (_) {
      return const Left('Please try again');
    }
  }
}
