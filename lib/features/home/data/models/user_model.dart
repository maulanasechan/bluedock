import 'dart:convert';

import 'package:bluedock/features/home/domain/entities/user_entity.dart';
import 'package:bluedock/features/staff/domain/entities/role_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String staffId;
  final String fullName;
  final String nik;
  final String nip;
  final String email;
  final String address;
  final String image;
  final RoleEntity role;
  final String updatedBy;
  final Timestamp? updatedAt;
  final Timestamp lastOnline;
  final Timestamp lastLogin;

  UserModel({
    required this.staffId,
    required this.fullName,
    required this.nik,
    required this.nip,
    required this.email,
    required this.address,
    required this.image,
    required this.role,
    required this.updatedBy,
    this.updatedAt,
    required this.lastOnline,
    required this.lastLogin,
  });

  Map<String, dynamic> toMap() {
    return {
      'staffId': staffId,
      'fullName': fullName,
      'nik': nik,
      'nip': nip,
      'email': email,
      'address': address,
      'image': image,
      'role': role.toJson(),
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'lastOnline': lastOnline,
      'lastLogin': lastLogin,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      staffId: map['staffId'] ?? '',
      fullName: map['fullName'] ?? '',
      nik: map['nik'] ?? '',
      nip: map['nip'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      image: map['image'] ?? '',
      role: RoleEntity.fromMap(map['role']),
      updatedBy: map['updatedBy'] ?? '',
      updatedAt: map['updatedAt'],
      lastOnline: map['lastOnline'] ?? Timestamp(0, 0),
      lastLogin: map['lastLogin'] ?? Timestamp(0, 0),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}

extension UserXModel on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      staffId: staffId,
      fullName: fullName,
      nik: nik,
      nip: nip,
      email: email,
      address: address,
      image: image,
      role: role,
      updatedBy: updatedBy,
      updatedAt: updatedAt,
      lastOnline: lastOnline,
    );
  }
}
