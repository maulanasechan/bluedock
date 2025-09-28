import 'package:bluedock/features/staff/domain/entities/staff_entity.dart';

abstract class StaffDisplayState {}

class StaffDisplayLoading extends StaffDisplayState {}

class StaffDisplayFetched extends StaffDisplayState {
  final List<StaffEntity> listStaff;

  StaffDisplayFetched({required this.listStaff});
}

class StaffDisplayFailure extends StaffDisplayState {
  final String message;

  StaffDisplayFailure({required this.message});
}
