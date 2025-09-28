import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/staff/domain/repositories/staff_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class GetAllStaffUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<StaffRepository>().getAllStaff();
  }
}
