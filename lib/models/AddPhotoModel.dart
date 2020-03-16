import 'dart:convert';

AddPhotoModel addPhotoModelFromJson(String str) => AddPhotoModel.fromJson(json.decode(str));

class AddPhotoModel {
  Data data;

  AddPhotoModel({
    this.data,
  });

  factory AddPhotoModel.fromJson(Map<String, dynamic> json) => AddPhotoModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  String path;
  String url;

  Data({
    this.path,
    this.url,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    path: json["path"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "path": path,
    "url": url,
  };
}
