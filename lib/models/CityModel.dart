class CityModel {
  int statusCode;
  List<Data> data;

  CityModel({this.statusCode, this.data});

  CityModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String kodeKemendagri;
  int kodeBps;
  String namaWilayah;
  int tingkatWilayah;
  String parentKemendagri;
  int parentBps;

  Data(
      {this.kodeKemendagri,
      this.kodeBps,
      this.namaWilayah,
      this.tingkatWilayah,
      this.parentKemendagri,
      this.parentBps});

  Data.fromJson(Map<String, dynamic> json) {
    kodeKemendagri = json['kode_kemendagri'];
    kodeBps = json['kode_bps'];
    namaWilayah = json['nama_wilayah'];
    tingkatWilayah = json['tingkat_wilayah'];
    parentKemendagri = json['parent_kemendagri'];
    parentBps = json['parent_bps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kode_kemendagri'] = this.kodeKemendagri;
    data['kode_bps'] = this.kodeBps;
    data['nama_wilayah'] = this.namaWilayah;
    data['tingkat_wilayah'] = this.tingkatWilayah;
    data['parent_kemendagri'] = this.parentKemendagri;
    data['parent_bps'] = this.parentBps;
    return data;
  }
}