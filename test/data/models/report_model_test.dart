/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.56
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/report_model.dart';
import 'package:laporhoax/domain/entities/report.dart';

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
