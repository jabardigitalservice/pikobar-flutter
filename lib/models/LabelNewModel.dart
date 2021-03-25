import 'dart:convert';

class LabelNewModel {
  LabelNewModel({
    this.id,
    this.isRead,
    this.date,
  });

  String id;
  String isRead;
  String date;

  factory LabelNewModel.fromJson(Map<String, dynamic> json) => LabelNewModel(
        id: json["id"],
        isRead: json["is_read"],
        date: json["date"],
      );

  static Map<String, dynamic> toMap(LabelNewModel labelNewModel) => {
        "id": labelNewModel.id,
        "is_read": labelNewModel.isRead,
        "date": labelNewModel.date,
      };

  static String encode(List<LabelNewModel> labels) => json.encode(
        labels
            .map<Map<String, dynamic>>((music) => LabelNewModel.toMap(music))
            .toList(),
      );

  static List<LabelNewModel> decode(String labels) =>
      (json.decode(labels) as List<dynamic>)
          .map<LabelNewModel>((item) => LabelNewModel.fromJson(item))
          .toList();
}
