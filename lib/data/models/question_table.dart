import 'package:equatable/equatable.dart';
import 'package:laporhoax/data/models/question_model.dart';
import 'package:laporhoax/domain/entities/question.dart';

class QuestionTable extends Equatable {
  QuestionTable({
    required this.id,
    required this.question,
  });

  final int id;
  final String question;

  factory QuestionTable.fromEntity(Question question) => QuestionTable(
        id: question.id,
        question: question.question,
      );

  factory QuestionTable.fromMap(Map<String, dynamic> map) => QuestionTable(
        id: map['id'],
        question: map['question'],
      );

  factory QuestionTable.fromDTO(QuestionModel question) => QuestionTable(
        id: question.id,
    question: question.question,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
      };

  Question toEntity() => Question(id: id, question: question);

  @override
  List<Object?> get props => [id, question];
}
