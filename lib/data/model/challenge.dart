class Challenge {
  String user;
  int? quest1;
  int? quest2;
  int? quest3;
  String? ans1;
  String? ans2;
  String? ans3;

  Challenge(
      {required this.user,
      required this.quest1,
      required this.quest2,
      required this.quest3,
      required this.ans1,
      required this.ans2,
      required this.ans3});

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
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
}
