import 'package:bluedock/features/project/domain/usecases/search_project_usecase.dart';
import 'package:bluedock/common/bloc/projectSection/project_display_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectDisplayCubit extends Cubit<ProjectDisplayState> {
  ProjectDisplayCubit() : super(ProjectDisplayInitial());
  int _reqId = 0;

  void displayProject({String? params}) async {
    final myReq = ++_reqId;
    emit(ProjectDisplayLoading());

    if (myReq != _reqId) return;

    var returnedData = await sl<SearchProjectUseCase>().call(params: params);
    returnedData.fold(
      (error) {
        emit(ProjectDisplayFailure(message: error.toString()));
      },
      (data) {
        emit(ProjectDisplayFetched(listProject: data));
      },
    );
  }

  void displayInitial() {
    displayProject(params: '');
  }
}
