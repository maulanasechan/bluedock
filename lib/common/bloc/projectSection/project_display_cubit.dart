import 'package:bluedock/common/bloc/projectSection/project_display_state.dart';
import 'package:bluedock/common/data/models/search/search_with_type_req.dart';
import 'package:bluedock/common/domain/usecases/get_project_by_id_usecase.dart';
import 'package:bluedock/common/domain/usecases/search_project_usecase.dart';
import 'package:bluedock/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectDisplayCubit extends Cubit<ProjectDisplayState> {
  ProjectDisplayCubit() : super(ProjectDisplayInitial());

  int _reqId = 0;

  // ✅ filter internal selalu string ("" = no filter)
  String _type = '';
  String _keyword = '';

  // optional getter
  String get currentType => _type;
  String get currentKeyword => _keyword;

  // Boleh dipanggil tanpa params; kalau ada params, sync dulu internal filter
  Future<void> displayProject({SearchWithTypeReq? params}) async {
    if (params != null) {
      _type = params.type.trim();
      _keyword = params.keyword.trim();
    }

    final myReq = ++_reqId;
    emit(ProjectDisplayLoading());

    final req = SearchWithTypeReq(type: _type, keyword: _keyword);
    final returnedData = await sl<SearchProjectUseCase>().call(params: req);

    if (myReq != _reqId) return; // race guard

    returnedData.fold(
      (error) => emit(ProjectDisplayFailure(message: error.toString())),
      (data) => emit(ProjectDisplayFetched(listProject: data)),
    );
  }

  // Awal: boleh tanpa argumen ("" = all)
  void displayInitial([String? type]) {
    _type = (type ?? '').trim();
    _keyword = '';
    displayProject(); // pakai filter internal
  }

  // Set dari action button
  void setType(String? type) {
    _type = (type ?? '').trim();
    displayProject();
  }

  // Toggle: tekan type yang sama untuk clear (jadi "")
  void toggleType(String type) {
    final t = type.trim();
    _type = _type == t ? '' : t;
    displayProject();
  }

  // Set keyword dari search box
  void setKeyword(String? keyword) {
    _keyword = (keyword ?? '').trim();
    displayProject();
  }

  // Clear semua filter
  void clearFilters() {
    _type = '';
    _keyword = '';
    displayProject();
  }

  Future<void> displayProjectById(String projectId) async {
    final myReq = ++_reqId;
    emit(ProjectDisplayLoading());

    final result = await sl<GetProjectByIdUseCase>().call(params: projectId);

    if (myReq != _reqId) return;

    result.fold(
      (err) => emit(ProjectDisplayFailure(message: err.toString())),
      (project) => emit(ProjectDisplayOneFetched(project: project)),
    );
  }
}
