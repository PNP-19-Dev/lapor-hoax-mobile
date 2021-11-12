/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.56
 */

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/question_model.dart';
import 'package:laporhoax/data/models/question_response.dart';

import '../../json_reader.dart';

void main() {
  final tQuestionModel = QuestionModel(id: 1, question: 'Dimana anda lahir?');

  final tQuestionResponseModel = QuestionResponse(
    count: 1,
    next: "null",
    previous: "null",
    questionList: [tQuestionModel],
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
