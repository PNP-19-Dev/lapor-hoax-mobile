import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Question extends Equatable {
  Question({
    required this.id,
    required this.question,
  });

  final int id;
  final String question;

  @override
  List<Object?> get props => [id, question];
}
