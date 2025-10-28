import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/dailyTask/domain/repositories/daily_task_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class GetDailyTaskByIdUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<DailyTaskRepository>().getDailyTaskById(params!);
  }
}
