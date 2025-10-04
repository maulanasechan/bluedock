import 'package:bluedock/features/home/data/models/change_password_req.dart';
import 'package:bluedock/features/home/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either> getUser();
  Future<Either> logout();
  Future<Either> changePassword(ChangePasswordReq password);
  Future<Either> getAppMenu(UserEntity user);
}
