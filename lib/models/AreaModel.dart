import 'dart:convert';

/// kabupaten / Kota
List<Kabkota> listKabkotaFromJson(String str) =>
    List<Kabkota>.from(json.decode(str).map((x) => Kabkota.fromMap(x)));

Kabkota kabkotaFromJson(String str) => Kabkota.fromMap(json.decode(str));

/// Kecamatan
List<Kecamatan> listKecamatanFromJson(String str) =>
    List<Kecamatan>.from(json.decode(str).map((x) => Kecamatan.fromMap(x)));

Kecamatan KecamatanFromJson(String str) => Kecamatan.fromMap(json.decode(str));

/// Kelurahan
List<Kelurahan> listKelurahanFromJson(String str) =>
    List<Kelurahan>.from(json.decode(str).map((x) => Kelurahan.fromMap(x)));

Kelurahan KelurahanFromJson(String str) => Kelurahan.fromMap(json.decode(str));

class Kabkota {
  final int id;
  final String name;

  Kabkota({this.id, this.name});

  factory Kabkota.fromMap(Map<String, dynamic> json) {
    return Kabkota(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class Kecamatan {
  final int id;
  final String name;

  Kecamatan({this.id, this.name});

  factory Kecamatan.fromMap(Map<String, dynamic> json) {
    return Kecamatan(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class Kelurahan {
  final int id;
  final String name;

  Kelurahan({this.id, this.name});

  factory Kelurahan.fromMap(Map<String, dynamic> json) {
    return Kelurahan(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
