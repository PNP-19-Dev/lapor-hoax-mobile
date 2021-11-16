/*
 * Created by andii on 14/11/21 01.40
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 14/11/21 01.27
 */

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/question_response.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';

void main() {

  final tQuestionResponseModel = QuestionResponse(
    count: 1,
    next: "null",
    previous: "null",
    questionList: [testQuestionModel],
  );

  group('Question Response', () {
    test('should return a valid model from JSON', () {
      // arrange
      final Map<String, dynamic> jsonMap =
      json.decode(readJson('dummy_data/question.json'));
      // act
      final result = QuestionResponse.fromJson(jsonMap);
      // assert
      expect(result, tQuestionResponseModel);
    });
  });
}
