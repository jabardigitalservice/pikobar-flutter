

class HumasJabarModel {
  int id;
  String postTitle;
  String thumbnail;
  String slug;
  String tglPublish;

  HumasJabarModel({
    this.id,
    this.postTitle,
    this.thumbnail,
    this.slug,
    this.tglPublish,
  });

  factory HumasJabarModel.fromDatabaseMap(Map<String, dynamic> row) {
    HumasJabarModel item = HumasJabarModel(
      id: row['id'],
      postTitle: row['postTitle'],
      thumbnail: row['thumbnail'],
      slug: row['slug'],
      tglPublish: row['tglPublish'],
    );

    return item;
  }

  factory HumasJabarModel.fromJson(Map<String, dynamic> json) =>
      HumasJabarModel(
        id: json["ID"],
        postTitle: json["post_title"],
        thumbnail: json["thumbnail"],
        slug: json["slug"],
        tglPublish: json["tgl_publish"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "post_title": postTitle,
        "thumbnail": thumbnail,
        "slug": slug,
        "tgl_publish": tglPublish,
      };
}
