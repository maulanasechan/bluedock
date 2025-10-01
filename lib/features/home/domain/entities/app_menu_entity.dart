class AppMenuEntity {
  final String title;
  final String icon;
  final String route;
  final String appMenuId;

  AppMenuEntity({
    required this.appMenuId,
    required this.title,
    required this.icon,
    required this.route,
  });

  AppMenuEntity copyWith({
    String? title,
    String? icon,
    String? route,
    String? appMenuId,
  }) {
    return AppMenuEntity(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      appMenuId: appMenuId ?? this.appMenuId,
    );
  }
}
