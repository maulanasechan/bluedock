import 'package:bluedock/features/staff/data/models/staff_form_req.dart';
import 'package:bluedock/features/staff/data/models/staff_model.dart';
import 'package:bluedock/features/staff/data/sources/staff_firebase_service.dart';
import 'package:bluedock/features/staff/domain/repositories/staff_repository.dart';
import 'package:bluedock/service_locator.dart';
import 'package:dartz/dartz.dart';

class StaffRepositoryImpl extends StaffRepository {
  @override
  Future<Either> addStaff(StaffFormReq staff) async {
    return await sl<StaffFirebaseService>().addStaff(staff);
  }

  @override
  Future<Either> getAllStaff() async {
    var returnedData = await sl<StaffFirebaseService>().getAllStaff();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data).map((e) => StaffModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> deleteStaff(String id) async {
    return await sl<StaffFirebaseService>().deleteStaff(id);
  }

  @override
  Future<Either> updateStaff(StaffFormReq staff) async {
    return await sl<StaffFirebaseService>().updateStaff(staff);
  }

  @override
  Future<Either> searchStaffByName(String query) async {
    final res = await sl<StaffFirebaseService>().searchStaffByName(query);
    return res.fold(
      (error) => Left(error),
      (data) => Right(
        List.from(data).map((e) => StaffModel.fromMap(e).toEntity()).toList(),
      ),
    );
  }
}
