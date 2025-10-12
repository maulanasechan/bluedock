import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/dailyTask/domain/repositories/daily_task_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class GetAllDailyTaskUseCase implements UseCase<Either, DateTime> {
  @override
  Future<Either> call({DateTime? params}) async {
    return await sl<DailyTaskRepository>().getAllDailyTask(params!);
  }
}
