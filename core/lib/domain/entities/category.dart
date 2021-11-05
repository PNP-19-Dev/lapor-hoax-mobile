import 'package:equatable/equatable.dart';

import '../../data/models/category_model.dart';

// ignore: must_be_immutable
class Category extends Equatable {
  Category({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Category.fromMap(Map<String, dynamic> map) => Category(
        id: map["id"],
        name: map["name"],
      );

  factory Category.fromDTO(CategoryModel model) => Category(
        id: model.id,
        name: model.name,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  List<Object?> get props => [id, name];

  Category toEntity() => Category(id: id, name: name);
}
