class Author {
  int id;
  String name;
  String roleLabel;

  Author({
    this.id,
    this.name,
    this.roleLabel,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    id: json["id"],
    name: json["name"],
    roleLabel: json["role_label"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "role_label": roleLabel,
  };
}