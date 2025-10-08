import 'package:bluedock/features/project/data/models/selection/product_selection_req.dart';
import 'package:bluedock/features/project/domain/usecases/get_category_selection_usecase.dart';
import 'package:bluedock/features/project/domain/usecases/get_product_selection_usecase.dart';
import 'package:bluedock/features/project/domain/usecases/get_project_selection_usecase.dart';
import 'package:bluedock/features/project/domain/usecases/get_staff_selection_usecase.dart';
import 'package:bluedock/features/project/presentation/bloc/selection/project_selection_display_state.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectSelectionDisplayCubit extends Cubit<ProjectSelectionDisplayState> {
  ProjectSelectionDisplayCubit() : super(ProjectSelectionDisplayLoading());

  void displaySelection(String params) async {
    emit(ProjectSelectionDisplayLoading());
    var returnedData = await sl<GetProjectSelectionUseCase>().call(
      params: params,
    );

    returnedData.fold(
      (error) {
        emit(ProjectSelectionDisplayFailure(message: error));
      },
      (data) {
        emit(ProjectSelectionDisplayFetched(listSelection: data));
      },
    );
  }

  void displayCategorySelection() async {
    emit(ProjectSelectionDisplayLoading());
    var returnedData = await sl<GetCategorySelectionUseCase>().call();

    returnedData.fold(
      (error) {
        emit(ProjectSelectionDisplayFailure(message: error));
      },
      (data) {
        emit(CategorySelectionDisplayFetched(listSelection: data));
      },
    );
  }

  void displayProductSelection(ProductSelectionReq req) async {
    emit(ProjectSelectionDisplayLoading());
    var returnedData = await sl<GetProductSelectionUseCase>().call(params: req);

    returnedData.fold(
      (error) {
        emit(ProjectSelectionDisplayFailure(message: error));
      },
      (data) {
        emit(ProductSelectionDisplayFetched(listSelection: data));
      },
    );
  }

  void displayStaffSelection(String req) async {
    emit(ProjectSelectionDisplayLoading());
    var returnedData = await sl<GetStaffSelectionUseCase>().call(params: req);

    returnedData.fold(
      (error) {
        emit(ProjectSelectionDisplayFailure(message: error));
      },
      (data) {
        emit(StaffSelectionDisplayFetched(listSelection: data));
      },
    );
  }
}
