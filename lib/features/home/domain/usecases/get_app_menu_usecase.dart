import 'package:bluedock/common/domain/entities/staff_entity.dart';
import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/home/domain/repositories/user_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class GetAppMenuUseCase implements UseCase<Either, StaffEntity> {
  @override
  Future<Either> call({StaffEntity? params}) async {
    return await sl<UserRepository>().getAppMenu(params!);
  }
}
