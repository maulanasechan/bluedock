import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';
import 'package:bluedock/common/helper/buildPrefix/build_prefixes_helper.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';
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
  Future<Either> addPurchaseOrder(PurchaseOrderFormReq req);
}

class PurchaseOrderFirebaseServiceImpl extends PurchaseOrderFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _type = TypeCategorySelectionEntity(
    selectionId: 'lA1UeFRAk3dwN4HqmAzP',
    title: 'Purchase Order',
    image: 'assets/icons/purchaseOrder.png',
    color: '7A869D',
  );

  List<String> _buildAllPrefixes(PurchaseOrderFormReq req) {
    String? s(dynamic v) {
      if (v == null) return null;
      final s = v.toString().trim();
      return s.isEmpty ? null : s;
    }

    final base = <String?>[
      s(req.poName),
      s(req.sellerCompany),
      s(req.sellerName),
      s(req.productCategory?.title),
      s(req.productSelection?.productModel),
    ];

    // listComponent diasumsikan: List<InventoryEntity>?
    final components =
        (req.listComponent as List<InventoryEntity>?)
            ?.expand((inv) => <String?>[s(inv.stockName), s(inv.partNo)])
            .toList() ??
        const <String>[];

    final all = <String>[
      ...base.whereType<String>(),
      ...components.whereType<String>(),
    ].join(' ');

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
        'title':
            "Purchase Order updated for this ${req.type.title} ${req.project != null ? req.project!.projectName : ''}",
        'subTitle': "Click this notification to go to this purchase order",
        // "type": ,
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
        // 'projectId': req.projectId,
        // 'invoiceId': req.invoiceId,
        // 'purchaseContractNumber': req.purchaseContractNumber,
        // 'projectName': req.projectName,
        // 'projectCode': req.projectCode,
        'currency': req.currency,
        'price': req.price,
        // 'customerName': req.customerName,
        // 'customerCompany': req.customerCompany,
        // 'customerContact': req.customerContact,
        'productCategory': req.productCategory!.toJson(),
        'productSelection': req.productSelection!.toJson(),
        // 'listTeamIds': req.listTeamIds,
        'listConponent': req.listComponent.map((m) => m.toJson()).toList(),
        'projectStatus': 'Active',
        'quantity': req.quantity,
        'searchKeywords': req.searchKeywords,
        // 'blNumber': req.blNumber,
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

      // Bangun nama PO dengan fallback yang aman
      final productCategory = (req.project == null)
          ? req.productCategory?.toJson()
          : req.project!.productCategory.toJson();

      final productSelection = (req.project == null)
          ? req.productSelection?.toJson()
          : req.project!.productSelection.toJson();

      final poName = (req.poName.isNotEmpty)
          ? req.poName
          : '${req.type.title} - ${req.project!.projectName}';

      final notifPurchaseMap = <String, dynamic>{
        'notificationId': notifId,
        'title': 'Purchase Order has been created',
        'subTitle': 'Click this notification to go to this $poName',
        'type': _type.toJson(),
        'route': AppRoutes.purchaseOrderDetail,
        'params': purchaseId,
        'readerIds': <String>[],
        'isBroadcast': true,
        'recipientIds': <String>[], // (opsional) perbaiki ejaan
        'deletedIds': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
        'searchKeywords': req.searchKeywords,
      };

      final purchaseMap = <String, dynamic>{
        'purchaseOrderId': purchaseId,
        'poName': poName,
        'project': req.project?.toJson(),
        'currency': req.currency,
        'price': req.price,
        'sellerName': req.sellerName,
        'sellerCompany': req.sellerCompany,
        'sellerContact': req.sellerContact,
        'productCategory': productCategory,
        'productSelection': productSelection,
        'listComponent': req.listComponent.map((m) => m.toJson()).toList(),
        'quantity': req.quantity,
        'searchKeywords': _buildAllPrefixes(req),
        'updatedAt': null,
        'updatedBy': null,
        'createdBy': userEmail,
        'createdAt': FieldValue.serverTimestamp(),
        'type': req.type.toJson(),
        'status': 'Inactive',
      };

      final batch = _db.batch();
      // ← pakai purchaseId, bukan notifId
      batch.set(
        purchaseCol.doc(purchaseId),
        purchaseMap,
        SetOptions(merge: true),
      );
      batch.set(
        notifCol.doc(notifId),
        notifPurchaseMap,
        SetOptions(merge: true),
      );
      await batch.commit();

      return const Right('Purchase Order has been created successfully.');
    } catch (e) {
      // kamu bisa log e.toString() untuk debugging
      return const Left('Please try again');
    }
  }
}
