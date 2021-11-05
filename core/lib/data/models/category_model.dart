import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';

class CategoryModel extends Equatable {
  CategoryModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
      );

  Category toEntity() => Category(id: id, name: name);

  @override
  List<Object?> get props => [id, name];
}
