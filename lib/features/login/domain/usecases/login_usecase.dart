import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/login/data/models/login_form_req.dart';
import 'package:bluedock/features/login/domain/repositories/login_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements UseCase<Either, LoginFormReq> {
  @override
  Future<Either> call({LoginFormReq? params}) async {
    return await sl<LoginRepository>().login(params!);
  }
}
