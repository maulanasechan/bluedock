import 'package:bluedock/features/home/domain/entities/user_entity.dart';

abstract class UserInfoState {}

class UserInfoLoading extends UserInfoState {}

class UserInfoFetched extends UserInfoState {
  final UserEntity user;
  UserInfoFetched({required this.user});
}

class UserInfoFailure extends UserInfoState {}
