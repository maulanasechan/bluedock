import 'package:bluedock/common/domain/entities/role_entity.dart';

class StaffFormReq {
  final String staffId;
  final String fullName;
  final String nip;
  final String nik;
  final String email;
  final String password;
  final String address;
  final String phoneNumber;
  final RoleEntity? role;
  const StaffFormReq({
    this.staffId = '',
    this.fullName = '',
    this.nip = '',
    this.nik = '',
    this.email = '',
    this.password = '',
    this.address = '',
    this.phoneNumber = '',
    this.role,
  });

  StaffFormReq copyWith({
    String? staffId,
    String? fullName,
    String? nik,
    String? nip,
    String? email,
    String? password,
    String? address,
    String? phoneNumber,
    RoleEntity? role,
  }) => StaffFormReq(
    staffId: staffId ?? this.staffId,
    fullName: fullName ?? this.fullName,
    nip: nip ?? this.nip,
    nik: nik ?? this.nik,
    email: email ?? this.email,
    password: password ?? this.password,
    address: address ?? this.address,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    role: role ?? this.role,
  );
}
