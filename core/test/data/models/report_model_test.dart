import 'package:core/data/models/report_model.dart';
import 'package:core/domain/entities/report.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tReportModel = ReportModel(
      id: 1,
      url: "url",
      img: "img",
      category: "category",
      status: "status",
      isAnonym: false,
      dateReported: "dateReported",
      description: "description",
      prosesDate: "prosesDate",
      verdict: "verdict",
      verdictDesc: "verdictDesc",
      verdictDate: "verdictDate",
      user: 1,
      verdictJudge: 2);

  final tReport = Report(
      id: 1,
      url: "url",
      img: "img",
      category: "category",
      status: "status",
      isAnonym: false,
      dateReported: "dateReported",
      description: "description",
      prosesDate: "prosesDate",
      verdict: "verdict",
      verdictDesc: "verdictDesc",
      verdictDate: "verdictDate",
      user: 1,
      verdictJudge: 2);

  test('should be a subclass of Report entity', () async {
    final result = tReportModel.toEntity();
    expect(result, tReport);
  });
}
