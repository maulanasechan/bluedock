import 'dart:convert';
import 'package:bluedock/features/project/domain/entities/selection/staff_selection_entity.dart';
import 'package:bluedock/features/staff/domain/entities/role_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StaffSelectionModel {
  final String staffId;
  final String fullName;
  final String nip;
  final String nik;
  final String email;
  final String address;
  final String phoneNumber;
  final String image;
  final RoleEntity role;
  final String updatedBy;
  final Timestamp? updatedAt;
  final Timestamp lastOnline;
  final Timestamp lastLogin;
  final List<String> fullNameWordPrefixes;

  StaffSelectionModel({
    required this.staffId,
    required this.fullName,
    required this.nik,
    required this.nip,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.image,
    required this.role,
    required this.updatedBy,
    this.updatedAt,
    required this.lastOnline,
    required this.lastLogin,
    this.fullNameWordPrefixes = const <String>[],
  });

  Map<String, dynamic> toMap() {
    return {
      'staffId': staffId,
      'fullName': fullName,
      'nik': nik,
      'nip': nip,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
      'image': image,
      'role': role.toJson(),
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'lastOnline': lastOnline,
      'lastLogin': lastLogin,
      'fullNameWordPrefixes': fullNameWordPrefixes,
    };
  }

  factory StaffSelectionModel.fromMap(Map<String, dynamic> map) {
    return StaffSelectionModel(
      staffId: map['staffId'] ?? '',
      fullName: map['fullName'] ?? '',
      nik: map['nik'] ?? '',
      nip: map['nip'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      image: map['image'] ?? '',
      role: RoleEntity.fromMap(map['role']),
      updatedBy: map['updatedBy'] ?? '',
      updatedAt: map['updatedAt'],
      lastOnline: map['lastOnline'] ?? Timestamp(0, 0),
      lastLogin: map['lastLogin'] ?? Timestamp(0, 0),
      fullNameWordPrefixes: (map['fullNameWordPrefixes'] is List)
          ? List<String>.from(
              (map['fullNameWordPrefixes'] as List).map((e) => e.toString()),
            )
          : const <String>[],
    );
  }

  String toJson() => json.encode(toMap());

  factory StaffSelectionModel.fromJson(String source) =>
      StaffSelectionModel.fromMap(json.decode(source));
}

extension StaffSelectionXModel on StaffSelectionModel {
  StaffSelectionEntity toEntity() {
    return StaffSelectionEntity(
      staffId: staffId,
      fullName: fullName,
      nik: nik,
      nip: nip,
      email: email,
      address: address,
      phoneNumber: phoneNumber,
      image: image,
      role: role,
      updatedBy: updatedBy,
      updatedAt: updatedAt,
      lastOnline: lastOnline,
      fullNameWordPrefixes: fullNameWordPrefixes,
    );
  }
}
