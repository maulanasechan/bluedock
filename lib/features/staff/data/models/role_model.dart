import 'package:bluedock/features/staff/domain/entities/role_entity.dart';

class RoleModel {
  final String roleId;
  final String title;
  final List<String> listAppMenu;
  RoleModel({
    required this.roleId,
    required this.title,
    required this.listAppMenu,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'roleId': roleId,
      'title': title,
      'listAppMenu': listAppMenu.map((e) => e.toString()).toList(),
    };
  }

  factory RoleModel.fromMap(Map<String, dynamic>? map) {
    List<String> parseStringList(dynamic v) {
      if (v is List) {
        return v.map((e) => e.toString()).toList();
      }
      return const <String>[];
    }

    if (map == null) {
      throw ArgumentError('ProductModel.fromMap: map is null');
    }

    final String roleId = (map['roleId'] ?? map['roleId'] ?? '') as String;

    return RoleModel(
      roleId: roleId,
      title: (map['title'] ?? '') as String,
      listAppMenu: parseStringList(map['listAppMenu']),
    );
  }
}

extension RoleXModel on RoleModel {
  RoleEntity toEntity() {
    return RoleEntity(roleId: roleId, title: title, listAppMenu: listAppMenu);
  }
}
