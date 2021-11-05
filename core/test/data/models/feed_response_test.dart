import 'dart:convert';

import 'package:core/data/models/feed_model.dart';
import 'package:core/data/models/feed_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tFeedModel = FeedModel(
      id: 26,
      title: "Libur Maulid Nabi 2021 Digeser: Tanggal dan Alasannya",
      content: "content",
      thumbnail:
          "https://django-lapor-hoax.s3.amazonaws.com/feeds/1.jpeg?AWSAccessKeyId=AKIAXSGIDQGEESDBZHGJ&Signature=yXthBiGVfwxxC%2Flai%2FvL0PZAMz4%3D&Expires=1634826461",
      date: "2021-10-13T01:34:58.831621+07:00",
      view: 0,
      author: 1);

  final tFeedResponseModel = FeedResponse(
    count: 1,
    next: "null",
    previous: "null",
    feedList: [tFeedModel],
  );

  group('from json', () {
    test('should return a valid model from JSON', () {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/feed.json'));
      // act
      final result = FeedResponse.fromJson(jsonMap);
      // assert
      expect(result, tFeedResponseModel);
    });
  });

  group('to json', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tFeedResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "count": 1,
        "next": "null",
        "previous": "null",
        "results": [
          {
            "id": 26,
            "title": "Libur Maulid Nabi 2021 Digeser: Tanggal dan Alasannya",
            "content": "content",
            "thumbnail":
                "https://django-lapor-hoax.s3.amazonaws.com/feeds/1.jpeg?AWSAccessKeyId=AKIAXSGIDQGEESDBZHGJ&Signature=yXthBiGVfwxxC%2Flai%2FvL0PZAMz4%3D&Expires=1634826461",
            "date": "2021-10-13T01:34:58.831621+07:00",
            "view": 0,
            "author": 1
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
