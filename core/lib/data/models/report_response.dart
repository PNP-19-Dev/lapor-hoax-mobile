import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../data/models/report_model.dart';

ReportResponse userReportFromJson(String str) =>
    ReportResponse.fromJson(json.decode(str));

class ReportResponse extends Equatable {
  const ReportResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.reportList,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<ReportModel> reportList;

  factory ReportResponse.fromJson(Map<String, dynamic> json) => ReportResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        reportList: List<ReportModel>.from((json["results"] as List)
            .map((x) => ReportModel.fromJson(x))
            .where((element) => element.img != null)),
      );

  Map<String, dynamic> toJson() =>
      {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(
          reportList.map((x) => x.toJson()),
        ),
      };

  @override
  List<Object?> get props => [reportList];
}
