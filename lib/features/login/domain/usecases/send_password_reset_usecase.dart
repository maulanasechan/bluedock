import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/login/domain/repositories/login_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class SendPasswordResetUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<LoginRepository>().sendPasswordReset(params!);
  }
}
