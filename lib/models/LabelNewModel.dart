import 'dart:convert';

class LabelNewModel {
  LabelNewModel({
    this.id,
    this.isRead,
  });

  String id;
  String isRead;

  factory LabelNewModel.fromJson(Map<String, dynamic> json) => LabelNewModel(
        id: json["id"],
        isRead: json["is_read"],
      );

  static Map<String, dynamic> toMap(LabelNewModel labelNewModel) => {
        "id": labelNewModel.id,
        "is_read": labelNewModel.isRead,
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
