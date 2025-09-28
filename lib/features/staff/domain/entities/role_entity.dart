class RoleEntity {
  final String roleId;
  final String title;
  final List<String> listAppMenu;
  RoleEntity({
    required this.roleId,
    required this.title,
    required this.listAppMenu,
  });

  Map<String, dynamic> toJson() => {
    'roleId': roleId,
    'title': title,
    'listAppMenu': listAppMenu,
  };

  factory RoleEntity.fromJson(Map<String, dynamic> json) {
    return RoleEntity(
      roleId: json['roleId'] as String,
      title: json['title'] as String,
      listAppMenu: List<String>.from(json['listAppMenu'] ?? []),
    );
  }

  factory RoleEntity.fromMap(Map<String, dynamic>? map) {
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

    return RoleEntity(
      roleId: roleId,
      title: (map['title'] ?? '') as String,
      listAppMenu: parseStringList(map['listAppMenu']),
    );
  }
}
