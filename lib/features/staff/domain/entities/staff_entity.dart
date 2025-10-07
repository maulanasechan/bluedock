import 'package:bluedock/features/staff/domain/entities/role_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffEntity {
  final String staffId;
  final String fullName;
  final String nik;
  final String nip;
  final String email;
  final String address;
  final String phoneNumber;
  final String image;
  final RoleEntity role;
  final String updatedBy;
  final Timestamp? updatedAt;
  final Timestamp lastOnline;
  final List<String> fullNameWordPrefixes;

  StaffEntity({
    required this.staffId,
    required this.fullName,
    required this.nip,
    required this.nik,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.image,
    required this.role,
    required this.updatedBy,
    this.updatedAt,
    required this.lastOnline,
    this.fullNameWordPrefixes = const <String>[],
  });

  StaffEntity copyWith({
    String? staffId,
    String? fullName,
    List<String>? fullNameWordPrefixes,
    String? nik,
    String? nip,
    String? email,
    String? address,
    String? phoneNumber,
    String? image,
    RoleEntity? role,
    String? updatedBy,
    Timestamp? updatedAt,
    Timestamp? lastOnline,
  }) {
    return StaffEntity(
      staffId: staffId ?? this.staffId,
      fullName: fullName ?? this.fullName,
      nik: nik ?? this.nik,
      nip: nip ?? this.nip,
      email: email ?? this.email,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      image: image ?? this.image,
      role: role ?? this.role,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      lastOnline: lastOnline ?? this.lastOnline,
      fullNameWordPrefixes: fullNameWordPrefixes ?? this.fullNameWordPrefixes,
    );
  }
}
