class User {
  int id;
  String name;
  String photoUrlFull;
  String roleLabel;
  String kabkota;
  String kelurahan;
  String kecamatan;
  String rw;


  User({
    this.id,
    this.name,
    this.photoUrlFull,
    this.roleLabel,
    this.kabkota,
    this.kelurahan,
    this.kecamatan,
    this.rw
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    photoUrlFull: json["photo_url_full"] == null ? '' : json["photo_url_full"],
    roleLabel: json["role_label"],
    kabkota: json["kabkota"],
    kelurahan: json["kelurahan"],
    kecamatan: json["kecamatan"],
    rw: json["rw"] == null ? '' : json["rw"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "photo_url_full": photoUrlFull == null ? '' : photoUrlFull,
    "role_label": roleLabel,
    "kabkota": kabkota,
    "kelurahan": kelurahan,
    "kecamatan": kecamatan,
    "rw": rw,
  };
}