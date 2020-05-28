
class BannerModel {
  String actionUrl;
  dynamic sequence;
  String title;
  String url;
  bool login;

  BannerModel({
    this.actionUrl,
    this.sequence,
    this.title,
    this.url,
    this.login,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
    actionUrl: json["action_url"] ?? '',
    sequence: json["sequence"] ?? null,
    title: json["title"] ?? '',
    url: json["url"] ?? '',
    login: json["login"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "action_url": actionUrl ?? '',
    "sequence": sequence ?? null,
    "title": title ?? '',
    "url": url ?? '',
    "login": login ?? false,
  };
}
