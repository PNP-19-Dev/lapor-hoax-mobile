import 'package:equatable/equatable.dart';
import 'package:laporhoax/data/models/question_model.dart';

class QuestionResponse extends Equatable {
  QuestionResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.questionList,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<QuestionModel> questionList;

  factory QuestionResponse.fromJson(Map<String, dynamic> json) =>
      QuestionResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        questionList: List<QuestionModel>.from(
            json["results"].map((x) => QuestionModel.fromJson(x))),
      );

  @override
  List<Object?> get props => [questionList];
}
