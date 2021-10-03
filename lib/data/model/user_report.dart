import 'dart:convert';

List<UserReport> userReportsFromJson(String str) =>
    List<UserReport>.from(json.decode(str).map((x) => UserReport.fromJson(x)));

class UserReport {
  UserReport({
    required this.url,
    required this.img,
    required this.category,
    required this.status,
    required this.isAnonym,
    required this.dateReported,
    required this.description,
    required this.verdict,
    required this.verdictDesc,
    required this.verdictDate,
    required this.user,
    required this.verdictJudge,
  });

  String url;
  String img;
  String category;
  String status;
  bool isAnonym;
  DateTime dateReported;
  String description;
  String verdict;
  String verdictDesc;
  DateTime verdictDate;
  int user;
  int verdictJudge;

  factory UserReport.fromJson(Map<String, dynamic> json) => UserReport(
        url: json["url"],
        img: json["img"],
        category: json["category"],
        status: json["status"],
        isAnonym: json["isAnonym"],
        dateReported: DateTime.parse(json["dateReported"]),
        description: json["description"],
        verdict: json["verdict"],
        verdictDesc: json["verdictDesc"],
        verdictDate: DateTime.parse(json["verdictDate"]),
        user: json["user"],
        verdictJudge: json["verdictJudge"],
      );
}
