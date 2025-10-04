import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/home/domain/entities/user_entity.dart';
import 'package:bluedock/features/home/domain/repositories/user_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class GetAppMenuUseCase implements UseCase<Either, UserEntity> {
  @override
  Future<Either> call({UserEntity? params}) async {
    return await sl<UserRepository>().getAppMenu(params!);
  }
}
