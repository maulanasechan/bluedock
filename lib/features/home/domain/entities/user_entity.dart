import 'package:bluedock/features/staff/domain/entities/role_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  final String staffId;
  final String fullName;
  final String nik;
  final String nip;
  final String email;
  final String phoneNumber;
  final String address;
  final String image;
  final RoleEntity role;
  final String updatedBy;
  final Timestamp? updatedAt;
  final Timestamp lastOnline;

  UserEntity({
    required this.staffId,
    required this.fullName,
    required this.nik,
    required this.nip,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.image,
    required this.role,
    required this.updatedBy,
    this.updatedAt,
    required this.lastOnline,
  });

  UserEntity copyWith({
    String? staffId,
    String? fullName,
    String? nik,
    String? nip,
    String? email,
    String? phoneNumber,
    String? address,
    String? image,
    RoleEntity? role,
    String? updatedBy,
    Timestamp? updatedAt,
    Timestamp? lastOnline,
  }) {
    return UserEntity(
      staffId: staffId ?? this.staffId,
      fullName: fullName ?? this.fullName,
      nik: nik ?? this.nik,
      nip: nip ?? this.nip,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      image: image ?? this.image,
      role: role ?? this.role,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      lastOnline: lastOnline ?? this.lastOnline,
    );
  }
}
