import 'package:equatable/equatable.dart';

class UserQuestion extends Equatable {
  final String user;
  final int? quest1;
  final int? quest2;
  final int? quest3;
  final String? ans1;
  final String? ans2;
  final String? ans3;

  UserQuestion(
      {required this.user,
      required this.quest1,
      required this.quest2,
      required this.quest3,
      required this.ans1,
      required this.ans2,
      required this.ans3});

  factory UserQuestion.fromJson(Map<String, dynamic> json) => UserQuestion(
        user: json['user'],
        quest1: json['quest1'],
        quest2: json['quest2'],
        quest3: json['quest3'],
        ans1: json['ans1'],
        ans2: json['ans2'],
        ans3: json['ans3'],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "ans1": ans1,
        "ans2": ans2,
        "ans3": ans3,
        "quest1": quest1,
        "quest2": quest2,
        "quest3": quest3,
      };

  @override
  List<Object?> get props => [user, ans1, ans2, ans3, quest1, quest2, quest3];
}
