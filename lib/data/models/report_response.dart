import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:laporhoax/data/models/report_model.dart';

UserReport userReportFromJson(String str) =>
    UserReport.fromJson(json.decode(str));

class UserReport extends Equatable {
  UserReport({
    required this.count,
    required this.next,
    required this.previous,
    required this.reportList,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<ReportModel> reportList;

  factory UserReport.fromJson(Map<String, dynamic> json) => UserReport(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        reportList: List<ReportModel>.from((json["results"] as List)
            .map((x) => ReportModel.fromJson(x))
            .where((element) => element.img != null)),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(reportList.map((x) => x.toJson())),
      };

  @override
  // TODO: implement props
  List<Object?> get props => [reportList];
}
