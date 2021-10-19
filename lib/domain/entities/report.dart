import 'package:equatable/equatable.dart';

class Report extends Equatable {
  Report({
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

  factory Report.fromJson(Map<String, dynamic> json) => Report(
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

  @override
  List<Object?> get props => [
        id,
        url,
        img,
        category,
        status,
        isAnonym,
        dateReported,
        description,
        prosesDate,
        verdict,
        verdictDesc,
        verdictDate,
        user,
        verdictJudge
      ];
}
