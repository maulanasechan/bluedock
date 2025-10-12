import 'package:bluedock/common/domain/entities/staff_entity.dart';

abstract class StaffDisplayState {}

class StaffDisplayInitial extends StaffDisplayState {}

class StaffDisplayLoading extends StaffDisplayState {}

class StaffDisplayFetched extends StaffDisplayState {
  final List<StaffEntity> listStaff;

  StaffDisplayFetched({required this.listStaff});
}

class StaffDisplayFailure extends StaffDisplayState {
  final String message;

  StaffDisplayFailure({required this.message});
}

class UserInfoFetched extends StaffDisplayState {
  final StaffEntity user;
  UserInfoFetched({required this.user});
}
