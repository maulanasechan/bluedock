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

      // ===== Broadcast =====
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

      // ===== Direct (targeted) =====
      Query<Map<String, dynamic>> qDirect = base.where(
        'receipentIds',
        arrayContains: uid,
      ); // atau 'recipientIds'

      if (t.isNotEmpty) {
        qDirect = qDirect.where('type.title', isEqualTo: t);
      }
      if (q.isNotEmpty) {
        qDirect = qDirect.where('searchKeywords', arrayContains: q);
      }

      // Eksekusi paralel
      final snaps = await Future.wait([qBroadcast.get(), qDirect.get()]);

      // Gabung + skip yang ada di deletedIds
      final seen = <String>{};
      final result = <Map<String, dynamic>>[];

      bool isDeletedForMe(Map<String, dynamic> m) {
        final raw = m['deletedIds'];
        final list = (raw is List)
            ? raw.map((e) => e.toString()).toList()
            : <String>[];
        return list.contains(uid);
      }

      void addDocs(QuerySnapshot<Map<String, dynamic>> snap) {
        for (final d in snap.docs) {
          final m = d.data();
          final id = (m['notificationId'] ?? d.id).toString();
          if (id.isEmpty) continue;
          if (isDeletedForMe(m)) continue; // <-- filter client-side

          if (seen.add(id)) {
            result.add({...m, 'notificationId': id});
          }
        }
      }

      addDocs(snaps[0]); // broadcast
      addDocs(snaps[1]); // direct

      // Sort by createdAt desc
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
      final uid = _auth.currentUser?.uid;
      if (uid == null || uid.isEmpty) {
        return const Left('User is not logged in.');
      }

      final docRef = _notfiDb.doc(notifId);

      await docRef.set({
        'deletedIds': FieldValue.arrayUnion([uid]),
      }, SetOptions(merge: true));

      return const Right('Notification marked as read.');
    } catch (e) {
      return const Left('Please try again');
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

      // NOTE: kalau key sebenarnya 'recipientIds', samakan di sini juga
      final snaps = await Future.wait([
        col.where('isBroadcast', isEqualTo: true).get(),
        col.where('receipentIds', arrayContains: uid).get(),
      ]);

      int unread = 0;
      final seen = <String>{};

      bool isDeletedForMe(Map<String, dynamic> m) {
        final raw = m['deletedIds'];
        if (raw is List) {
          for (final e in raw) {
            if (uid == e.toString()) return true;
          }
        }
        return false;
      }

      void countUnreadDocs(QuerySnapshot<Map<String, dynamic>> s) {
        for (final d in s.docs) {
          final m = d.data();
          final id = (m['notificationId'] ?? d.id).toString();
          if (id.isEmpty || !seen.add(id)) continue;

          // ⛔ skip jika user sudah "menghapus" (hide) notifikasi ini
          if (isDeletedForMe(m)) continue;

          final rawReaders = m['readerIds'];
          final readerIds = <String>{};
          if (rawReaders is List) {
            for (final e in rawReaders) {
              readerIds.add(e.toString());
            }
          }

          if (!readerIds.contains(uid)) {
            unread += 1; // belum dibaca
          }
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
