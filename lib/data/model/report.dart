class Report {
  Report({
    required this.id,
    required this.category,
    required this.email,
    required this.url,
    required this.img,
    required this.report,
    required this.isAnonym,
    required this.date,
  });

  int id;
  String category;
  String email;
  String url;
  String img;
  String report;
  bool isAnonym;
  DateTime date;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json["id"],
        category: json["category"],
        email: json["email"],
        url: json["url"],
        img: json["img"],
        report: json["report"],
        isAnonym: json["isAnonym"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "email": email,
        "url": url,
        "img": img,
        "report": report,
        "isAnonym": isAnonym,
        "date": date.toIso8601String(),
      };
}
