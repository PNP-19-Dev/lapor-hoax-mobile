import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Category extends Equatable {
  Category({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  @override
  List<Object?> get props => [id, name];
}
