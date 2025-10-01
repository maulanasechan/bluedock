// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bluedock/features/home/domain/entities/app_menu_entity.dart';

class AppMenuModel {
  final String title;
  final String icon;
  final String route;
  final String appMenuId;

  AppMenuModel({
    required this.appMenuId,
    required this.title,
    required this.icon,
    required this.route,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'icon': icon,
      'route': route,
      'appMenuId': appMenuId,
    };
  }

  factory AppMenuModel.fromMap(Map<String, dynamic> map) {
    return AppMenuModel(
      title: map['title'] ?? '',
      icon: map['icon'] ?? '',
      route: map['route'] ?? '',
      appMenuId: map['appMenuId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AppMenuModel.fromJson(String source) =>
      AppMenuModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension AppMenuXModel on AppMenuModel {
  AppMenuEntity toEntity() {
    return AppMenuEntity(
      appMenuId: appMenuId,
      title: title,
      icon: icon,
      route: route,
    );
  }
}
