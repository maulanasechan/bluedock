import 'package:bluedock/features/staff/domain/entities/role_entity.dart';

abstract class RoleDisplayState {}

class RoleDisplayLoading extends RoleDisplayState {}

class RoleDisplayFetched extends RoleDisplayState {
  final List<RoleEntity> listRoles;

  RoleDisplayFetched({required this.listRoles});
}

class RoleDisplayFailure extends RoleDisplayState {
  final String message;

  RoleDisplayFailure({required this.message});
}
