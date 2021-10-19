class Question {
  Question({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  dynamic next;
  dynamic previous;
  List<QuestionResult> results;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<QuestionResult>.from(
            json["results"].map((x) => QuestionResult.fromJson(x))),
      );
}

class QuestionResult {
  QuestionResult({
    required this.id,
    required this.question,
  });

  int id;
  String question;

  factory QuestionResult.fromJson(Map<String, dynamic> json) => QuestionResult(
        id: json["id"],
        question: json["question"],
      );
}
