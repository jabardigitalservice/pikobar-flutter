class RapidTestModel {
  int statusCode;
  Data data;

  RapidTestModel({this.statusCode, this.data});

  RapidTestModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  Metadata metadata;
  Content content;

  Data({this.metadata, this.content});

  Data.fromJson(Map<String, dynamic> json) {
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    content =
        json['content'] != null ? new Content.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.metadata != null) {
      data['metadata'] = this.metadata.toJson();
    }
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    return data;
  }
}

class Metadata {
  String lastUpdate;

  Metadata({this.lastUpdate});

  Metadata.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['last_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_update'] = this.lastUpdate;
    return data;
  }
}

class Content {
  String kodeProv;
  String namaProv;
  int odpProses;
  int odpSelesai;
  int odpTotal;
  OdpTotalPerGender odpTotalPerGender;
  OdpTotalPerUsia odpTotalPerUsia;
  int pdpProses;
  int pdpSelesai;
  int pdpTotal;
  OdpTotalPerGender pdpTotalPerGender;
  OdpTotalPerUsia pdpTotalPerUsia;
  int positif;
  OdpTotalPerGender positifPerGender;
  OdpTotalPerUsia positifPerUsia;
  int sembuh;
  OdpTotalPerGender sembuhPerGender;
  OdpTotalPerUsia sembuhPerUsia;
  int meninggal;
  OdpTotalPerGender meninggalPerGender;
  OdpTotalPerUsia meninggalPerUsia;
  Rdt rdt;

  Content(
      {this.kodeProv,
      this.namaProv,
      this.odpProses,
      this.odpSelesai,
      this.odpTotal,
      this.odpTotalPerGender,
      this.odpTotalPerUsia,
      this.pdpProses,
      this.pdpSelesai,
      this.pdpTotal,
      this.pdpTotalPerGender,
      this.pdpTotalPerUsia,
      this.positif,
      this.positifPerGender,
      this.positifPerUsia,
      this.sembuh,
      this.sembuhPerGender,
      this.sembuhPerUsia,
      this.meninggal,
      this.meninggalPerGender,
      this.meninggalPerUsia,
      this.rdt});

  Content.fromJson(Map<String, dynamic> json) {
    kodeProv = json['kode_prov'];
    namaProv = json['nama_prov'];
    odpProses = json['odp_proses'];
    odpSelesai = json['odp_selesai'];
    odpTotal = json['odp_total'];
    odpTotalPerGender = json['odp_total_per_gender'] != null
        ? new OdpTotalPerGender.fromJson(json['odp_total_per_gender'])
        : null;
    odpTotalPerUsia = json['odp_total_per_usia'] != null
        ? new OdpTotalPerUsia.fromJson(json['odp_total_per_usia'])
        : null;
    pdpProses = json['pdp_proses'];
    pdpSelesai = json['pdp_selesai'];
    pdpTotal = json['pdp_total'];
    pdpTotalPerGender = json['pdp_total_per_gender'] != null
        ? new OdpTotalPerGender.fromJson(json['pdp_total_per_gender'])
        : null;
    pdpTotalPerUsia = json['pdp_total_per_usia'] != null
        ? new OdpTotalPerUsia.fromJson(json['pdp_total_per_usia'])
        : null;
    positif = json['positif'];
    positifPerGender = json['positif_per_gender'] != null
        ? new OdpTotalPerGender.fromJson(json['positif_per_gender'])
        : null;
    positifPerUsia = json['positif_per_usia'] != null
        ? new OdpTotalPerUsia.fromJson(json['positif_per_usia'])
        : null;
    sembuh = json['sembuh'];
    sembuhPerGender = json['sembuh_per_gender'] != null
        ? new OdpTotalPerGender.fromJson(json['sembuh_per_gender'])
        : null;
    sembuhPerUsia = json['sembuh_per_usia'] != null
        ? new OdpTotalPerUsia.fromJson(json['sembuh_per_usia'])
        : null;
    meninggal = json['meninggal'];
    meninggalPerGender = json['meninggal_per_gender'] != null
        ? new OdpTotalPerGender.fromJson(json['meninggal_per_gender'])
        : null;
    meninggalPerUsia = json['meninggal_per_usia'] != null
        ? new OdpTotalPerUsia.fromJson(json['meninggal_per_usia'])
        : null;
    rdt = json['rdt'] != null ? new Rdt.fromJson(json['rdt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kode_prov'] = this.kodeProv;
    data['nama_prov'] = this.namaProv;
    data['odp_proses'] = this.odpProses;
    data['odp_selesai'] = this.odpSelesai;
    data['odp_total'] = this.odpTotal;
    if (this.odpTotalPerGender != null) {
      data['odp_total_per_gender'] = this.odpTotalPerGender.toJson();
    }
    if (this.odpTotalPerUsia != null) {
      data['odp_total_per_usia'] = this.odpTotalPerUsia.toJson();
    }
    data['pdp_proses'] = this.pdpProses;
    data['pdp_selesai'] = this.pdpSelesai;
    data['pdp_total'] = this.pdpTotal;
    if (this.pdpTotalPerGender != null) {
      data['pdp_total_per_gender'] = this.pdpTotalPerGender.toJson();
    }
    if (this.pdpTotalPerUsia != null) {
      data['pdp_total_per_usia'] = this.pdpTotalPerUsia.toJson();
    }
    data['positif'] = this.positif;
    if (this.positifPerGender != null) {
      data['positif_per_gender'] = this.positifPerGender.toJson();
    }
    if (this.positifPerUsia != null) {
      data['positif_per_usia'] = this.positifPerUsia.toJson();
    }
    data['sembuh'] = this.sembuh;
    if (this.sembuhPerGender != null) {
      data['sembuh_per_gender'] = this.sembuhPerGender.toJson();
    }
    if (this.sembuhPerUsia != null) {
      data['sembuh_per_usia'] = this.sembuhPerUsia.toJson();
    }
    data['meninggal'] = this.meninggal;
    if (this.meninggalPerGender != null) {
      data['meninggal_per_gender'] = this.meninggalPerGender.toJson();
    }
    if (this.meninggalPerUsia != null) {
      data['meninggal_per_usia'] = this.meninggalPerUsia.toJson();
    }
    if (this.rdt != null) {
      data['rdt'] = this.rdt.toJson();
    }
    return data;
  }
}

class OdpTotalPerGender {
  int lakiLaki;
  int perempuan;

  OdpTotalPerGender({this.lakiLaki, this.perempuan});

  OdpTotalPerGender.fromJson(Map<String, dynamic> json) {
    lakiLaki = json['laki_laki'];
    perempuan = json['perempuan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['laki_laki'] = this.lakiLaki;
    data['perempuan'] = this.perempuan;
    return data;
  }
}

class OdpTotalPerUsia {
  Anak anak;
  Anak semua;

  OdpTotalPerUsia({this.anak, this.semua});

  OdpTotalPerUsia.fromJson(Map<String, dynamic> json) {
    anak = json['anak'] != null ? new Anak.fromJson(json['anak']) : null;
    semua = json['semua'] != null ? new Anak.fromJson(json['semua']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.anak != null) {
      data['anak'] = this.anak.toJson();
    }
    if (this.semua != null) {
      data['semua'] = this.semua.toJson();
    }
    return data;
  }
}

class Anak {
  LakiLaki lakiLaki;
  Perempuan perempuan;

  Anak({this.lakiLaki, this.perempuan});

  Anak.fromJson(Map<String, dynamic> json) {
    lakiLaki = json['laki_laki'] != null
        ? new LakiLaki.fromJson(json['laki_laki'])
        : null;
    perempuan = json['perempuan'] != null
        ? new Perempuan.fromJson(json['perempuan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lakiLaki != null) {
      data['laki_laki'] = this.lakiLaki.toJson();
    }
    if (this.perempuan != null) {
      data['perempuan'] = this.perempuan.toJson();
    }
    return data;
  }
}

class LakiLaki {
  int bawah1;
  int i15;
  int i56;
  int i618;

  LakiLaki({this.bawah1, this.i15, this.i56, this.i618});

  LakiLaki.fromJson(Map<String, dynamic> json) {
    bawah1 = json['bawah_1'];
    i15 = json['1_5'];
    i56 = json['5_6'];
    i618 = json['6_18'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bawah_1'] = this.bawah1;
    data['1_5'] = this.i15;
    data['5_6'] = this.i56;
    data['6_18'] = this.i618;
    return data;
  }
}

class Perempuan {
  int bawah5;
  int i619;
  int i2029;
  int i3039;
  int i4049;
  int i5059;
  int i6069;
  int i7079;
  int atas80;

  Perempuan(
      {this.bawah5,
      this.i619,
      this.i2029,
      this.i3039,
      this.i4049,
      this.i5059,
      this.i6069,
      this.i7079,
      this.atas80});

  Perempuan.fromJson(Map<String, dynamic> json) {
    bawah5 = json['bawah_5'];
    i619 = json['6_19'];
    i2029 = json['20_29'];
    i3039 = json['30_39'];
    i4049 = json['40_49'];
    i5059 = json['50_59'];
    i6069 = json['60_69'];
    i7079 = json['70_79'];
    atas80 = json['atas_80'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bawah_5'] = this.bawah5;
    data['6_19'] = this.i619;
    data['20_29'] = this.i2029;
    data['30_39'] = this.i3039;
    data['40_49'] = this.i4049;
    data['50_59'] = this.i5059;
    data['60_69'] = this.i6069;
    data['70_79'] = this.i7079;
    data['atas_80'] = this.atas80;
    return data;
  }
}

class Rdt {
  int total;
  int positif;
  int negatif;
  int invalid;
  int belumDiketahui;

  Rdt(
      {this.total,
      this.positif,
      this.negatif,
      this.invalid,
      this.belumDiketahui});

  Rdt.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    positif = json['positif'];
    negatif = json['negatif'];
    invalid = json['invalid'];
    belumDiketahui = json['belum_diketahui'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['positif'] = this.positif;
    data['negatif'] = this.negatif;
    data['invalid'] = this.invalid;
    data['belum_diketahui'] = this.belumDiketahui;
    return data;
  }
}
