import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/report_model.dart';
import 'package:laporhoax/data/models/report_response.dart';

import '../../json_reader.dart';

void main() {
  final tReportModel = ReportModel(
      id: 59,
      url: "www.aslihoax.com",
      img:
          "https://django-lapor-hoax.s3.amazonaws.com/reports/Capture.PNG?AWSAccessKeyId=AKIAXSGIDQGEESDBZHGJ&Signature=6eGLu1R0U3qsyUf5sb%2B2up%2B9DzU%3D&Expires=1634827154",
      category: "Isu SARA",
      status: "Selesai",
      isAnonym: false,
      dateReported: "2021-10-13T03:33:41.647173+07:00",
      description: "Menyebarkan berita hoax",
      prosesDate: "2021-10-15T03:52:34.695336+07:00",
      verdict: "Diterima",
      verdictDesc: "respon",
      verdictDate: "2021-10-15T04:01:28.042973+07:00",
      user: 1,
      verdictJudge: 1);

  final tReportResponseModel = ReportResponse(
    count: 1,
    next: "null",
    previous: "null",
    reportList: [tReportModel],
  );

  group('from json', () {
    test('should return a valid model from JSON', () {
      // arrange
      final Map<String, dynamic> jsonMap =
          jsonDecode(readJson('dummy_data/report.json'));
      // act
      final result = ReportResponse.fromJson(jsonMap);
      // assert
      expect(result, tReportResponseModel);
    });
  });

  group('to json', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tReportResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "count": 1,
        "next": "null",
        "previous": "null",
        "results": [
          {
            "id": 59,
            "url": "www.aslihoax.com",
            "img":
                "https://django-lapor-hoax.s3.amazonaws.com/reports/Capture.PNG?AWSAccessKeyId=AKIAXSGIDQGEESDBZHGJ&Signature=6eGLu1R0U3qsyUf5sb%2B2up%2B9DzU%3D&Expires=1634827154",
            "category": "Isu SARA",
            "status": "Selesai",
            "isAnonym": false,
            "dateReported": "2021-10-13T03:33:41.647173+07:00",
            "description": "Menyebarkan berita hoax",
            "prosesDate": "2021-10-15T03:52:34.695336+07:00",
            "verdict": "Diterima",
            "verdictDesc": "respon",
            "verdictDate": "2021-10-15T04:01:28.042973+07:00",
            "user": 1,
            "verdictJudge": 1
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
