import 'package:bluedock/common/domain/entities/role_entity.dart';
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
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
      'fullNameWordPrefixes': fullNameWordPrefixes,
    };
    map.removeWhere((_, v) => v == null);
    return map;
  }

  factory StaffEntity.fromJson(Map<String, dynamic> json) {
    List<String> asStringList(dynamic v) =>
        v is List ? v.map((e) => e.toString()).toList() : const <String>[];

    final roleMap =
        (json['role'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};

    return StaffEntity(
      staffId: (json['staffId'] ?? '') as String,
      fullName: (json['fullName'] ?? '') as String,
      nik: (json['nik'] ?? '') as String,
      nip: (json['nip'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      address: (json['address'] ?? '') as String,
      phoneNumber: (json['phoneNumber'] ?? '') as String,
      image: (json['image'] ?? '') as String,
      role: RoleEntity.fromJson(roleMap),
      updatedBy: (json['updatedBy'] ?? '') as String,
      updatedAt: json['updatedAt'] is Timestamp
          ? json['updatedAt'] as Timestamp
          : null,
      lastOnline: json['lastOnline'] is Timestamp
          ? json['lastOnline'] as Timestamp
          : Timestamp.now(),
      fullNameWordPrefixes: asStringList(json['fullNameWordPrefixes']),
    );
  }

  factory StaffEntity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const <String, dynamic>{};
    return StaffEntity.fromJson({
      'staffId': data['staffId'] ?? doc.id,
      ...data,
    });
  }
}
