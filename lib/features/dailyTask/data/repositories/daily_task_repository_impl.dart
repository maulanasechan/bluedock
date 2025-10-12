import 'package:bluedock/features/dailyTask/data/models/daily_task_form_req.dart';
import 'package:bluedock/features/dailyTask/data/models/daily_task_model.dart';
import 'package:bluedock/features/dailyTask/data/sources/daily_task_firebase_service.dart';
import 'package:bluedock/features/dailyTask/domain/repositories/daily_task_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class DailyTaskRepositoryImpl extends DailyTaskRepository {
  @override
  Future<Either> getAllDailyTask(DateTime query) async {
    final res = await sl<DailyTaskFirebaseService>().getAllDailyTask(query);
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(
          data,
        ).map((e) => DailyTaskModel.fromMap(e).toEntity()).toList(),
      ),
    );
  }

  @override
  Future<Either> addDailyTask(DailyTaskFormReq product) async {
    return await sl<DailyTaskFirebaseService>().addDailyTask(product);
  }

  @override
  Future<Either> updateDailyTask(DailyTaskFormReq product) async {
    return await sl<DailyTaskFirebaseService>().updateDailyTask(product);
  }

  @override
  Future<Either> deleteDailyTask(String req) async {
    return await sl<DailyTaskFirebaseService>().deleteDailyTask(req);
  }
}
