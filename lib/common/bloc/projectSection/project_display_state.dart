import 'package:bluedock/common/domain/entities/project_entity.dart';

abstract class ProjectDisplayState {}

class ProjectDisplayInitial extends ProjectDisplayState {}

class ProjectDisplayLoading extends ProjectDisplayState {}

class ProjectDisplayFetched extends ProjectDisplayState {
  final List<ProjectEntity> listProject;
  ProjectDisplayFetched({required this.listProject});
}

class ProjectDisplayFailure extends ProjectDisplayState {
  final String message;
  ProjectDisplayFailure({required this.message});
}
