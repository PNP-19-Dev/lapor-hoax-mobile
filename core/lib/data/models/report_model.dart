import 'package:equatable/equatable.dart';

import '../../domain/entities/report.dart';

class ReportModel extends Equatable {
  ReportModel({
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

  final int id;
  final String? url;
  final String? img;
  final String category;
  final String status;
  final bool isAnonym;
  final String dateReported;
  final String description;
  final String? prosesDate;
  final String? verdict;
  final String? verdictDesc;
  final String? verdictDate;
  final int user;
  final int? verdictJudge;

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "img": img,
        "category": category,
        "status": status,
        "isAnonym": isAnonym,
        "dateReported": dateReported,
        "description": description,
        "prosesDate": prosesDate,
        "verdict": verdict,
        "verdictDesc": verdictDesc,
        "verdictDate": verdictDate,
        "user": user,
        "verdictJudge": verdictJudge,
      };

  Report toEntity() => Report(
        id: id,
        url: url,
        img: img!,
        category: category,
        status: status,
        isAnonym: isAnonym,
        dateReported: dateReported,
        description: description,
        prosesDate: prosesDate,
        verdict: verdict,
        verdictDesc: verdictDesc,
        verdictDate: verdictDate,
        user: user,
        verdictJudge: verdictJudge,
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
