import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';
import 'package:bluedock/common/helper/buildPrefix/build_prefixes_helper.dart';
import 'package:bluedock/common/helper/warranty/warranty_date_helper.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/inventories/domain/entities/inventory_entity.dart';
import 'package:bluedock/features/orderDeliveries/data/models/order_delivery_form_req.dart';
import 'package:bluedock/features/orderDeliveries/domain/entities/order_delivery_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class OrderDeliveryFirebaseService {
  Future<Either> searchOrderDelivery(SearchWithTypeReq query);
  Future<Either> getOrderDeliveryById(String deliveryOrderId);
  Future<Either> favoriteOrderDelivery(String deliveryOrderId);
  Future<Either> updateOrderDelivery(OrderDeliveryFormReq req);
  Future<Either> deleteOrderDelivery(OrderDeliveryEntity req);
  Future<Either> createOrderDelivery(OrderDeliveryFormReq req);
  Future<Either> completeOrderDelivery(OrderDeliveryEntity req);
}

class OrderDeliveryFirebaseServiceImpl extends OrderDeliveryFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  final _type = TypeCategorySelectionEntity(
    selectionId: 'qH7tMbLk9sXeRp2nVaYz',
    title: 'Order Delivery',
    image: 'assets/icons/orderDelivery.png',
    color: '0F6CBB',
  );

  final _projectType = TypeCategorySelectionEntity(
    selectionId: 'tMa0kAraD4mRyZjvlSjs',
    title: 'Project',
    image: 'assets/icons/project.png',
    color: '0F6CBB',
  );

  List<String> _buildAllProjectPrefixes(ProjectEntity req) {
    final all = [
      req.productCategory.title,
      req.productSelection.productModel,
      req.projectName,
      req.customerCompany,
    ].where((e) => e.trim().isNotEmpty).join(' ');
    return buildWordPrefixes(all);
  }

  List<String> _buildAllPrefixes(OrderDeliveryFormReq req) {
    String? s(dynamic v) {
      if (v == null) return null;
      final ss = v.toString().trim();
      return ss.isEmpty ? null : ss;
    }

    final base = <String?>[
      s(req.deliveryOrderId),
      s(req.purchaseOrder?.poName),
      s(req.trackingId),
      s(req.blNumber),
      s(req.shipperCompany),
      s(req.shipperContact),
      s(req.dischargeLocation),
      s(req.arrivalLocation),
      s(req.type), // inbound/outbound
    ];

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

  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('Order Deliveries');

  // ---------- Queries ----------
  @override
  Future<Either> searchOrderDelivery(SearchWithTypeReq req) async {
    try {
      final user = _auth.currentUser;
      final uid = user?.uid ?? '';
      final q = req.keyword.trim().toLowerCase();

      Query<Map<String, dynamic>> qRef = _col.orderBy(
        'createdAt',
        descending: true,
      );

      // Filter type: inbound / outbound (atau kosong = all)
      if (req.type.trim().isNotEmpty) {
        qRef = qRef.where('type', isEqualTo: req.type.trim());
      }

      final snap = q.isEmpty
          ? await qRef.get()
          : await qRef.where('searchKeywords', arrayContains: q).get();

      final all = snap.docs.map((d) {
        final m = d.data();
        m['deliveryOrderId'] = (m['deliveryOrderId'] ?? d.id).toString();
        return m;
      }).toList();

      // Prioritaskan yang favorit user saat ini
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
          final id = (m['deliveryOrderId'] ?? '').toString();
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
  Future<Either> getOrderDeliveryById(String deliveryOrderId) async {
    try {
      if (deliveryOrderId.isEmpty) {
        return const Left('Delivery Order Id is required');
      }

      final doc = await _col.doc(deliveryOrderId).get();
      if (!doc.exists) return const Left('Order Delivery not found');

      final data = doc.data()!;
      data['deliveryOrderId'] = data['deliveryOrderId'] ?? doc.id; // normalize
      return Right(data);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> favoriteOrderDelivery(String deliveryOrderId) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return const Left('User is not logged in.');

      final docRef = _col.doc(deliveryOrderId);
      var nowFav = false;

      await _db.runTransaction((tx) async {
        final snap = await tx.get(docRef);
        if (!snap.exists) throw Exception('Order delivery not found');

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
  Future<Either> deleteOrderDelivery(OrderDeliveryEntity req) async {
    try {
      final userEmail = _auth.currentUser?.email;
      final purchaseRef = _db
          .collection('Purchase Orders')
          .doc(req.purchaseOrder!.purchaseOrderId);
      final orderDeliveryRef = _col.doc(req.deliveryOrderId);

      final purchaseMap = <String, dynamic>{
        'status': 'Inactive',
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': userEmail,
      };

      final batch = _db.batch();
      batch.set(purchaseRef, purchaseMap, SetOptions(merge: true));
      batch.delete(orderDeliveryRef);
      await batch.commit();
      return const Right('Remove Order Delivery successful');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  // ---------- Mutations ----------
  @override
  Future<Either> updateOrderDelivery(OrderDeliveryFormReq req) async {
    try {
      if (req.deliveryOrderId.isEmpty) {
        return const Left('Delivery Order Id is required');
      }
      final batch = _db.batch();
      final userEmail = _auth.currentUser?.email;
      final ref = _col.doc(req.deliveryOrderId);

      final notifCol = _db.collection('Notifications');
      final notifId = notifCol.doc().id;

      if (req.purchaseOrder?.project != null) {
        final projectRef = _db
            .collection('Projects')
            .doc(req.purchaseOrder!.project!.projectId);

        final warrantyDate = computeExpiryDatesFromRule(
          rule: req.purchaseOrder!.project!.warrantyOfGoods,
          billOfLadingDate: req.estimatedDate,
          commissioningDate: null,
        );

        final projectMap = <String, dynamic>{
          'blDate': req.deliveryDate,
          'warrantyBlDate': warrantyDate[0],
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': userEmail,
        };

        batch.set(projectRef, projectMap, SetOptions(merge: true));
      }

      final notifMap = <String, dynamic>{
        'notificationId': notifId,
        'title': 'Order Delivery updated',
        'subTitle': 'Tap to open this delivery order',
        'route': AppRoutes.orderDeliveryDetail,
        'params': req.deliveryOrderId,
        'readerIds': <String>[],
        'isBroadcast': true,
        'recipientIds': <String>[],
        'deletedIds': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
        'searchKeywords': req.searchKeywords,
      };

      final map = <String, dynamic>{
        'purchaseOrder': req.purchaseOrder?.toJson(),
        'trackingId': req.trackingId,
        'blNumber': req.blNumber,
        if (req.deliveryDate != null) 'deliveryDate': req.deliveryDate,
        if (req.estimatedDate != null) 'estimatedDate': req.estimatedDate,
        'currency': req.currency,
        'price': req.price,
        'shipperCompany': req.shipperCompany,
        'shipperContact': req.shipperContact,
        'dischargeLocation': req.dischargeLocation,
        'arrivalLocation': req.arrivalLocation,
        'listComponent': req.listComponent.map((m) => m.toJson()).toList(),
        'listQuantity': req.listQuantity,
        'searchKeywords': req.searchKeywords,
        'type': req.type,
        'status': req.status,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': userEmail,
      };

      batch.set(ref, map, SetOptions(merge: true));
      batch.set(notifCol.doc(notifId), notifMap, SetOptions(merge: true));
      await batch.commit();

      return const Right('Order Delivery has been updated successfully.');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> createOrderDelivery(OrderDeliveryFormReq req) async {
    try {
      final userEmail = _auth.currentUser?.email;
      final batch = _db.batch();

      final docRef = _col.doc();
      final deliveryId = docRef.id;
      final purchaseRef = _db
          .collection('Purchase Orders')
          .doc(req.purchaseOrder!.purchaseOrderId);

      final notifCol = _db.collection('Notifications');
      final notifId = notifCol.doc().id;

      if (req.purchaseOrder?.project != null) {
        final projectRef = _db
            .collection('Projects')
            .doc(req.purchaseOrder!.project!.projectId);

        final warrantyDate = computeExpiryDatesFromRule(
          rule: req.purchaseOrder!.project!.warrantyOfGoods,
          billOfLadingDate: req.estimatedDate,
          commissioningDate: null,
        );

        final projectMap = <String, dynamic>{
          'blDate': req.deliveryDate,
          'warrantyBlDate': warrantyDate[0],
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': userEmail,
        };

        batch.set(projectRef, projectMap, SetOptions(merge: true));
      }

      final notifMap = <String, dynamic>{
        'notificationId': notifId,
        'title': 'Order Delivery has been created',
        'subTitle':
            'Tap to open this ${req.purchaseOrder!.poName} delivery order',
        'route': AppRoutes.orderDeliveryDetail,
        'params': deliveryId,
        'readerIds': <String>[],
        'isBroadcast': true,
        'recipientIds': <String>[],
        'deletedIds': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
        'searchKeywords': req.searchKeywords,
        'type': _type.toJson(),
      };

      final purchaseMap = <String, dynamic>{
        'status': 'Active',
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': userEmail,
      };

      final map = <String, dynamic>{
        'deliveryOrderId': deliveryId,
        'purchaseOrder': req.purchaseOrder?.toJson(),
        'trackingId': req.trackingId,
        'blNumber': req.blNumber,
        'deliveryDate': req.deliveryDate,
        'estimatedDate': req.estimatedDate,
        'currency': req.currency,
        'price': req.price,
        'shipperCompany': req.shipperCompany,
        'shipperContact': req.shipperContact,
        'dischargeLocation': req.dischargeLocation,
        'arrivalLocation': req.arrivalLocation,
        'listComponent': req.listComponent.map((m) => m.toJson()).toList(),
        'listQuantity': req.listQuantity,
        'searchKeywords': _buildAllPrefixes(req),
        'favorites': <String>[],
        'type': req.type,
        'status': 'Processed',
        'updatedAt': null,
        'updatedBy': null,
        'createdBy': userEmail,
        'createdAt': FieldValue.serverTimestamp(),
      };

      batch.set(purchaseRef, purchaseMap, SetOptions(merge: true));
      batch.set(docRef, map, SetOptions(merge: true));
      batch.set(notifCol.doc(notifId), notifMap, SetOptions(merge: true));
      await batch.commit();

      return const Right('Order Delivery has been created successfully.');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> completeOrderDelivery(OrderDeliveryEntity req) async {
    try {
      final userEmail = _auth.currentUser?.email;
      final batch = _db.batch();

      final docRef = _col.doc();
      final deliveryId = docRef.id;
      final purchaseRef = _db
          .collection('Purchase Orders')
          .doc(req.purchaseOrder!.purchaseOrderId);

      final notifCol = _db.collection('Notifications');
      final notifId = notifCol.doc().id;

      if (req.purchaseOrder?.project != null) {
        final notifProjId = notifCol.doc().id;

        final productRef = _db
            .collection('Products')
            .doc(req.purchaseOrder!.productCategory!.categoryId)
            .collection('Items')
            .doc(req.purchaseOrder!.productSelection!.productId);

        final projectRef = _db
            .collection('Projects')
            .doc(req.purchaseOrder!.project!.projectId);

        final warrantyDate = computeExpiryDatesFromRule(
          rule: req.purchaseOrder!.project!.warrantyOfGoods,
          billOfLadingDate: req.estimatedDate.toDate(),
          commissioningDate: DateTime.now(),
        );

        final productMap = <String, dynamic>{
          'quantity': FieldValue.increment(req.listQuantity[0]),
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': userEmail,
        };

        final projectMap = <String, dynamic>{
          'commDate': req.deliveryDate,
          'warrantyCommDate': warrantyDate[1],
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': userEmail,
        };

        final teamIds = req.purchaseOrder!.project!.listTeam
            .map((m) => m.staffId)
            .where((id) => id.isNotEmpty)
            .toSet()
            .toList();

        final notifProjMap = <String, dynamic>{
          'notificationId': notifId,
          'title':
              'Project ${req.purchaseOrder!.project!.projectName} commissioning has begun',
          'subTitle':
              'Tap to open this project ${req.purchaseOrder!.project!.projectName}',
          'route': AppRoutes.projectDetail,
          'params': req.purchaseOrder!.project!.projectId,
          'readerIds': <String>[],
          'isBroadcast': false,
          'recipientIds': teamIds,
          'deletedIds': <String>[],
          'createdAt': FieldValue.serverTimestamp(),
          'searchKeywords': _buildAllProjectPrefixes(
            req.purchaseOrder!.project!,
          ),
          'type': _projectType.toJson(),
        };

        batch.set(
          notifCol.doc(notifProjId),
          notifProjMap,
          SetOptions(merge: true),
        );
        batch.set(projectRef, projectMap, SetOptions(merge: true));
        batch.set(productRef, productMap, SetOptions(merge: true));
      }

      final notifMap = <String, dynamic>{
        'notificationId': notifId,
        'title': 'Order Delivery has been delivered',
        'subTitle':
            'Tap to open this ${req.purchaseOrder!.poName} delivery order',
        'route': AppRoutes.orderDeliveryDetail,
        'params': deliveryId,
        'readerIds': <String>[],
        'isBroadcast': true,
        'recipientIds': <String>[],
        'deletedIds': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
        'searchKeywords': req.searchKeywords,
        'type': _type.toJson(),
      };

      final purchaseMap = <String, dynamic>{
        'status': 'Done',
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': userEmail,
      };

      final map = <String, dynamic>{
        'status': 'Done',
        'updatedBy': userEmail,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      batch.set(purchaseRef, purchaseMap, SetOptions(merge: true));
      batch.set(docRef, map, SetOptions(merge: true));
      batch.set(notifCol.doc(notifId), notifMap, SetOptions(merge: true));
      await batch.commit();

      return const Right('Order Delivery has been delivered successfully.');
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
