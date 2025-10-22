import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bluedock/common/domain/entities/type_category_selection_entity.dart';

class NotifEntity {
  final String notificationId;
  final String title;
  final String subTitle;

  /// tipe notifikasi (Project / Invoice / dst.)
  final TypeCategorySelectionEntity type;

  /// nama route tujuan (mis: AppRoutes.projectDetail)
  final String route;

  /// parameter untuk route (mis: projectId atau invoiceId)
  final String params;

  /// jika true → broadcast ke semua (receipentIds boleh kosong)
  final bool isBroadcast;

  /// daftar penerima spesifik (uid)
  final List<String> receipentIds;
  final List<String> readerIds;
  final List<String> deletedIds;
  final List<String> searchKeywords;

  /// waktu dibuat
  final Timestamp createdAt;

  NotifEntity({
    required this.notificationId,
    required this.title,
    required this.subTitle,
    required this.type,
    required this.route,
    required this.params,
    required this.isBroadcast,
    required this.receipentIds,
    required this.searchKeywords,
    required this.createdAt,
    required this.readerIds,
    required this.deletedIds,
  });

  NotifEntity copyWith({
    String? notificationId,
    String? title,
    String? subTitle,
    TypeCategorySelectionEntity? type,
    String? route,
    String? params,
    bool? isBroadcast,
    List<String>? receipentIds,
    List<String>? readerIds,
    List<String>? deletedIds,
    List<String>? searchKeywords,
    Timestamp? createdAt,
  }) {
    return NotifEntity(
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
      searchKeywords: searchKeywords ?? this.searchKeywords,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
