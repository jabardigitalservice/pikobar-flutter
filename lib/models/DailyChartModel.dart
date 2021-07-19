class DailyChartModel {
  String message;
  int error;
  Metadata metadata;
  Tren tren;
  List<Data> data;

  DailyChartModel(
      {this.message, this.error, this.metadata, this.tren, this.data});

  DailyChartModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    error = json['error'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    tren = json['tren'] != null ? new Tren.fromJson(json['tren']) : null;
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['error'] = this.error;
    if (this.metadata != null) {
      data['metadata'] = this.metadata.toJson();
    }
    if (this.tren != null) {
      data['tren'] = this.tren.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Metadata {
  String dataSource;
  Parameter parameter;
  String lastUpdate;

  Metadata({this.dataSource, this.parameter, this.lastUpdate});

  Metadata.fromJson(Map<String, dynamic> json) {
    dataSource = json['data_source'];
    parameter = json['parameter'] != null
        ? new Parameter.fromJson(json['parameter'])
        : null;
    lastUpdate = json['last_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data_source'] = this.dataSource;
    if (this.parameter != null) {
      data['parameter'] = this.parameter.toJson();
    }
    data['last_update'] = this.lastUpdate;
    return data;
  }
}

class Parameter {
  String kodeKab;
  String kodeKec;
  List<String> sort;
  List<String> wilayah;
  String kodeKel;
  List<String> tanggal;

  Parameter(
      {this.kodeKab,
      this.kodeKec,
      this.sort,
      this.wilayah,
      this.kodeKel,
      this.tanggal});

  Parameter.fromJson(Map<String, dynamic> json) {
    kodeKab = json['kode_kab'];
    kodeKec = json['kode_kec'];
    sort = json['sort'].cast<String>();
    wilayah = json['wilayah'].cast<String>();
    kodeKel = json['kode_kel'];
    tanggal = json['tanggal'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kode_kab'] = this.kodeKab;
    data['kode_kec'] = this.kodeKec;
    data['sort'] = this.sort;
    data['wilayah'] = this.wilayah;
    data['kode_kel'] = this.kodeKel;
    data['tanggal'] = this.tanggal;
    return data;
  }
}

class Data {
  List<Series> series;
  String kodeKab;
  String namaKab;
  Tren tren;

  Data({this.series, this.kodeKab, this.namaKab, this.tren});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['series'] != null) {
      series = new List<Series>();
      json['series'].forEach((v) {
        series.add(new Series.fromJson(v));
      });
    }
    kodeKab = json['kode_kab'];
    namaKab = json['nama_kab'];
    tren = json['tren'] != null ? new Tren.fromJson(json['tren']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.series != null) {
      data['series'] = this.series.map((v) => v.toJson()).toList();
    }
    data['kode_kab'] = this.kodeKab;
    data['nama_kab'] = this.namaKab;
    if (this.tren != null) {
      data['tren'] = this.tren.toJson();
    }
    return data;
  }
}

class Series {
  Kumulatif kumulatif;
  String kodeKab;
  String namaKab;
  Harian harian;
  String tanggal;

  Series(
      {this.kumulatif, this.kodeKab, this.namaKab, this.harian, this.tanggal});

  Series.fromJson(Map<String, dynamic> json) {
    kumulatif = json['kumulatif'] != null
        ? new Kumulatif.fromJson(json['kumulatif'])
        : null;
    kodeKab = json['kode_kab'];
    namaKab = json['nama_kab'];
    harian =
        json['harian'] != null ? new Harian.fromJson(json['harian']) : null;
    tanggal = json['tanggal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.kumulatif != null) {
      data['kumulatif'] = this.kumulatif.toJson();
    }
    data['kode_kab'] = this.kodeKab;
    data['nama_kab'] = this.namaKab;
    if (this.harian != null) {
      data['harian'] = this.harian.toJson();
    }
    data['tanggal'] = this.tanggal;
    return data;
  }
}

class Kumulatif {
  int suspectDiisolasi;
  int probableMeninggal;
  int suspectMeninggal;
  int closecontactDiscarded;
  int closecontactTotal;
  int confirmationMeninggal;
  int confirmationSelesai;
  int probableTotal;
  int probableDiscarded;
  int suspectDiscarded;
  int closecontactDikarantina;
  int probableDiisolasi;
  int suspectTotal;
  int confirmationDiisolasi;
  int confirmationTotal;

  Kumulatif(
      {this.suspectDiisolasi,
      this.probableMeninggal,
      this.suspectMeninggal,
      this.closecontactDiscarded,
      this.closecontactTotal,
      this.confirmationMeninggal,
      this.confirmationSelesai,
      this.probableTotal,
      this.probableDiscarded,
      this.suspectDiscarded,
      this.closecontactDikarantina,
      this.probableDiisolasi,
      this.suspectTotal,
      this.confirmationDiisolasi,
      this.confirmationTotal});

  Kumulatif.fromJson(Map<String, dynamic> json) {
    suspectDiisolasi = json['suspect_diisolasi'];
    probableMeninggal = json['probable_meninggal'];
    suspectMeninggal = json['suspect_meninggal'];
    closecontactDiscarded = json['closecontact_discarded'];
    closecontactTotal = json['closecontact_total'];
    confirmationMeninggal = json['confirmation_meninggal'];
    confirmationSelesai = json['confirmation_selesai'];
    probableTotal = json['probable_total'];
    probableDiscarded = json['probable_discarded'];
    suspectDiscarded = json['suspect_discarded'];
    closecontactDikarantina = json['closecontact_dikarantina'];
    probableDiisolasi = json['probable_diisolasi'];
    suspectTotal = json['suspect_total'];
    confirmationDiisolasi = json['confirmation_diisolasi'];
    confirmationTotal = json['confirmation_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['suspect_diisolasi'] = this.suspectDiisolasi;
    data['probable_meninggal'] = this.probableMeninggal;
    data['suspect_meninggal'] = this.suspectMeninggal;
    data['closecontact_discarded'] = this.closecontactDiscarded;
    data['closecontact_total'] = this.closecontactTotal;
    data['confirmation_meninggal'] = this.confirmationMeninggal;
    data['confirmation_selesai'] = this.confirmationSelesai;
    data['probable_total'] = this.probableTotal;
    data['probable_discarded'] = this.probableDiscarded;
    data['suspect_discarded'] = this.suspectDiscarded;
    data['closecontact_dikarantina'] = this.closecontactDikarantina;
    data['probable_diisolasi'] = this.probableDiisolasi;
    data['suspect_total'] = this.suspectTotal;
    data['confirmation_diisolasi'] = this.confirmationDiisolasi;
    data['confirmation_total'] = this.confirmationTotal;
    return data;
  }
}

class Harian {
  int suspectDiisolasi;
  int probableTotal;
  int probableMeninggal;
  int suspectMeninggal;
  int closecontactDiscarded;
  double probableRatarata;
  double closecontactRatarata;
  int closecontactTotal;
  double suspectRatarata;
  int confirmationMeninggal;
  int confirmationTotal;
  double confirmationRatarata;
  int probableDiscarded;
  int suspectDiscarded;
  int closecontactDikarantina;
  int probableDiisolasi;
  int suspectTotal;
  int confirmationDiisolasi;
  int confirmationSelesai;

  Harian(
      {this.suspectDiisolasi,
      this.probableTotal,
      this.probableMeninggal,
      this.suspectMeninggal,
      this.closecontactDiscarded,
      this.probableRatarata,
      this.closecontactRatarata,
      this.closecontactTotal,
      this.suspectRatarata,
      this.confirmationMeninggal,
      this.confirmationTotal,
      this.confirmationRatarata,
      this.probableDiscarded,
      this.suspectDiscarded,
      this.closecontactDikarantina,
      this.probableDiisolasi,
      this.suspectTotal,
      this.confirmationDiisolasi,
      this.confirmationSelesai});

  Harian.fromJson(Map<String, dynamic> json) {
    suspectDiisolasi = json['suspect_diisolasi'];
    probableTotal = json['probable_total'];
    probableMeninggal = json['probable_meninggal'];
    suspectMeninggal = json['suspect_meninggal'];
    closecontactDiscarded = json['closecontact_discarded'];
    probableRatarata = json['probable_ratarata'];
    closecontactRatarata = json['closecontact_ratarata'];
    closecontactTotal = json['closecontact_total'];
    suspectRatarata = json['suspect_ratarata'];
    confirmationMeninggal = json['confirmation_meninggal'];
    confirmationTotal = json['confirmation_total'];
    confirmationRatarata = json['confirmation_ratarata'];
    probableDiscarded = json['probable_discarded'];
    suspectDiscarded = json['suspect_discarded'];
    closecontactDikarantina = json['closecontact_dikarantina'];
    probableDiisolasi = json['probable_diisolasi'];
    suspectTotal = json['suspect_total'];
    confirmationDiisolasi = json['confirmation_diisolasi'];
    confirmationSelesai = json['confirmation_selesai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['suspect_diisolasi'] = this.suspectDiisolasi;
    data['probable_total'] = this.probableTotal;
    data['probable_meninggal'] = this.probableMeninggal;
    data['suspect_meninggal'] = this.suspectMeninggal;
    data['closecontact_discarded'] = this.closecontactDiscarded;
    data['probable_ratarata'] = this.probableRatarata;
    data['closecontact_ratarata'] = this.closecontactRatarata;
    data['closecontact_total'] = this.closecontactTotal;
    data['suspect_ratarata'] = this.suspectRatarata;
    data['confirmation_meninggal'] = this.confirmationMeninggal;
    data['confirmation_total'] = this.confirmationTotal;
    data['confirmation_ratarata'] = this.confirmationRatarata;
    data['probable_discarded'] = this.probableDiscarded;
    data['suspect_discarded'] = this.suspectDiscarded;
    data['closecontact_dikarantina'] = this.closecontactDikarantina;
    data['probable_diisolasi'] = this.probableDiisolasi;
    data['suspect_total'] = this.suspectTotal;
    data['confirmation_diisolasi'] = this.confirmationDiisolasi;
    data['confirmation_selesai'] = this.confirmationSelesai;
    return data;
  }
}

class Tren {
  ConfirmationMeninggal confirmationMeninggal;
  int confirmationRatarataMingguKemarin;
  double persentasi;
  String conclusion;
  ConfirmationMeninggal confirmationTotal;
  int selisih;
  ConfirmationMeninggal confirmationSelesai;
  ConfirmationMeninggal confirmationDiisolasi;
  int confirmationRatarataMingguIni;

  Tren(
      {this.confirmationMeninggal,
      this.confirmationRatarataMingguKemarin,
      this.persentasi,
      this.conclusion,
      this.confirmationTotal,
      this.selisih,
      this.confirmationSelesai,
      this.confirmationDiisolasi,
      this.confirmationRatarataMingguIni});

  Tren.fromJson(Map<String, dynamic> json) {
    confirmationMeninggal = json['confirmation_meninggal'] != null
        ? new ConfirmationMeninggal.fromJson(json['confirmation_meninggal'])
        : null;
    confirmationRatarataMingguKemarin =
        json['confirmation_ratarata_minggu_kemarin'];
    persentasi = json['persentasi'];
    conclusion = json['conclusion'];
    confirmationTotal = json['confirmation_total'] != null
        ? new ConfirmationMeninggal.fromJson(json['confirmation_total'])
        : null;
    selisih = json['selisih'];
    confirmationSelesai = json['confirmation_selesai'] != null
        ? new ConfirmationMeninggal.fromJson(json['confirmation_selesai'])
        : null;
    confirmationDiisolasi = json['confirmation_diisolasi'] != null
        ? new ConfirmationMeninggal.fromJson(json['confirmation_diisolasi'])
        : null;
    confirmationRatarataMingguIni = json['confirmation_ratarata_minggu_ini'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.confirmationMeninggal != null) {
      data['confirmation_meninggal'] = this.confirmationMeninggal.toJson();
    }
    data['confirmation_ratarata_minggu_kemarin'] =
        this.confirmationRatarataMingguKemarin;
    data['persentasi'] = this.persentasi;
    data['conclusion'] = this.conclusion;
    if (this.confirmationTotal != null) {
      data['confirmation_total'] = this.confirmationTotal.toJson();
    }
    data['selisih'] = this.selisih;
    if (this.confirmationSelesai != null) {
      data['confirmation_selesai'] = this.confirmationSelesai.toJson();
    }
    if (this.confirmationDiisolasi != null) {
      data['confirmation_diisolasi'] = this.confirmationDiisolasi.toJson();
    }
    data['confirmation_ratarata_minggu_ini'] =
        this.confirmationRatarataMingguIni;
    return data;
  }
}

class ConfirmationMeninggal {
  String conclusion;
  int selisih;
  int kemarin;
  int sekarang;
  double persentasi;

  ConfirmationMeninggal(
      {this.conclusion,
      this.selisih,
      this.kemarin,
      this.sekarang,
      this.persentasi});

  ConfirmationMeninggal.fromJson(Map<String, dynamic> json) {
    conclusion = json['conclusion'];
    selisih = json['selisih'];
    kemarin = json['kemarin'];
    sekarang = json['sekarang'];
    persentasi = json['persentasi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conclusion'] = this.conclusion;
    data['selisih'] = this.selisih;
    data['kemarin'] = this.kemarin;
    data['sekarang'] = this.sekarang;
    data['persentasi'] = this.persentasi;
    return data;
  }
}

class TrenSeries {
  ConfirmationMeninggal confirmationMeninggal;
  int confirmationRatarataMingguKemarin;
  int persentasi;
  String conclusion;
  ConfirmationMeninggal confirmationTotal;
  int selisih;
  ConfirmationMeninggal confirmationSelesai;
  ConfirmationMeninggal confirmationDiisolasi;
  int confirmationRatarataMingguIni;

  TrenSeries(
      {this.confirmationMeninggal,
      this.confirmationRatarataMingguKemarin,
      this.persentasi,
      this.conclusion,
      this.confirmationTotal,
      this.selisih,
      this.confirmationSelesai,
      this.confirmationDiisolasi,
      this.confirmationRatarataMingguIni});

  TrenSeries.fromJson(Map<String, dynamic> json) {
    confirmationMeninggal = json['confirmation_meninggal'] != null
        ? new ConfirmationMeninggal.fromJson(json['confirmation_meninggal'])
        : null;
    confirmationRatarataMingguKemarin =
        json['confirmation_ratarata_minggu_kemarin'];
    persentasi = json['persentasi'];
    conclusion = json['conclusion'];
    confirmationTotal = json['confirmation_total'] != null
        ? new ConfirmationMeninggal.fromJson(json['confirmation_total'])
        : null;
    selisih = json['selisih'];
    confirmationSelesai = json['confirmation_selesai'] != null
        ? new ConfirmationMeninggal.fromJson(json['confirmation_selesai'])
        : null;
    confirmationDiisolasi = json['confirmation_diisolasi'] != null
        ? new ConfirmationMeninggal.fromJson(json['confirmation_diisolasi'])
        : null;
    confirmationRatarataMingguIni = json['confirmation_ratarata_minggu_ini'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.confirmationMeninggal != null) {
      data['confirmation_meninggal'] = this.confirmationMeninggal.toJson();
    }
    data['confirmation_ratarata_minggu_kemarin'] =
        this.confirmationRatarataMingguKemarin;
    data['persentasi'] = this.persentasi;
    data['conclusion'] = this.conclusion;
    if (this.confirmationTotal != null) {
      data['confirmation_total'] = this.confirmationTotal.toJson();
    }
    data['selisih'] = this.selisih;
    if (this.confirmationSelesai != null) {
      data['confirmation_selesai'] = this.confirmationSelesai.toJson();
    }
    if (this.confirmationDiisolasi != null) {
      data['confirmation_diisolasi'] = this.confirmationDiisolasi.toJson();
    }
    data['confirmation_ratarata_minggu_ini'] =
        this.confirmationRatarataMingguIni;
    return data;
  }
}
