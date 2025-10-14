import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';
import 'package:bluedock/common/helper/buildPrefix/build_prefixes_helper.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/dailyTask/data/models/daily_task_form_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class DailyTaskFirebaseService {
  Future<Either> getAllDailyTask(DateTime req);
  Future<Either> addDailyTask(DailyTaskFormReq req);
  Future<Either> updateDailyTask(DailyTaskFormReq req);
  Future<Either> deleteDailyTask(String req);
}

class DailyTaskFirebaseServiceImpl extends DailyTaskFirebaseService {
  final _auth = FirebaseAuth.instance;
  final _baseDb = FirebaseFirestore.instance;
  final _db = FirebaseFirestore.instance
      .collection('Daily Task')
      .doc('List Daily Task')
      .collection('Daily Task');

  final type = TypeCategorySelectionEntity(
    selectionId: 'lA1UeFRAk3dwN4HqmAzP',
    title: 'Daily Task',
    image: 'assets/icons/dailyTask.png',
    color: 'F37908',
  );

  Timestamp? _ts(DateTime? d, TimeOfDay? t) {
    if (d == null || t == null) return null;
    final merged = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    return Timestamp.fromDate(merged);
  }

  Timestamp _dayStart(DateTime d) =>
      Timestamp.fromDate(DateTime(d.year, d.month, d.day));
  Timestamp _dayNext(DateTime d) => Timestamp.fromDate(
    DateTime(d.year, d.month, d.day).add(const Duration(days: 1)),
  );

  List<String> _buildAllPrefixes(DailyTaskFormReq req) {
    final all = [
      req.title,
      req.projectName,
      req.customerCompany,
      DateFormat('dd MMM yyyy, HH:mm').format(req.date!),
    ].where((e) => e.trim().isNotEmpty).join(' ');
    return buildWordPrefixes(all);
  }

  @override
  Future<Either> getAllDailyTask(DateTime req) async {
    try {
      final user = _auth.currentUser;
      final uid = user?.uid ?? '';
      if (uid.isEmpty) return const Left('USER_NOT_LOGGED_IN');

      final start = _dayStart(req);
      final next = _dayNext(req);

      final snap = await _db
          .where('date', isGreaterThanOrEqualTo: start)
          .where('date', isLessThan: next)
          .get();

      final result = <Map<String, dynamic>>[];
      for (final d in snap.docs) {
        final m = d.data();
        final ids = (m['listParticipantIds'] is List)
            ? List<String>.from(m['listParticipantIds'])
            : const <String>[];

        if (ids.contains(uid)) {
          m['dailyTaskId'] = (m['dailyTaskId'] ?? d.id).toString();
          result.add(m);
        }
      }
      return Right(result);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> addDailyTask(DailyTaskFormReq req) async {
    try {
      final userEmail = _auth.currentUser?.email ?? '';

      final dailyTaskId = req.dailyTaskId.isNotEmpty
          ? req.dailyTaskId
          : _db.doc().id;

      final startTs = _ts(req.date, req.startTime);
      final endTs = _ts(req.date, req.endTime);

      if (startTs == null) {
        return const Left('Start time is required.');
      }

      // Ambil list ID peserta untuk memudahkan query
      final participantIds = req.listParticipant
          .map((m) => m.staffId)
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      final notifRef = _baseDb.collection('Notifications');
      final notifId = notifRef.doc().id;
      final notifMap = <String, dynamic>{
        'notificationId': notifId,
        'title': "You've been invited to ${req.projectName}",
        'subTitle': "Click this notification to go to this task",
        "isBroadcast": false,
        "route": AppRoutes.detailDailyTask,
        "type": type.toJson(),
        "params": dailyTaskId,
        "readerIds": <String>[],
        'receipentIds': participantIds,
        'createdAt': FieldValue.serverTimestamp(),
        "searchKeywords": _buildAllPrefixes(req),
      };

      final dailyTaskMap = <String, dynamic>{
        'dailyTaskId': dailyTaskId,
        'title': req.title,
        'description': req.description,

        'projectName': req.projectName,
        'projectDescription': req.projectDescription,
        'projectCategory': req.projectCategory,
        'projectModel': req.projectModel,
        'customerCompany': req.customerCompany,
        'startTime': startTs,
        'endTime': endTs,
        'date': req.date,

        'dailyTaskCategory': req.dailyTaskCategory?.toJson(),
        'listParticipant': req.listParticipant.map((m) => m.toJson()).toList(),
        'listParticipantIds': participantIds,

        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': null,
        'createdBy': userEmail,
      };

      final batch = _baseDb.batch();
      batch.set(_db.doc(dailyTaskId), dailyTaskMap, SetOptions(merge: true));
      batch.set(notifRef.doc(notifId), notifMap, SetOptions(merge: true));
      await batch.commit();

      return const Right('Daily Task has been added successfully.');
    } catch (_) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> updateDailyTask(DailyTaskFormReq req) async {
    try {
      final colRef = _db.doc(req.dailyTaskId);

      final participantIds = req.listParticipant
          .map((m) => m.staffId)
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList();

      final notifRef = _baseDb.collection('Notifications');
      final notifId = notifRef.doc().id;
      final notifMap = <String, dynamic>{
        'notificationId': notifId,
        'title': "${req.projectName} had been updated",
        'subTitle': "Click this notification to go to this task",
        "isBroadcast": false,
        "route": AppRoutes.detailDailyTask,
        "type": type.toJson(),
        "readerIds": <String>[],
        "params": req.dailyTaskId,
        'receipentIds': participantIds,
        'createdAt': FieldValue.serverTimestamp(),
        "searchKeywords": _buildAllPrefixes(req),
      };

      final startTs = _ts(req.date, req.startTime);
      final endTs = _ts(req.date, req.endTime);

      final dailyTaskMap = <String, dynamic>{
        'dailyTaskId': req.dailyTaskId,
        'title': req.title,
        'description': req.description,

        'projectName': req.projectName,
        'projectDescription': req.projectDescription,
        'projectCategory': req.projectCategory,
        'projectModel': req.projectModel,
        'customerCompany': req.customerCompany,
        'startTime': startTs,
        'endTime': endTs,
        'date': req.date,

        'dailyTaskCategory': req.dailyTaskCategory?.toJson(),
        'listParticipant': req.listParticipant.map((m) => m.toJson()).toList(),
        'listParticipantIds': participantIds,

        'updatedAt': FieldValue.serverTimestamp(),
      };

      final batch = _baseDb.batch();
      batch.set(colRef, dailyTaskMap, SetOptions(merge: true));
      batch.set(notifRef.doc(notifId), notifMap, SetOptions(merge: true));
      await batch.commit();

      return const Right('Daily task has been added successfully.');
    } catch (_) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> deleteDailyTask(String req) async {
    try {
      await _db.doc(req).delete();

      return Right('Remove daily task succesfull');
    } catch (e) {
      return Left('Please try again');
    }
  }
}
