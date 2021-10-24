import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Question extends Equatable {
  Question({
    required this.id,
    required this.question,
  });

  int id;
  String question;

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
}
