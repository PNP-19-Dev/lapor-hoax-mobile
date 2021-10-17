import 'dart:convert';

UserReport userReportFromJson(String str) =>
    UserReport.fromJson(json.decode(str));

class UserReport {
  UserReport({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  int count;
  String? next;
  String? previous;
  List<ReportItem> results;

  factory UserReport.fromJson(Map<String, dynamic> json) => UserReport(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<ReportItem>.from(
            json["results"].map((x) => ReportItem.fromJson(x))),
      );
}

class ReportItem {
  ReportItem({
    required this.id,
    required this.url,
    required this.img,
    required this.category,
    required this.status,
    required this.isAnonym,
    required this.dateReported,
    required this.description,
    required this.prosesDate,
    required this.verdict,
    required this.verdictDesc,
    required this.verdictDate,
    required this.user,
    required this.verdictJudge,
  });

  int id;
  String? url;
  String img;
  String category;
  String status;
  bool isAnonym;
  String dateReported;
  String description;
  String? prosesDate;
  String? verdict;
  String? verdictDesc;
  String? verdictDate;
  int user;
  int? verdictJudge;

  factory ReportItem.fromJson(Map<String, dynamic> json) => ReportItem(
        id: json["id"],
        url: json["url"],
        img: json["img"],
        category: json["category"],
        status: json["status"],
        isAnonym: json["isAnonym"],
        dateReported: json["dateReported"],
        description: json["description"],
        prosesDate: json["prosesDate"],
        verdict: json["verdict"],
        verdictDesc: json["verdictDesc"],
        verdictDate: json["verdictDate"],
        user: json["user"],
        verdictJudge: json["verdictJudge"],
      );
}


