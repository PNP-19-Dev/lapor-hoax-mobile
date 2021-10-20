import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Question extends Equatable {
  Question({
    required this.id,
    required this.question,
  });

  int id;
  String question;

  @override
  List<Object?> get props => [id, question];
}
