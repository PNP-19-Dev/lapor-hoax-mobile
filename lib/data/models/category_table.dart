import 'package:equatable/equatable.dart';
import 'package:laporhoax/data/models/category_model.dart';
import 'package:laporhoax/domain/entities/category.dart';

class CategoryTable extends Equatable {
  CategoryTable({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory CategoryTable.fromEntity(Category category) => CategoryTable(
        id: category.id,
        name: category.name,
      );

  factory CategoryTable.fromMap(Map<String, dynamic> map) => CategoryTable(
        id: map['id'],
        name: map['name'],
      );

  factory CategoryTable.fromDTO(CategoryModel category) => CategoryTable(
    id: category.id,
    name: category.name,
  );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  Category toEntity() => Category(id: id, name: name);

  @override
  List<Object?> get props => [id, name];
}
