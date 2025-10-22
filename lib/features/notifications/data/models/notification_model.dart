import 'dart:convert';
import 'package:bluedock/features/notifications/domain/entities/notification_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluedock/common/data/models/itemSelection/type_category_selection_model.dart';

class NotifModel {
  final String notificationId;
  final String title;
  final String subTitle;

  /// tipe notifikasi (Project/Invoice/dll)
  final TypeCategorySelectionModel type;

  /// route tujuan (mis. AppRoutes.projectDetail)
  final String route;

  /// parameter untuk route (mis. projectId / invoiceId)
  final String params;

  /// true = broadcast (receipentIds boleh kosong)
  final bool isBroadcast;

  /// daftar uid penerima spesifik
  final List<String> receipentIds;
  final List<String> readerIds;
  final List<String> searchKeywords;
  final List<String> deletedIds;

  /// waktu dibuat
  final Timestamp createdAt;

  const NotifModel({
    required this.notificationId,
    required this.title,
    required this.subTitle,
    required this.type,
    required this.route,
    required this.params,
    required this.readerIds,
    required this.isBroadcast,
    required this.receipentIds,
    required this.createdAt,
    required this.searchKeywords,
    required this.deletedIds,
  });

  NotifModel copyWith({
    String? notificationId,
    String? title,
    String? subTitle,
    TypeCategorySelectionModel? type,
    String? route,
    String? params,
    bool? isBroadcast,
    List<String>? receipentIds,
    List<String>? readerIds,
    List<String>? deletedIds,
    List<String>? searchKeywords,
    Timestamp? createdAt,
  }) {
    return NotifModel(
      notificationId: notificationId ?? this.notificationId,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      type: type ?? this.type,
      route: route ?? this.route,
      params: params ?? this.params,
      readerIds: readerIds ?? this.readerIds,
      deletedIds: deletedIds ?? this.deletedIds,
      isBroadcast: isBroadcast ?? this.isBroadcast,
      receipentIds: receipentIds ?? this.receipentIds,
      createdAt: createdAt ?? this.createdAt,
      searchKeywords: searchKeywords ?? this.searchKeywords,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notificationId': notificationId,
      'title': title,
      'subTitle': subTitle,
      'type': type.toMap(),
      'route': route,
      'params': params,
      'readerIds': readerIds,
      'isBroadcast': isBroadcast,
      'receipentIds': receipentIds,
      'deletedIds': deletedIds,
      'createdAt': createdAt,
      'searchKeywords': searchKeywords,
    };
  }

  factory NotifModel.fromMap(Map<String, dynamic> map) {
    bool asBool(dynamic v, {bool def = false}) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) {
        final s = v.toLowerCase();
        if (s == 'true' || s == '1') return true;
        if (s == 'false' || s == '0') return false;
      }
      return def;
    }

    List<String> asStringList(dynamic v) {
      if (v is List) return v.map((e) => e.toString()).toList();
      return const <String>[];
    }

    return NotifModel(
      notificationId: (map['notificationId'] ?? '') as String,
      title: (map['title'] ?? '') as String,
      subTitle: (map['subTitle'] ?? '') as String,
      type: TypeCategorySelectionModel.fromMap(
        (map['type'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      route: (map['route'] ?? '') as String,
      params: (map['params'] ?? '') as String,
      readerIds: asStringList(map['readerIds']),
      isBroadcast: asBool(map['isBroadcast']),
      receipentIds: asStringList(map['receipentIds']),
      deletedIds: asStringList(map['deletedIds']),
      searchKeywords: asStringList(map['receipentIds']),
      createdAt: (map['createdAt'] is Timestamp)
          ? map['createdAt'] as Timestamp
          : Timestamp(0, 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotifModel.fromJson(String source) =>
      NotifModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension NotifXModel on NotifModel {
  NotifEntity toEntity() {
    return NotifEntity(
      notificationId: notificationId,
      title: title,
      subTitle: subTitle,
      type: type.toEntity(),
      route: route,
      params: params,
      readerIds: readerIds,
      isBroadcast: isBroadcast,
      receipentIds: receipentIds,
      deletedIds: deletedIds,
      createdAt: createdAt,
      searchKeywords: searchKeywords,
    );
  }
}
