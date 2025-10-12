import 'package:bluedock/core/config/usecase/format_usecase.dart';
import 'package:bluedock/features/staff/data/models/staff_form_req.dart';
import 'package:bluedock/common/domain/repositories/staff_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class UpdateStaffUseCase implements UseCase<Either, StaffFormReq> {
  @override
  Future<Either> call({StaffFormReq? params}) async {
    return await sl<StaffRepository>().updateStaff(params!);
  }
}
