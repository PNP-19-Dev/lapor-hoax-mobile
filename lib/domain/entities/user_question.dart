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

  @override
  List<Object?> get props => [user, ans1, ans2, ans3, quest1, quest2, quest3];
}
