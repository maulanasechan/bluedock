import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ProjectSectionFirebaseService {
  Future<Either> searchProject(SearchWithTypeReq query);
  Future<Either> getProjectById(String query);
}

class ProjectSectionFirebaseServiceImpl extends ProjectSectionFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  @override
  Future<Either> searchProject(SearchWithTypeReq req) async {
    try {
      final query = req.keyword;
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

      Query<Map<String, dynamic>> qRef = col;
      if (req.type != '') {
        qRef = qRef.where('status', isEqualTo: req.type);
      }

      final snap = q.isEmpty
          ? await qRef.get()
          : await qRef.where('searchKeywords', arrayContains: q).get();

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
  Future<Either> getProjectById(String projectId) async {
    try {
      if (projectId.isEmpty) return const Left('Project ID is required');

      final doc = await _db
          .collection('Projects')
          .doc('List Project')
          .collection('Projects')
          .doc(projectId)
          .get();

      if (!doc.exists) return const Left('Project not found');

      final data = doc.data()!;
      data['projectId'] = data['projectId'] ?? doc.id; // normalize
      return Right(data);
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
