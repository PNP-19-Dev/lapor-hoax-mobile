import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/user_question_model.dart';
import 'package:laporhoax/domain/entities/user_question.dart';

void main() {
  final tQuestionModel = UserQuestionModel(
      user: 'user',
      quest1: 1,
      quest2: 2,
      quest3: 3,
      ans1: 'ans1',
      ans2: 'ans2',
      ans3: 'ans3',
  );

  final tQuestion = UserQuestion(
    user: 'user',
    quest1: 1,
    quest2: 2,
    quest3: 3,
    ans1: 'ans1',
    ans2: 'ans2',
    ans3: 'ans3',
  );

  final questionMap = {
    'user': 'user',
    'quest1': 1,
    'quest2': 2,
    'quest3': 3,
    'ans1' : 'ans1',
    'ans2' : 'ans2',
    'ans3' : 'ans3',
  };

  group('User Question Model', () {
    test('should be a subclass of Entity', () async {
      final result = UserQuestionModel.fromDTO(tQuestion);
      expect(result, tQuestionModel);
    });

    test('should be a subclass of Entity From JSON', () async {
      final result = UserQuestionModel.fromJson(questionMap);
      expect(result, tQuestionModel);
    });

    test('should be a valid entity', () async {
      final result = tQuestionModel.toEntity();
      expect(result, tQuestion);
    });

    test('should be a valid json', () async {
      final result = tQuestionModel.toJson();
      expect(result, questionMap);
    });
  });
}
