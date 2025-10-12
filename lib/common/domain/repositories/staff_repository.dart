import 'package:bluedock/features/staff/data/models/staff_form_req.dart';
import 'package:dartz/dartz.dart';

abstract class StaffRepository {
  Future<Either> addStaff(StaffFormReq staff);
  Future<Either> deleteStaff(String id);
  Future<Either> updateStaff(StaffFormReq staff);
  Future<Either> searchStaffByName(String query);
  Future<Either> getUser();
}
