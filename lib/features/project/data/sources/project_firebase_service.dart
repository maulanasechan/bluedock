import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';
import 'package:bluedock/common/helper/buildPrefix/build_prefixes_helper.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/project/data/models/project_form_req.dart';
import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ProjectFirebaseService {
  Future<Either> addProject(ProjectFormReq req);
  Future<Either> updateProject(ProjectFormReq req);
  Future<Either> deleteProject(ProjectEntity req);
  Future<Either> favoriteProject(String req);
  Future<Either> commisionProject(ProjectEntity req);
}

class ProjectFirebaseServiceImpl extends ProjectFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  final projectType = TypeCategorySelectionEntity(
    selectionId: 'tMa0kAraD4mRyZjvlSjs',
    title: 'Project',
    image: 'assets/icons/project.png',
    color: '0F6CBB',
  );

  final invoiceType = TypeCategorySelectionEntity(
    selectionId: 'oVrgn69eeE1WBVd9wURZ',
    title: 'Invoice',
    image: 'assets/icons/invoice.png',
    color: 'F37908',
  );

  // Project
  List<String> _buildAllPrefixes(ProjectFormReq req) {
    final all = [
      req.purchaseContractNumber,
      req.projectName,
      req.projectCode,
      req.customerName,
      req.customerCompany,
      req.productCategory?.title,
      req.productSelection?.productModel,
    ].where((e) => e!.trim().isNotEmpty).join(' ');
    return buildWordPrefixes(all);
  }

  List<String> _buildAllPrefixesEntity(ProjectEntity req) {
    final all = [
      req.purchaseContractNumber,
      req.projectName,
      req.projectCode,
      req.customerName,
      req.customerCompany,
      req.productCategory.title,
      req.productSelection.productModel,
    ].where((e) => e.trim().isNotEmpty).join(' ');
    return buildWordPrefixes(all);
  }

  List<double> extractPercentFractions(String s) {
    final re = RegExp(r'(\d+(?:\.\d+)?)\s*%');
    return re
        .allMatches(s)
        .map((m) => double.parse(m.group(1)!) / 100.0)
        .toList();
  }

  @override
  Future<Either> addProject(ProjectFormReq req) async {
    try {
      final userEmail = _auth.currentUser?.email ?? '';

      final colRef = _db.collection('Projects');

      final invRef = _db.collection('Invoices');
      final notifRef = _db.collection('Notifications');

      final projectId = req.projectId.isNotEmpty
          ? req.projectId
          : colRef.doc().id;

      final invoiceId = invRef.doc().id;
      final notifProjectId = notifRef.doc().id;
      final notifInvoiceId = notifRef.doc().id;
      final listPrice = extractPercentFractions(req.payment);

      final teamIds = req.listTeam
          .map((m) => m.staffId)
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      final notifMap = <String, dynamic>{
        'notificationId': notifProjectId,
        'title': "You've been added to Project ${req.projectName}",
        'subTitle': "Click this notification to go to this project",
        "type": projectType.toJson(),
        "route": AppRoutes.projectDetail,
        "params": projectId,
        "readerIds": <String>[],
        "isBroadcast": false,
        'receipentIds': teamIds,
        'createdAt': FieldValue.serverTimestamp(),
        'searchKeywords': _buildAllPrefixes(req),
        'deletedIds': <String>[],
      };

      final notifInvoiceMap = <String, dynamic>{
        'notificationId': notifInvoiceId,
        'title': "Invoice created for project ${req.projectName}",
        'subTitle': "Click this notification to go to this invoice",
        "type": invoiceType.toJson(),
        "route": AppRoutes.invoiceDetail,
        "params": invoiceId,
        "readerIds": <String>[],
        "isBroadcast": true,
        'receipentIds': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
        'searchKeywords': _buildAllPrefixes(req),
        'deletedIds': <String>[],
      };

      final invoiceMap = <String, dynamic>{
        'invoiceId': invoiceId,
        'projectId': projectId,
        'purchaseContractNumber': req.purchaseContractNumber,
        'projectName': req.projectName,
        'projectCode': req.projectCode,
        'customerName': req.customerName,
        'customerCompany': req.customerCompany,
        'customerContact': req.customerContact,
        'productCategory': req.productCategory?.toJson(),
        'productSelection': req.productSelection?.toJson(),
        'dpAmount': listPrice[0] * req.price!.toInt(),
        'lcAmount': listPrice[1] * req.price!.toInt(),
        'dpStatus': false,
        'lcStatus': false,
        'totalPrice': req.price,
        'currency': req.currency,
        'payment': req.payment,
        'quantity': req.quantity,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': userEmail,
        "projectStatus": 'Inactive',
        'favorites': req.favorites,
        'type': projectType.toJson(),
        "issuedDate": FieldValue.serverTimestamp(),
        "dpIssuedDate": FieldValue.serverTimestamp(),
        "lcIssuedDate": null,
        "dpApprovedDate": null,
        "lcApprovedDate": null,
        "dpApprovedBy": '',
        "lcApprovedBy": '',
        'searchKeywords': _buildAllPrefixes(req),
      };

      final projectMap = <String, dynamic>{
        'projectId': projectId,
        'invoiceId': invoiceId,
        'purchaseContractNumber': req.purchaseContractNumber,
        'projectName': req.projectName,
        'projectCode': req.projectCode,
        'customerName': req.customerName,
        'customerCompany': req.customerCompany,
        'customerContact': req.customerContact,
        'productCategory': req.productCategory?.toJson(),
        'productSelection': req.productSelection?.toJson(),
        'price': req.price,
        'currency': req.currency,
        'payment': req.payment,
        'delivery': req.delivery,
        'warrantyOfGoods': req.warrantyOfGoods,
        'projectDescription': req.projectDescription,
        'listTeam': req.listTeam.map((m) => m.toJson()).toList(),
        'listTeamIds': teamIds,
        'quantity': req.quantity,
        'status': 'Inactive',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': null,
        'blDate': null,
        'commDate': null,
        'warrantyBlDate': null,
        'warrantyCommDate': null,
        'createdBy': userEmail,
        'favorites': req.favorites,
        'searchKeywords': _buildAllPrefixes(req),
      };

      final batch = _db.batch();
      batch.set(colRef.doc(projectId), projectMap, SetOptions(merge: true));
      batch.set(
        notifRef.doc(notifProjectId),
        notifMap,
        SetOptions(merge: true),
      );
      batch.set(
        notifRef.doc(notifInvoiceId),
        notifInvoiceMap,
        SetOptions(merge: true),
      );
      batch.set(invRef.doc(invoiceId), invoiceMap, SetOptions(merge: true));
      await batch.commit();

      return const Right('Project has been added successfully.');
    } catch (_) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> updateProject(ProjectFormReq req) async {
    try {
      final colRef = _db.collection('Projects').doc(req.projectId);

      final invRef = _db.collection('Invoices').doc(req.invoiceId);

      final listPrice = extractPercentFractions(req.payment);

      final invoiceMap = <String, dynamic>{
        'purchaseContractNumber': req.purchaseContractNumber,
        'projectName': req.projectName,
        'projectCode': req.projectCode,
        'customerName': req.customerName,
        'customerCompany': req.customerCompany,
        'customerContact': req.customerContact,
        'productCategory': req.productCategory?.toJson(),
        'productSelection': req.productSelection?.toJson(),
        'dpAmount': listPrice[0] * req.price!.toInt(),
        'lcAmount': listPrice[1] * req.price!.toInt(),
        'totalPrice': req.price,
        'currency': req.currency,
        'payment': req.payment,
        'quantity': req.quantity,
        "issuedDate": FieldValue.serverTimestamp(),
        "dpIssuedDate": FieldValue.serverTimestamp(),
        'searchKeywords': _buildAllPrefixes(req),
      };

      final teamIds = req.listTeam
          .map((m) => m.staffId)
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      final projectMap = <String, dynamic>{
        'purchaseContractNumber': req.purchaseContractNumber,
        'projectName': req.projectName,
        'projectCode': req.projectCode,
        'customerName': req.customerName,
        'customerCompany': req.customerCompany,
        'customerContact': req.customerContact,
        'productCategory': req.productCategory?.toJson(),
        'productSelection': req.productSelection?.toJson(),
        'price': req.price,
        'currency': req.currency,
        'payment': req.payment,
        'delivery': req.delivery,
        'warrantyOfGoods': req.warrantyOfGoods,
        'projectDescription': req.projectDescription,
        'listTeam': req.listTeam.map((m) => m.toJson()).toList(),
        'listTeamIds': teamIds,
        'quantity': req.quantity,
        'updatedAt': FieldValue.serverTimestamp(),
        'favorites': req.favorites,
        'searchKeywords': _buildAllPrefixes(req),
      };
      final notifRef = _db.collection('Notifications');
      final notifId = notifRef.doc().id;
      final notifInvoiceId = notifRef.doc().id;

      final notifMap = <String, dynamic>{
        'notificationId': notifId,
        'title': "Project ${req.projectName} had been updated",
        'subTitle': "Click this notification to go to this project",
        "readerIds": <String>[],
        "isBroadcast": false,
        "route": AppRoutes.projectDetail,
        "type": projectType.toJson(),
        "params": req.projectId,
        'receipentIds': teamIds,
        'createdAt': FieldValue.serverTimestamp(),
        'searchKeywords': _buildAllPrefixes(req),
        'deletedIds': <String>[],
      };

      final notifInvoiceMap = <String, dynamic>{
        'notificationId': notifInvoiceId,
        'title': "This Project ${req.projectName} invoice had ben updated",
        'subTitle': "Click this notification to go to this invoice",
        "route": AppRoutes.invoiceDetail,
        "type": invoiceType.toJson(),
        "params": req.invoiceId,
        "readerIds": <String>[],
        "isBroadcast": true,
        'receipentIds': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
        'searchKeywords': _buildAllPrefixes(req),
        'deletedIds': <String>[],
      };

      final batch = _db.batch();
      batch.set(colRef, projectMap, SetOptions(merge: true));
      batch.set(invRef, invoiceMap, SetOptions(merge: true));
      batch.set(notifRef.doc(notifId), notifMap, SetOptions(merge: true));
      batch.set(
        notifRef.doc(notifInvoiceId),
        notifInvoiceMap,
        SetOptions(merge: true),
      );
      await batch.commit();

      return const Right('Product has been updated successfully.');
    } catch (_) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> deleteProject(ProjectEntity req) async {
    try {
      await _db.collection('Invoices').doc(req.invoiceId).delete();

      await _db.collection('Projects').doc(req.projectId).delete();

      return Right('Remove project succesfull');
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> favoriteProject(String req) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return const Left('User is not logged in.');

      final docRef = _db.collection('Projects').doc(req);

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
  Future<Either> commisionProject(ProjectEntity req) async {
    try {
      final colRef = _db.collection('Projects').doc(req.projectId);

      final teamIds = req.listTeam
          .map((m) => m.staffId)
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      // ---------------- Helpers ----------------
      DateTime addMonths(DateTime base, int months) {
        final y = base.year + ((base.month - 1 + months) ~/ 12);
        final m = ((base.month - 1 + months) % 12) + 1;
        final d = base.day;
        final lastDay = DateTime(y, m + 1, 0).day;
        return DateTime(y, m, d > lastDay ? lastDay : d);
      }

      int? extractCommMonths(String? warranty) {
        if (warranty == null) return null;
        final lower = warranty.toLowerCase().trim();
        final parts = lower.split(RegExp(r'\s+or\s+'));
        final commPart = parts.firstWhere(
          (p) => p.contains('commission'),
          orElse: () => lower,
        );
        final reg = RegExp(r'(\d+)\s*month');
        final match = reg.firstMatch(commPart);
        if (match != null) return int.tryParse(match.group(1)!);
        final global = reg.firstMatch(lower);
        return global != null ? int.tryParse(global.group(1)!) : null;
      }

      DateTime? asDateTime(dynamic v) {
        if (v == null) return null;
        if (v is DateTime) return v;
        if (v is Timestamp) return v.toDate();
        return null; // kalau tipe lain, abaikan
      }

      // ---------------- Ambil warrantyOfGoods & hitung warrantyCommDate ----------------
      String? warrantyOfGoodsString;
      DateTime? warrantyCommDate;

      final projSnap = await colRef.get();
      if (projSnap.exists) {
        final data = projSnap.data();
        warrantyOfGoodsString = (data?['warrantyOfGoods'] as String?)?.trim();
      }

      final commMonths = extractCommMonths(warrantyOfGoodsString);
      if (commMonths != null) {
        DateTime? baseComm = asDateTime(req.commDate);
        if (baseComm == null && req.status == 'Active') {
          // commissioning baru dimulai: pakai waktu lokal sebagai base kalkulasi
          baseComm = DateTime.now();
        }
        if (baseComm != null) {
          warrantyCommDate = addMonths(baseComm, commMonths);
        }
      }

      // ---------------- Project & Notifications ----------------
      final projectMap = <String, dynamic>{
        'status': req.status == 'Active' ? 'Commissioning' : 'Done',
        // simpan commDate: kalau Active biar server yang set; kalau tidak, simpan nilai yang ada
        'commDate': req.status == 'Active'
            ? FieldValue.serverTimestamp()
            : asDateTime(req.commDate),
        if (warrantyCommDate != null) 'warrantyCommDate': warrantyCommDate,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final notifRef = _db.collection('Notifications');
      final notifId = notifRef.doc().id;

      DocumentReference<Map<String, dynamic>>? invRef;
      String? notifInvoiceId;
      Map<String, dynamic>? invoiceMap;
      Map<String, dynamic>? notifInvoiceMap;

      if (req.status == 'Commissioning') {
        invRef = _db.collection('Invoices').doc(req.invoiceId);
        notifInvoiceId = notifRef.doc().id;

        invoiceMap = <String, dynamic>{
          'projectStatus': 'Done',
          'issuedDate': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        };

        notifInvoiceMap = <String, dynamic>{
          'notificationId': notifInvoiceId,
          'title': "Project ${req.projectName} invoice has been updated",
          'subTitle': "Click this notification to go to this invoice",
          "route": AppRoutes.invoiceDetail,
          "type": invoiceType.toJson(),
          "params": req.invoiceId,
          "readerIds": <String>[],
          "isBroadcast": true,
          'receipentIds': <String>[],
          'createdAt': FieldValue.serverTimestamp(),
          'searchKeywords': _buildAllPrefixesEntity(req),
          'deletedIds': <String>[],
        };
      }

      final notifMap = <String, dynamic>{
        'notificationId': notifId,
        'title': "Project ${req.projectName} has been updated",
        'subTitle': "Click this notification to go to this project",
        "readerIds": <String>[],
        "isBroadcast": false,
        "route": AppRoutes.projectDetail,
        "type": projectType.toJson(),
        "params": req.projectId,
        'receipentIds': teamIds,
        'createdAt': FieldValue.serverTimestamp(),
        'searchKeywords': _buildAllPrefixesEntity(req),
        'deletedIds': <String>[],
      };

      // ---------------- Batch commit ----------------
      final batch = _db.batch();
      batch.set(colRef, projectMap, SetOptions(merge: true));
      batch.set(notifRef.doc(notifId), notifMap, SetOptions(merge: true));

      if (invRef != null && invoiceMap != null) {
        batch.set(invRef, invoiceMap, SetOptions(merge: true));
      }
      if (notifInvoiceId != null && notifInvoiceMap != null) {
        batch.set(
          notifRef.doc(notifInvoiceId),
          notifInvoiceMap,
          SetOptions(merge: true),
        );
      }

      await batch.commit();

      return const Right('Project has been updated successfully.');
    } catch (_) {
      return const Left('Please try again');
    }
  }
}
