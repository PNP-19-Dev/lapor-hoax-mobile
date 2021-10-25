import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Question extends Equatable {
  Question({
    required this.id,
    required this.question,
  });

  int id;
  String question;

  factory Question.fromMap(Map<String, dynamic> map) => Question(
        id: map["id"],
        question: map["question"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "question": question,
      };

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
      };

  @override
  List<Object?> get props => [id, question];

  Question toEntity() => Question(
        id: id,
        question: question,
      );
}
