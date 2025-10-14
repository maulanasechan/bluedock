import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class NotificationFirebaseService {
  Future<Either> searchNotif(SearchWithTypeReq query);
  Future<Either> deleteNotif(String notifId);
  Future<Either> countUnread();
  Future<Either> readNotif(String notifId);
}

class NotificationFirebaseServiceImpl extends NotificationFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _notfiDb = FirebaseFirestore.instance.collection('Notifications');

  @override
  Future<Either> searchNotif(SearchWithTypeReq req) async {
    try {
      final user = _auth.currentUser;
      final uid = user?.uid ?? '';
      if (uid.isEmpty) return const Left('User is not authenticated.');

      final col = _db.collection('Notifications');
      final q = req.keyword.trim().toLowerCase();
      final t = req.type.trim();

      Query<Map<String, dynamic>> base = col.orderBy(
        'createdAt',
        descending: true,
      );

      Query<Map<String, dynamic>> qBroadcast = base.where(
        'isBroadcast',
        isEqualTo: true,
      );
      if (t.isNotEmpty) {
        qBroadcast = qBroadcast.where('type.title', isEqualTo: t);
      }
      if (q.isNotEmpty) {
        qBroadcast = qBroadcast.where('searchKeywords', arrayContains: q);
      }

      // ===== Build direct (targeted) query =====
      Query<Map<String, dynamic>> qDirect = base.where(
        'receipentIds',
        arrayContains: uid,
      );
      if (t.isNotEmpty) {
        qDirect = qDirect.where('type.title', isEqualTo: t);
      }
      if (q.isNotEmpty) {
        qDirect = qDirect.where('searchKeywords', arrayContains: q);
      }

      // Eksekusi paralel
      final snaps = await Future.wait([qBroadcast.get(), qDirect.get()]);

      // Gabungkan + de-dupe by notificationId
      final seen = <String>{};
      final result = <Map<String, dynamic>>[];

      void addDocs(QuerySnapshot<Map<String, dynamic>> s) {
        for (final d in s.docs) {
          final m = d.data();
          final id = (m['notificationId'] ?? d.id).toString();
          if (id.isEmpty) continue;
          if (seen.add(id)) {
            result.add({...m, 'notificationId': id});
          }
        }
      }

      addDocs(snaps[0]); // broadcast
      addDocs(snaps[1]); // direct

      // Sort ulang by createdAt desc (jaga-jaga)
      result.sort((a, b) {
        final ta = a['createdAt'] as Timestamp?;
        final tb = b['createdAt'] as Timestamp?;
        final ai = ta?.millisecondsSinceEpoch ?? 0;
        final bi = tb?.millisecondsSinceEpoch ?? 0;
        return bi.compareTo(ai);
      });

      return Right(result);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> deleteNotif(String notifId) async {
    try {
      await _notfiDb.doc(notifId).delete();
      return Right('Remove notification succesfull');
    } catch (e) {
      return Left('Please try again');
    }
  }

  @override
  Future<Either> readNotif(String notifId) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null || uid.isEmpty) {
        return const Left('User is not logged in.');
      }

      final docRef = _notfiDb.doc(notifId);

      await docRef.set({
        'readerIds': FieldValue.arrayUnion([uid]),
        'readBy': {uid: FieldValue.serverTimestamp()}, // opsional jejak waktu
      }, SetOptions(merge: true));

      return const Right('Notification marked as read.');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> countUnread() async {
    try {
      final uid = _auth.currentUser?.uid ?? '';
      if (uid.isEmpty) return const Left('User is not authenticated.');

      final col = _db.collection('Notifications');

      final snaps = await Future.wait([
        col.where('isBroadcast', isEqualTo: true).get(),
        col.where('receipentIds', arrayContains: uid).get(),
      ]);

      int unread = 0;
      final seen = <String>{};

      void countUnreadDocs(QuerySnapshot<Map<String, dynamic>> s) {
        for (final d in s.docs) {
          final m = d.data();
          final id = (m['notificationId'] ?? d.id).toString();
          if (id.isEmpty || !seen.add(id)) continue;

          final readerIds = (m['readerIds'] is List)
              ? (m['readerIds'] as List).map((e) => e.toString()).toSet()
              : const <String>{};

          if (!readerIds.contains(uid)) unread += 1; // belum dibaca
        }
      }

      countUnreadDocs(snaps[0]); // broadcast
      countUnreadDocs(snaps[1]); // direct

      return Right(unread);
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
