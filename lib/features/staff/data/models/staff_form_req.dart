import 'package:bluedock/features/staff/domain/entities/role_entity.dart';

class StaffFormReq {
  final String staffId;
  final String fullName;
  final String nip;
  final String nik;
  final String email;
  final String password;
  final String address;
  final RoleEntity? role;
  const StaffFormReq({
    this.staffId = '',
    this.fullName = '',
    this.nip = '',
    this.nik = '',
    this.email = '',
    this.password = '',
    this.address = '',
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
    RoleEntity? role,
  }) => StaffFormReq(
    staffId: staffId ?? this.staffId,
    fullName: fullName ?? this.fullName,
    nip: nip ?? this.nip,
    nik: nik ?? this.nik,
    email: email ?? this.email,
    password: password ?? this.password,
    address: address ?? this.address,
    role: role ?? this.role,
  );
}
