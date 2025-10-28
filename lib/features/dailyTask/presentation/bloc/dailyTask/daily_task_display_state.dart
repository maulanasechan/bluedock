import 'package:bluedock/features/dailyTask/domain/entities/daily_task_entity.dart';

abstract class DailyTaskDisplayState {}

class DailyTaskDisplayInitial extends DailyTaskDisplayState {}

class DailyTaskDisplayLoading extends DailyTaskDisplayState {}

class DailyTaskDisplayFetched extends DailyTaskDisplayState {
  final List<DailyTaskEntity> listDailyTask;
  DailyTaskDisplayFetched({required this.listDailyTask});
}

class DailyTaskDisplayFailure extends DailyTaskDisplayState {
  final String message;
  DailyTaskDisplayFailure({required this.message});
}

class DailyTaskDisplayOneFetched extends DailyTaskDisplayState {
  final DailyTaskEntity dailyTask;
  DailyTaskDisplayOneFetched({required this.dailyTask});
}
