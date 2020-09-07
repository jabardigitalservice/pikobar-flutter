class CheckDistributionModel {
  CurrentLocation currentLocation;
  Detected detected;

  CheckDistributionModel({this.currentLocation, this.detected});

  CheckDistributionModel.fromJson(Map<String, dynamic> json) {
    currentLocation = json['current_location'] != null
        ? new CurrentLocation.fromJson(json['current_location'])
        : null;
    detected = json['detected'] != null
        ? new Detected.fromJson(json['detected'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.currentLocation != null) {
      data['current_location'] = this.currentLocation.toJson();
    }
    if (this.detected != null) {
      data['detected'] = this.detected.toJson();
    }
    return data;
  }
}

class CurrentLocation {
  String kodeKab;
  String kodeKec;
  String kodeKel;
  String namaKab;
  String namaKec;
  String namaKel;

  CurrentLocation(
      {this.kodeKab,
      this.kodeKec,
      this.kodeKel,
      this.namaKab,
      this.namaKec,
      this.namaKel});

  CurrentLocation.fromJson(Map<String, dynamic> json) {
    kodeKab = json['kode_kab'];
    kodeKec = json['kode_kec'];
    kodeKel = json['kode_kel'];
    namaKab = json['nama_kab'];
    namaKec = json['nama_kec'];
    namaKel = json['nama_kel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kode_kab'] = this.kodeKab;
    data['kode_kec'] = this.kodeKec;
    data['kode_kel'] = this.kodeKel;
    data['nama_kab'] = this.namaKab;
    data['nama_kec'] = this.namaKec;
    data['nama_kel'] = this.namaKel;
    return data;
  }
}

class Detected {
  Desa desa;
  Desa kec;
  Radius radius;
  List<DesaLainnya> desaLainnya;

  Detected({this.desa, this.desaLainnya,this.kec, this.radius});

  Detected.fromJson(Map<String, dynamic> json) {
    desa = json['desa'] != null ? new Desa.fromJson(json['desa']) : null;
    if (json['desa_lainnya'] != null) {
      desaLainnya = new List<DesaLainnya>();
      json['desa_lainnya'].forEach((v) {
        desaLainnya.add(new DesaLainnya.fromJson(v));
      });
    }
    kec = json['kec'] != null ? new Desa.fromJson(json['kec']) : null;
    radius =
        json['radius'] != null ? new Radius.fromJson(json['radius']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.desa != null) {
      data['desa'] = this.desa.toJson();
    }
    if (this.desaLainnya != null) {
      data['desa_lainnya'] = this.desaLainnya.map((v) => v.toJson()).toList();
    }
    if (this.kec != null) {
      data['kec'] = this.kec.toJson();
    }
    if (this.radius != null) {
      data['radius'] = this.radius.toJson();
    }
    return data;
  }
}

class Desa {
  int odpProses;
  int pdpProses;
  int positif;
  int closecontactDikarantina;
  int confirmation;
  int suspectDiisolasi;


  Desa({this.odpProses, this.pdpProses, this.positif});

  Desa.fromJson(Map<String, dynamic> json) {
    odpProses = json['odp_proses'];
    pdpProses = json['pdp_proses'];
    positif = json['positif'];
    closecontactDikarantina = json['closecontact_dikarantina'];
    confirmation = json['confirmation'];
    suspectDiisolasi = json['suspect_diisolasi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['odp_proses'] = this.odpProses;
    data['pdp_proses'] = this.pdpProses;
    data['positif'] = this.positif;
    data['closecontact_dikarantina'] = this.closecontactDikarantina;
    data['confirmation'] = this.confirmation;
    data['suspect_diisolasi'] = this.suspectDiisolasi;
    return data;
  }
}

class Radius {
  double kmRadius;
  int odpProses;
  int pdpProses;
  int positif;
  int closecontactDikarantina;
  int confirmation;
  int suspectDiisolasi;

  Radius({this.kmRadius, this.odpProses, this.pdpProses, this.positif});

  Radius.fromJson(Map<String, dynamic> json) {
    kmRadius = json['km_radius'];
    odpProses = json['odp_proses'];
    pdpProses = json['pdp_proses'];
    positif = json['positif'];
    closecontactDikarantina = json['closecontact_dikarantina'];
    confirmation = json['confirmation'];
    suspectDiisolasi = json['suspect_diisolasi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['km_radius'] = this.kmRadius;
    data['odp_proses'] = this.odpProses;
    data['pdp_proses'] = this.pdpProses;
    data['positif'] = this.positif;
    data['closecontact_dikarantina'] = this.closecontactDikarantina;
    data['confirmation'] = this.confirmation;
    data['suspect_diisolasi'] = this.suspectDiisolasi;
    return data;
  }
}

class DesaLainnya {
  int closecontactDikarantina;
  int confirmation;
  String kodeDesa;
  String namaDesa;
  int suspectDiisolasi;

  DesaLainnya(
      {this.closecontactDikarantina,
        this.confirmation,
        this.kodeDesa,
        this.namaDesa,
        this.suspectDiisolasi});

  DesaLainnya.fromJson(Map<String, dynamic> json) {
    closecontactDikarantina = json['closecontact_dikarantina'];
    confirmation = json['confirmation'];
    kodeDesa = json['kode_desa'];
    namaDesa = json['nama_desa'];
    suspectDiisolasi = json['suspect_diisolasi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['closecontact_dikarantina'] = this.closecontactDikarantina;
    data['confirmation'] = this.confirmation;
    data['kode_desa'] = this.kodeDesa;
    data['nama_desa'] = this.namaDesa;
    data['suspect_diisolasi'] = this.suspectDiisolasi;
    return data;
  }
}
