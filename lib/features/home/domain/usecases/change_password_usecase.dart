import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/home/data/models/change_password_req.dart';
import 'package:bluedock/features/home/domain/repositories/user_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class ChangePasswordUsecase implements UseCase<Either, ChangePasswordReq> {
  @override
  Future<Either> call({ChangePasswordReq? params}) async {
    return await sl<UserRepository>().changePassword(params!);
  }
}
