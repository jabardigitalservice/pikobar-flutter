import 'dart:convert';

UpdateAppModel updateAppFromJson(String str) => UpdateAppModel.fromJson(json.decode(str));

class UpdateAppModel {
  String version;
  dynamic forceUpdate;

  UpdateAppModel({
    this.version,
    this.forceUpdate,
  });

  factory UpdateAppModel.fromJson(Map<String, dynamic> json) => UpdateAppModel(
    version: json["version"],
    forceUpdate: json["force_update"],
  );

  Map<String, dynamic> toJson() => {
    "version": version,
    "force_update": forceUpdate,
  };
}
