import 'dart:convert';

List<GeneralTitleModel> listGeneralTitleModelFromJson(String str) =>
    List<GeneralTitleModel>.from(
        json.decode(str).map((x) => GeneralTitleModel.fromJson(x)));

GeneralTitleModel generalTitleModelFromJson(String str) =>
    GeneralTitleModel.fromJson(json.decode(str));

class GeneralTitleModel {
  int id;
  String title;
  int seq;
  int status;

  GeneralTitleModel({
    this.id,
    this.title,
    this.seq,
    this.status,
  });

  factory GeneralTitleModel.fromJson(Map<String, dynamic> json) =>
      GeneralTitleModel(
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
