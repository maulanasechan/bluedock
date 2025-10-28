import 'package:bluedock/features/dailyTask/domain/usecases/get_all_daily_task_usecase.dart';
import 'package:bluedock/features/dailyTask/domain/usecases/get_daily_task_by_id_usecase.dart';
import 'package:bluedock/features/dailyTask/presentation/bloc/dailyTask/daily_task_display_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyTaskDisplayCubit extends Cubit<DailyTaskDisplayState> {
  DailyTaskDisplayCubit() : super(DailyTaskDisplayInitial());
  int _reqId = 0;

  void displayDailyTask({DateTime? params}) async {
    final myReq = ++_reqId;
    emit(DailyTaskDisplayLoading());

    if (myReq != _reqId) return;

    var returnedData = await sl<GetAllDailyTaskUseCase>().call(params: params);
    returnedData.fold(
      (error) {
        emit(DailyTaskDisplayFailure(message: error.toString()));
      },
      (data) {
        emit(DailyTaskDisplayFetched(listDailyTask: data));
      },
    );
  }

  void displayInitial() {
    displayDailyTask(params: DateTime.now());
  }

  Future<void> displayDailyTaskById(String taskId) async {
    final myReq = ++_reqId;
    emit(DailyTaskDisplayLoading());

    final result = await sl<GetDailyTaskByIdUseCase>().call(params: taskId);

    if (myReq != _reqId) return;

    result.fold(
      (err) => emit(DailyTaskDisplayFailure(message: err.toString())),
      (dailyTask) => emit(DailyTaskDisplayOneFetched(dailyTask: dailyTask)),
    );
  }
}
