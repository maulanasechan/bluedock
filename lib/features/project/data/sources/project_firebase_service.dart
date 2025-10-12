import 'package:bluedock/common/helper/buildPrefix/build_prefixes_helper.dart';
import 'package:bluedock/features/project/data/models/project_form_req.dart';
import 'package:bluedock/common/domain/entities/project_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ProjectFirebaseService {
  Future<Either> addProject(ProjectFormReq req);
  Future<Either> updateProject(ProjectFormReq req);
  Future<Either> searchProject(String query);
  Future<Either> deleteProject(ProjectEntity req);
  Future<Either> favoriteProject(String req);
}

class ProjectFirebaseServiceImpl extends ProjectFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

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

      final colRef = _db
          .collection('Projects')
          .doc('List Project')
          .collection('Projects');

      final invRef = _db
          .collection('Invoices')
          .doc('List Project')
          .collection('Projects');

      final projectId = req.projectId.isNotEmpty
          ? req.projectId
          : colRef.doc().id;

      final invoiceId = invRef.doc().id;
      final listPrice = extractPercentFractions(req.payment);

      final teamIds = req.listTeam
          .map((m) => m.staffId)
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

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
        'totalPrice': req.price,
        'currency': req.currency,
        'payment': req.payment,
        'quantity': req.quantity,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': null,
        'createdBy': userEmail,
        'updatedBy': '',
        'favorites': req.favorites,
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
        'maintenancePeriod': req.maintenancePeriod,
        'maintenanceCurrency': req.maintenanceCurrency,
        'listTeam': req.listTeam.map((m) => m.toJson()).toList(),
        'listTeamIds': teamIds,
        'quantity': req.quantity,
        'status': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': null,
        'createdBy': userEmail,
        'updatedBy': '',
        'favorites': req.favorites,
        'searchKeywords': _buildAllPrefixes(req),
      };

      await colRef.doc(projectId).set(projectMap, SetOptions(merge: true));
      await invRef.doc(invoiceId).set(invoiceMap, SetOptions(merge: true));

      return const Right('Product has been added successfully.');
    } catch (_) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> updateProject(ProjectFormReq req) async {
    try {
      final userEmail = _auth.currentUser?.email ?? '';

      final colRef = _db
          .collection('Projects')
          .doc('List Project')
          .collection('Projects')
          .doc(req.projectId);

      final invRef = _db
          .collection('Invoices')
          .doc('List Project')
          .collection('Projects')
          .doc(req.invoiceId);

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
        'maintenancePeriod': req.maintenancePeriod,
        'maintenanceCurrency': req.maintenanceCurrency,
        'listTeam': req.listTeam.map((m) => m.toJson()).toList(),
        'listTeamIds': teamIds,
        'quantity': req.quantity,
        'status': false,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': userEmail,
        'favorites': req.favorites,
        'searchKeywords': _buildAllPrefixes(req),
      };

      await colRef.set(projectMap, SetOptions(merge: true));
      await invRef.set(invoiceMap, SetOptions(merge: true));

      return const Right('Product has been added successfully.');
    } catch (_) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> searchProject(String query) async {
    try {
      final user = _auth.currentUser;
      final uid = user?.uid ?? '';
      final emailLower = (user?.email ?? '').toLowerCase();
      final q = query.trim().toLowerCase();

      String safeRoleTitle(Map<String, dynamic>? m) {
        if (m == null) return '';
        final t = (m['title'] ?? '').toString();
        return t.toLowerCase().replaceAll(RegExp(r'\s+'), '');
      }

      final meDoc = await _db.collection('Staff').doc(uid).get();
      final me = meDoc.data() as Map<String, dynamic>;
      final roleTitle = safeRoleTitle(
        (me['role'] as Map?)?.cast<String, dynamic>(),
      );
      final isPD = roleTitle == 'presidentdirector';

      final col = _db
          .collection('Projects')
          .doc('List Project')
          .collection('Projects');

      final snap = q.isEmpty
          ? await col.get()
          : await col.where('searchKeywords', arrayContains: q).get();

      final all = snap.docs.map((d) {
        final m = d.data();
        m['projectId'] = (m['projectId'] ?? d.id).toString();
        return m;
      }).toList();

      bool containsCurrentUser(Map<String, dynamic> m) {
        if (isPD) return true;
        if (uid.isEmpty) return false;

        final ids =
            (m['listTeamIds'] as List?)?.map((e) => e.toString()).toSet() ??
            const <String>{};
        if (ids.contains(uid)) return true;

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
        return false;
      }

      final visible = <Map<String, dynamic>>[];
      for (final m in all) {
        final ok = containsCurrentUser(m);
        if (ok) visible.add(m);
      }

      final favs = <Map<String, dynamic>>[];
      final others = <Map<String, dynamic>>[];
      for (final m in visible) {
        final favList = List<String>.from(m['favorites'] ?? const <String>[]);
        final isFav = uid.isNotEmpty && favList.contains(uid);
        (isFav ? favs : others).add(m);
      }

      int byName(Map<String, dynamic> a, Map<String, dynamic> b) =>
          (a['projectName'] ?? '').toString().compareTo(
            (b['projectName'] ?? '').toString(),
          );

      favs.sort(byName);
      others.sort(byName);

      final seen = <String>{};
      final result = <Map<String, dynamic>>[];
      void addUnique(List<Map<String, dynamic>> src) {
        for (final m in src) {
          final id = (m['projectId'] ?? '').toString();
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
  Future<Either> deleteProject(ProjectEntity req) async {
    try {
      await _db
          .collection('Invoices')
          .doc('List Project')
          .collection('Projects')
          .doc(req.invoiceId)
          .delete();

      await _db
          .collection('Projects')
          .doc('List Project')
          .collection('Projects')
          .doc(req.projectId)
          .delete();

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

      final userEmail = _auth.currentUser?.email ?? '';

      final docRef = _db
          .collection('Projects')
          .doc('List Project')
          .collection('Projects')
          .doc(req);

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
}
