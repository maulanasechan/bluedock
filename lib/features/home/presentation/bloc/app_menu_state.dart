import 'package:bluedock/features/home/domain/entities/app_menu_entity.dart';

abstract class AppMenuState {}

class AppMenuLoading extends AppMenuState {}

class AppMenuFetched extends AppMenuState {
  final List<AppMenuEntity> appMenu;
  AppMenuFetched({required this.appMenu});
}

class AppMenuFailure extends AppMenuState {}
