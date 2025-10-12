import 'package:bluedock/common/domain/entities/staff_entity.dart';
import 'package:bluedock/features/home/data/models/change_password_req.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either> logout();
  Future<Either> changePassword(ChangePasswordReq password);
  Future<Either> getAppMenu(StaffEntity user);
}
