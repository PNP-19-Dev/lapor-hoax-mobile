/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.56
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/question_model.dart';
import 'package:laporhoax/data/models/question_table.dart';
import 'package:laporhoax/domain/entities/question.dart';

void main() {
  final tQuestionTable = QuestionTable(id: 1, question: "question");

  final tQuestionModel = QuestionModel(id: 1, question: "question");

  final tQuestion = Question(id: 1, question: "question");

  final questionMap = {"id": 1, "question": "question"};

  group('Question Table', () {
    test('should be a subclass of FeedTable from Entity', () async {
      final result = QuestionTable.fromEntity(tQuestion);
      expect(result, tQuestionTable);
    });

    test('should be a subclass of FeedTable from Map', () async {
      final result = QuestionTable.fromMap(questionMap);
      expect(result, tQuestionTable);
    });

    test('should be a subclass of FeedTable from Entity', () async {
      final result = QuestionTable.fromDTO(tQuestionModel);
      expect(result, tQuestionTable);
    });

    test('should be a valid JSON', () async {
      final result = tQuestionTable.toJson();
      expect(result, questionMap);
    });

    test('should be a valid Question', () async {
      final result = tQuestionTable.toEntity();
      expect(result, tQuestion);
    });
  });
}
