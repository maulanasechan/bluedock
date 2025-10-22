import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';
import 'package:bluedock/common/helper/buildPrefix/build_prefixes_helper.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/purchaseOrders/data/models/purchase_order_form_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class PurchaseOrderFirebaseService {
  Future<Either> searchPurchaseOrder(SearchWithTypeReq query);
  Future<Either> getPurchaseOrderById(String invoiceId);
  Future<Either> favoritePurchaseOrder(String req);
  Future<Either> updatePurchaseOrder(PurchaseOrderFormReq req);
  Future<Either> deletePurchaseOrder(String req);
  Future<Either> fillPurchaseOrder(PurchaseOrderFormReq req);
  Future<Either> addPurchaseOrder(PurchaseOrderFormReq req);
}

class PurchaseOrderFirebaseServiceImpl extends PurchaseOrderFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  final projectType = TypeCategorySelectionEntity(
    selectionId: 'tMa0kAraD4mRyZjvlSjs',
    title: 'Project',
    image: 'assets/icons/project.png',
    color: '0F6CBB',
  );

  final purchaseType = TypeCategorySelectionEntity(
    selectionId: 'lA1UeFRAk3dwN4HqmAzP',
    title: 'Purchase Order',
    image: 'assets/icons/purchaseOrder.png',
    color: '7A869D',
  );

  List<String> _buildAllPrefixes(PurchaseOrderFormReq req) {
    final all = [
      req.arrivalDate.toString(),
      req.blDate.toString(),
      req.customerCompany,
      req.customerName,
      req.productCategory?.title,
      req.productSelection?.productModel,
      req.componentSelection?.title,
    ].where((e) => e!.trim().isNotEmpty).join(' ');
    return buildWordPrefixes(all);
  }

  @override
  Future<Either> searchPurchaseOrder(SearchWithTypeReq req) async {
    try {
      final user = _auth.currentUser;
      final uid = user?.uid ?? '';

      final col = _db.collection('Purchase Orders');
      final q = req.keyword.trim().toLowerCase();

      Query<Map<String, dynamic>> qRef = col.orderBy(
        'createdAt',
        descending: true,
      );

      if (req.type == 'Project') {
        qRef = qRef.where('type.title', isEqualTo: req.type);
      }

      if (req.type == 'Aftersales') {
        qRef = qRef.where('type.title', isEqualTo: req.type);
      }

      if (req.type == 'Self Stock') {
        qRef = qRef.where('type.title', isEqualTo: 'Purchase Order');
      }

      final snap = q.isEmpty
          ? await qRef.get()
          : await qRef.where('searchKeywords', arrayContains: q).get();

      final all = snap.docs.map((d) {
        final m = d.data();
        m['notificationId'] = (m['notificationId'] ?? d.id).toString();
        return m;
      }).toList();

      final favs = <Map<String, dynamic>>[];
      final others = <Map<String, dynamic>>[];

      for (final m in all) {
        final favList = List<String>.from(m['favorites'] ?? const <String>[]);
        final isFav = uid.isNotEmpty && favList.contains(uid);
        (isFav ? favs : others).add(m);
      }

      final seen = <String>{};
      final result = <Map<String, dynamic>>[];
      void addUnique(List<Map<String, dynamic>> src) {
        for (final m in src) {
          final id = (m['notificationId'] ?? '').toString();
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
  Future<Either> getPurchaseOrderById(String poId) async {
    try {
      if (poId.isEmpty) return const Left('Invoice Id is required');

      final doc = await _db.collection('Purchase Orders').doc(poId).get();

      if (!doc.exists) return const Left('Purchase Order not found');

      final data = doc.data()!;
      data['purchaseOrderId'] = data['purchaseOrderId'] ?? doc.id; // normalize
      return Right(data);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> favoritePurchaseOrder(String req) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return const Left('User is not logged in.');

      final docRef = _db.collection('Purchase Orders').doc(req);

      var nowFav = false;

      await _db.runTransaction((tx) async {
        final snap = await tx.get(docRef);
        if (!snap.exists) throw Exception('Purchase order not found');

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

  @override
  Future<Either> fillPurchaseOrder(PurchaseOrderFormReq req) async {
    try {
      final notifRef = _db.collection('Notifications');
      final projectsRootRef = _db
          .collection('Projects')
          .doc('List Project')
          .collection('Projects');
      final purchRootRef = _db.collection('Purchase Orders');

      final notifPurchId = notifRef.doc().id;

      DocumentReference<Map<String, dynamic>>? projRef;
      String? warrantyOfGoodsString;
      DateTime? warrantyBlDate;

      // --- Helpers
      DateTime addMonths(DateTime base, int months) {
        final y = base.year + ((base.month - 1 + months) ~/ 12);
        final m = ((base.month - 1 + months) % 12) + 1;
        final d = base.day;
        final lastDay = DateTime(y, m + 1, 0).day;
        return DateTime(y, m, d > lastDay ? lastDay : d);
      }

      int? extractBlMonths(String? warranty) {
        if (warranty == null) return null;
        final lower = warranty.toLowerCase().trim();

        // fokus pada segmen yang menyebut "bill of lading"
        final parts = lower.split(RegExp(r'\s+or\s+'));
        final blPart = parts.firstWhere(
          (p) => p.contains('bill of lading'),
          orElse: () => lower,
        );

        final reg = RegExp(r'(\d+)\s*month');
        final match = reg.firstMatch(blPart);
        if (match != null) return int.tryParse(match.group(1)!);

        // fallback global
        final global = reg.firstMatch(lower);
        return global != null ? int.tryParse(global.group(1)!) : null;
      }

      // --- Ambil Project & hitung warranty hanya jika type == Project
      Map<String, dynamic>? projectMap;
      Map<String, dynamic>? notifProjMap;
      String? notifProjId;

      if (req.type?.title == 'Project') {
        projRef = projectsRootRef.doc(req.projectId);

        final snap = await projRef.get();
        if (snap.exists) {
          final projData = snap.data();
          warrantyOfGoodsString = (projData?['warrantyOfGoods'] as String?)
              ?.trim();
        }

        // Hitung warrantyBlDate (BL only) kalau ada blDate
        if (req.blDate != null) {
          final blMonths = extractBlMonths(warrantyOfGoodsString);
          final months = blMonths ?? 12; // default 12 bln bila tak terdeteksi
          warrantyBlDate = addMonths(req.blDate!, months);
        }

        // Build project map & notif project
        notifProjId = notifRef.doc().id;
        projectMap = <String, dynamic>{
          if (req.blDate != null) 'blDate': req.blDate,
          if (warrantyBlDate != null) 'warrantyBlDate': warrantyBlDate,
        };

        notifProjMap = <String, dynamic>{
          'notificationId': notifProjId,
          'title': "Project ${req.projectName} has been updated",
          'subTitle': "Tap to open this project",
          "readerIds": <String>[],
          "isBroadcast": false,
          "route": AppRoutes.projectDetail,
          "type": projectType.toJson(),
          "params": req.projectId,
          'receipentIds': req.listTeam,
          'createdAt': FieldValue.serverTimestamp(),
          'searchKeywords': req.searchKeywords,
          'deletedIds': <String>[],
        };
      }

      // --- Purchase Order update (boleh ikut simpan warrantyBlDate kalau terhitung)
      final purchRef = purchRootRef.doc(req.purchaseOrderId);
      final purchaseMap = <String, dynamic>{
        if (req.blDate != null) 'blDate': req.blDate,
        if (req.arrivalDate != null) 'arrivalDate': req.arrivalDate,
        'price': req.price,
        'currency': req.currency,
        if (warrantyBlDate != null) 'warrantyBlDate': warrantyBlDate,
      };

      final notifPurchMap = <String, dynamic>{
        'notificationId': notifPurchId,
        'title':
            "Purchase order for Project ${req.projectName} has been updated",
        'subTitle': "Tap to open this purchase order",
        "route": AppRoutes.purchaseOrderDetail,
        "type": purchaseType.toJson(),
        "params": req.purchaseOrderId,
        "readerIds": <String>[],
        "isBroadcast": true,
        'receipentIds': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
        'searchKeywords': req.searchKeywords,
        'deletedIds': <String>[],
      };

      // --- Batch write
      final batch = _db.batch();

      if (projRef != null &&
          projectMap != null &&
          req.type?.title == 'Project') {
        batch.set(projRef, projectMap, SetOptions(merge: true));
      }

      batch.set(purchRef, purchaseMap, SetOptions(merge: true));

      if (notifProjMap != null && notifProjId != null) {
        batch.set(
          notifRef.doc(notifProjId),
          notifProjMap,
          SetOptions(merge: true),
        );
      }
      batch.set(
        notifRef.doc(notifPurchId),
        notifPurchMap,
        SetOptions(merge: true),
      );

      await batch.commit();

      return const Right(
        'Purchase order & related data have been updated successfully.',
      );
    } catch (_) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> deletePurchaseOrder(String req) async {
    try {
      await _db.collection('Purchase Orders').doc(req).delete();

      return Right('Remove Purchase Order succesfull');
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> updatePurchaseOrder(PurchaseOrderFormReq req) async {
    try {
      final userEmail = _auth.currentUser?.email;
      final purchaseRef = _db
          .collection('Purchase Orders')
          .doc(req.purchaseOrderId);

      final notifCol = _db.collection('Notifications');
      final notifId = notifCol.doc().id;

      final notifPurchaseMap = <String, dynamic>{
        'notificationId': notifId,
        'title': "Purchase Order updated for this Project ${req.projectName}",
        'subTitle': "Click this notification to go to this purchase order",
        "type": purchaseType.toJson(),
        "route": AppRoutes.purchaseOrderDetail,
        "params": req.purchaseOrderId,
        "readerIds": <String>[],
        "isBroadcast": true,
        'receipentIds': <String>[],
        'deletedIds': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
        'searchKeywords': req.searchKeywords,
      };

      final purchaseMap = <String, dynamic>{
        'projectId': req.projectId,
        'invoiceId': req.invoiceId,
        'purchaseContractNumber': req.purchaseContractNumber,
        'projectName': req.projectName,
        'projectCode': req.projectCode,
        'currency': req.currency,
        'price': req.price,
        'customerName': req.customerName,
        'customerCompany': req.customerCompany,
        'customerContact': req.customerContact,
        'productCategory': req.productCategory!.toJson(),
        'productSelection': req.productSelection!.toJson(),
        'componentSelection': req.componentSelection?.toJson(),
        'projectStatus': 'Active',
        'quantity': req.quantity,
        'searchKeywords': req.searchKeywords,
        'blDate': req.blDate,
        'arrivalDate': req.arrivalDate,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': userEmail,
      };

      final batch = _db.batch();
      batch.set(purchaseRef, purchaseMap, SetOptions(merge: true));
      batch.set(
        notifCol.doc(notifId),
        notifPurchaseMap,
        SetOptions(merge: true),
      );
      await batch.commit();

      return const Right('Purchase Order has been updated successfully.');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> addPurchaseOrder(PurchaseOrderFormReq req) async {
    try {
      final userEmail = _auth.currentUser?.email;
      final purchaseCol = _db.collection('Purchase Orders');
      final purchaseId = purchaseCol.doc().id;

      final notifCol = _db.collection('Notifications');
      final notifId = notifCol.doc().id;

      final notifPurchaseMap = <String, dynamic>{
        'notificationId': notifId,
        'title': "Purchase Order has been created",
        'subTitle': "Click this notification to go to this purchase order",
        "type": purchaseType.toJson(),
        "route": AppRoutes.purchaseOrderDetail,
        "params": purchaseId,
        "readerIds": <String>[],
        "isBroadcast": true,
        'receipentIds': <String>[],
        'deletedIds': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
        'searchKeywords': req.searchKeywords,
      };

      final purchaseMap = <String, dynamic>{
        'purchaseOrderId': purchaseId,
        'projectId': req.projectId,
        'invoiceId': req.invoiceId,
        'purchaseContractNumber': req.purchaseContractNumber,
        'projectName': req.projectName,
        'projectCode': req.projectCode,
        'currency': req.currency,
        'price': req.price,
        'customerName': userEmail,
        'customerCompany': 'PT. Auxilary Machine',
        'customerContact': req.customerContact,
        'productCategory': req.productCategory!.toJson(),
        'productSelection': req.productSelection!.toJson(),
        'componentSelection': req.componentSelection?.toJson(),
        'projectStatus': 'Active',
        'quantity': req.quantity,
        'searchKeywords': _buildAllPrefixes(req),
        'blDate': req.blDate,
        'arrivalDate': req.arrivalDate,
        'updatedAt': null,
        'updatedBy': null,
        'createdBy': userEmail,
        'createdAt': FieldValue.serverTimestamp(),
        'type': purchaseType.toJson(),
      };

      final batch = _db.batch();
      batch.set(purchaseCol.doc(notifId), purchaseMap, SetOptions(merge: true));
      batch.set(
        notifCol.doc(notifId),
        notifPurchaseMap,
        SetOptions(merge: true),
      );
      await batch.commit();

      return const Right('Purchase Order has been updated successfully.');
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
