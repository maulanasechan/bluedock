import 'package:bluedock/features/staff/data/models/staff_form_req.dart';
import 'package:bluedock/features/staff/domain/entities/role_entity.dart';
import 'package:bluedock/features/staff/domain/entities/staff_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaffFormCubit extends Cubit<StaffFormReq> {
  StaffFormCubit() : super(const StaffFormReq());
  void setFullName(String v) => emit(state.copyWith(fullName: v));
  void setNIP(String v) => emit(state.copyWith(nip: v));
  void setNIK(String v) => emit(state.copyWith(nik: v));
  void setEmail(String v) => emit(state.copyWith(email: v));
  void setPassword(String v) => emit(state.copyWith(password: v));
  void setAddress(String v) => emit(state.copyWith(address: v));
  void setRole(RoleEntity v) => emit(state.copyWith(role: v));

  void hydrateFromEntity(StaffEntity e) {
    emit(
      state.copyWith(
        staffId: e.staffId,
        fullName: e.fullName,
        nip: e.nip,
        nik: e.nik,
        email: e.email,
        address: e.address,
        role: e.role,
        password: '',
      ),
    );
  }
}
