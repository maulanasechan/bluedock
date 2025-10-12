import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/dailyTask/data/models/daily_task_form_req.dart';
import 'package:bluedock/features/dailyTask/domain/repositories/daily_task_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class UpdateDailyTaskUseCase implements UseCase<Either, DailyTaskFormReq> {
  @override
  Future<Either> call({DailyTaskFormReq? params}) async {
    return await sl<DailyTaskRepository>().updateDailyTask(params!);
  }
}
