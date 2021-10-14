List<Category> categoryFromJson(dynamic item) =>
    List<Category>.from(item.map((x) => Category.fromJson(x)));

class Category {
  Category({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );
}
