import 'package:equatable/equatable.dart';
import 'package:laporhoax/domain/entities/question.dart';

class QuestionModel extends Equatable {
  QuestionModel({
    required this.id,
    required this.question,
  });

  final int id;
  final String question;

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        id: json["id"],
        question: json["question"],
      );

  Question toEntity() => Question(id: id, question: question);

  @override
  List<Object?> get props => [id, question];
}
