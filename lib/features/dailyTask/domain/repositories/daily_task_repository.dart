import 'package:bluedock/features/dailyTask/data/models/daily_task_form_req.dart';
import 'package:dartz/dartz.dart';

abstract class DailyTaskRepository {
  Future<Either> getAllDailyTask(DateTime query);
  Future<Either> addDailyTask(DailyTaskFormReq product);
  Future<Either> updateDailyTask(DailyTaskFormReq product);
  Future<Either> deleteDailyTask(String req);
  Future<Either> getDailyTaskById(String req);
}
