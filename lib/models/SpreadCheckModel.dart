import 'dart:convert';

SpreadCheckModel spreadCheckModelFromJson(String str) => SpreadCheckModel.fromJson(json.decode(str));

class SpreadCheckModel {
  bool enabled;
  String webViewUrl;

  SpreadCheckModel({
    this.enabled,
    this.webViewUrl,
  });

  factory SpreadCheckModel.fromJson(Map<String, dynamic> json) => SpreadCheckModel(
    enabled: json["enabled"],
    webViewUrl: json["webview_url"],
  );

  Map<String, dynamic> toJson() => {
    "enabled": enabled,
    "webview_url": webViewUrl,
  };
}
