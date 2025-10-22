import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/invoice/domain/entities/invoice_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class InvoiceFirebaseService {
  Future<Either> searchInvoice(SearchWithTypeReq query);
  Future<Either> getInvoiceById(String invoiceId);
  Future<Either> favoriteInvoice(String req);
  Future<Either> paidInvoice(InvoiceEntity invoice);
}

class InvoiceFirebaseServiceImpl extends InvoiceFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  final invoiceType = TypeCategorySelectionEntity(
    selectionId: 'oVrgn69eeE1WBVd9wURZ',
    title: 'Invoice',
    image: 'assets/icons/invoice.png',
    color: 'F37908',
  );

  final purchaseType = TypeCategorySelectionEntity(
    selectionId: 'lA1UeFRAk3dwN4HqmAzP',
    title: 'Purchase Order',
    image: 'assets/icons/purchaseOrder.png',
    color: '7A869D',
  );

  @override
  Future<Either> searchInvoice(SearchWithTypeReq req) async {
    try {
      final user = _auth.currentUser;
      final uid = user?.uid ?? '';

      final col = _db.collection('Invoices');
      final q = req.keyword.trim().toLowerCase();

      Query<Map<String, dynamic>> qRef = col.orderBy(
        'issuedDate',
        descending: true,
      );

      if (req.type == 'Down Payment') {
        qRef = qRef.where('dpStatus', isEqualTo: false);
      }

      if (req.type == 'Letter of Contract') {
        qRef = qRef
            .where('dpStatus', isEqualTo: true)
            .where('lcStatus', isEqualTo: false);
      }

      final snap = q.isEmpty
          ? await qRef.get()
          : await qRef.where('searchKeywords', arrayContains: q).get();

      final all = snap.docs.map((d) {
        final m = d.data();
        m['invoiceId'] = (m['invoiceId'] ?? d.id).toString();
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
          final id = (m['invoiceId'] ?? '').toString();
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
  Future<Either> getInvoiceById(String invoiceId) async {
    try {
      if (invoiceId.isEmpty) return const Left('Invoice Id is required');

      final doc = await _db.collection('Invoices').doc(invoiceId).get();

      if (!doc.exists) return const Left('Invoice not found');

      final data = doc.data()!;
      data['invoiceId'] = data['invoiceId'] ?? doc.id; // normalize
      return Right(data);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> favoriteInvoice(String req) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return const Left('User is not logged in.');

      final docRef = _db.collection('Invoices').doc(req);

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
        });
      });

      return Right(nowFav ? 'Added to favorites.' : 'Removed from favorites.');
    } catch (_) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> paidInvoice(InvoiceEntity req) async {
    try {
      final userEmail = _auth.currentUser?.email;

      final projectRef = _db
          .collection('Projects')
          .doc('List Project')
          .collection('Projects')
          .doc(req.projectId);

      final invRef = _db.collection('Invoices').doc(req.invoiceId);
      final purchaseCol = _db.collection('Purchase Orders');
      final purchaseOrderId = purchaseCol.doc().id;

      final notifCol = _db.collection('Notifications');
      final notifInvoiceId = notifCol.doc().id;
      final notifPurchaseId = notifCol.doc().id;

      final notifInvoiceMap = <String, dynamic>{
        'notificationId': notifInvoiceId,
        'title': "Project ${req.projectName} Down Payment has been paid",
        'subTitle': "Click this notification to go to this invoice",
        "type": invoiceType.toJson(),
        "route": AppRoutes.invoiceDetail,
        "params": req.invoiceId,
        "readerIds": <String>[],
        "isBroadcast": true,
        'receipentIds': <String>[],
        'deletedIds': <String>[],
        'searchKeywords': req.searchKeywords,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final notifPurchaseMap = <String, dynamic>{
        'notificationId': notifPurchaseId,
        'title': "Purchase Order created for this Project ${req.projectName}",
        'subTitle': "Click this notification to go to this purchase order",
        "type": purchaseType.toJson(),
        "route": AppRoutes.purchaseOrderDetail,
        "params": purchaseOrderId,
        "readerIds": <String>[],
        "isBroadcast": true,
        'receipentIds': <String>[],
        'deletedIds': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
        'searchKeywords': req.searchKeywords,
      };

      final purchaseMap = <String, dynamic>{
        'purchaseOrderId': purchaseOrderId,
        'projectId': req.projectId,
        'invoiceId': req.invoiceId,
        'purchaseContractNumber': req.purchaseContractNumber,
        'projectName': req.projectName,
        'projectCode': req.projectCode,
        'currency': req.currency,
        'price': null,
        'customerName': req.customerName,
        'customerCompany': req.customerCompany,
        'customerContact': req.customerContact,
        'productCategory': req.productCategory.toJson(),
        'productSelection': req.productSelection.toJson(),
        'componentSelection': null,
        'projectStatus': 'Active',
        'quantity': req.quantity,
        'listTeamIds': req.listTeamIds,
        'searchKeywords': req.searchKeywords,
        'createdAt': FieldValue.serverTimestamp(),
        'favorites': <String>[],
        'blDate': null,
        'arrivalDate': null,
        'updatedAt': null,
        'updatedBy': null,
        'type': req.type.toJson(),
        "createdBy": userEmail,
      };

      final invoiceMap = <String, dynamic>{
        'projectStatus': 'Active',
        "dpStatus": true,
        "lcStatus": req.dpStatus == true ? true : false,
        "dpIssuedDate": req.dpStatus == false
            ? FieldValue.serverTimestamp()
            : null,
        "lcIssuedDate": req.dpStatus == true
            ? FieldValue.serverTimestamp()
            : null,
      };

      final projectMap = <String, dynamic>{"status": 'Active'};

      final batch = _db.batch();
      batch.set(projectRef, projectMap, SetOptions(merge: true));
      batch.set(
        purchaseCol.doc(purchaseOrderId),
        purchaseMap,
        SetOptions(merge: true),
      );
      batch.set(
        notifCol.doc(notifPurchaseId),
        notifPurchaseMap,
        SetOptions(merge: true),
      );
      batch.set(
        notifCol.doc(notifInvoiceId),
        notifInvoiceMap,
        SetOptions(merge: true),
      );
      batch.set(invRef, invoiceMap, SetOptions(merge: true));
      await batch.commit();

      return const Right('Invoice has been updated successfully.');
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
