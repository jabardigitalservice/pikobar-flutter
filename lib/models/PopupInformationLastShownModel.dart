// To parse this JSON data, do
//
//     final popupInformationLastShownModel = popupInformationLastShownModelFromJson(jsonString);

import 'dart:convert';

List<PopupInformationLastShownModel> listPopupInformationLastShownFromJson(String str) => List<PopupInformationLastShownModel>.from(json.decode(str).map((x) => PopupInformationLastShownModel.fromJson(x)));

PopupInformationLastShownModel popupInformationLastShownFromJson(String str) => PopupInformationLastShownModel.fromJson(json.decode(str));

class PopupInformationLastShownModel {
  int id;
  DateTime lastShown;

  PopupInformationLastShownModel({
    this.id,
    this.lastShown,
  });

  factory PopupInformationLastShownModel.fromJson(Map<String, dynamic> json) => PopupInformationLastShownModel(
    id: json["id"],
    lastShown: DateTime.parse(json["last_shown"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "last_shown": "${lastShown.year.toString().padLeft(4, '0')}-${lastShown.month.toString().padLeft(2, '0')}-${lastShown.day.toString().padLeft(2, '0')}",
  };
}
