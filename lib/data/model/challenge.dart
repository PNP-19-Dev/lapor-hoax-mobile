class Challenge {
  String quest1;
  String quest2;
  String quest3;
  String ans1;
  String ans2;
  String ans3;

  Challenge(
      {required this.quest1,
      required this.quest2,
      required this.quest3,
      required this.ans1,
      required this.ans2,
      required this.ans3});

  Map<String, dynamic> toJson() => {
        "quest1": quest1,
        "ans1": ans1,
        "quest2": quest2,
        "ans2": ans2,
        "quest3": quest3,
        "ans3": ans3
      };
}
