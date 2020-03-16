import 'dart:convert';

import 'AreaModel.dart';

UserInfoModel userInfoModelFromJson(String str) =>
    UserInfoModel.fromJson(json.decode(str));

String userInfoModelToJson(UserInfoModel data) => json.encode(data.toJson());

class UserInfoModel {
  int id;
  String username;
  String email;
  String roleId;
  String roleLabel;
  String name;
  String phone;
  String address;
  String rt;
  String rw;
  String kelId;
  Kabkota kelurahan;
  String kecId;
  Kabkota kecamatan;
  String kabkotaId;
  Kabkota kabkota;
  dynamic lat;
  dynamic lon;
  dynamic photoUrl;
  dynamic facebook;
  String twitter;
  String instagram;
  int jobTypeId;
  EducationLevel jobType;
  int educationLevelId;
  EducationLevel educationLevel;
  DateTime birthDate;
  int lastLoginAt;
  dynamic passwordUpdatedAt;
  dynamic profileUpdatedAt;

  UserInfoModel(
      {this.id,
      this.username,
      this.email,
      this.roleId,
      this.roleLabel,
      this.name,
      this.phone,
      this.address,
      this.rt,
      this.rw,
      this.kelId,
      this.kelurahan,
      this.kecId,
      this.kecamatan,
      this.kabkotaId,
      this.kabkota,
      this.lat,
      this.lon,
      this.photoUrl,
      this.facebook,
      this.twitter,
      this.instagram,
      this.jobTypeId,
      this.jobType,
      this.educationLevelId,
      this.educationLevel,
      this.birthDate,
      this.lastLoginAt,
      this.passwordUpdatedAt,
      this.profileUpdatedAt});

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        roleId: json["role_id"],
        roleLabel: json["role_label"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        rt: json["rt"],
        rw: json["rw"],
        kelId: json["kel_id"],
        kelurahan: Kabkota.fromMap(json["kelurahan"]),
        kecId: json["kec_id"],
        kecamatan: Kabkota.fromMap(json["kecamatan"]),
        kabkotaId: json["kabkota_id"],
        kabkota: Kabkota.fromMap(json["kabkota"]),
        lat: json["lat"],
        lon: json["lon"],
        photoUrl: json["photo_url"],
        facebook: json["facebook"],
        twitter: json["twitter"],
        instagram: json["instagram"],
        jobTypeId: json["job_type_id"] == null ? null : json["job_type_id"],
        jobType: json["job_type"] == null ? null : EducationLevel.fromJson(json["job_type"]),
        educationLevelId: json["education_level_id"] == null ? null : json["education_level_id"],
        educationLevel: json["education_level"] == null ? null : EducationLevel.fromJson(json["education_level"]),
        birthDate: json["birth_date"] == null ? null : DateTime.parse(json["birth_date"]),
        lastLoginAt: json["last_login_at"],
        passwordUpdatedAt: json["password_updated_at"],
        profileUpdatedAt: json["profile_updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "role_id": roleId,
        "role_label": roleLabel,
        "name": name,
        "phone": phone,
        "address": address,
        "rt": rt,
        "rw": rw,
        "kel_id": kelId,
        "kelurahan": kelurahan.toJson(),
        "kec_id": kecId,
        "kecamatan": kecamatan.toJson(),
        "kabkota_id": kabkotaId,
        "kabkota": kabkota.toJson(),
        "lat": lat,
        "lon": lon,
        "photo_url": photoUrl,
        "facebook": facebook,
        "twitter": twitter,
        "instagram": instagram,
        "job_type_id": jobTypeId == null ? null : jobTypeId,
        "job_type": jobType == null ? null : jobType.toJson(),
        "education_level_id":
            educationLevelId == null ? null : educationLevelId,
        "education_level":
            educationLevel == null ? null : educationLevel.toJson(),
        "birth_date": birthDate == null ? null : "${birthDate.year.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}",
        "last_login_at": lastLoginAt,
        "password_updated_at": passwordUpdatedAt,
        "profile_updated_at": profileUpdatedAt,
      };
}

class EducationLevel {
  int id;
  String title;
  int seq;
  int status;

  EducationLevel({
    this.id,
    this.title,
    this.seq,
    this.status,
  });

  factory EducationLevel.fromJson(Map<String, dynamic> json) => EducationLevel(
        id: json["id"],
        title: json["title"],
        seq: json["seq"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "seq": seq,
        "status": status == null ? null : status,
      };
}
