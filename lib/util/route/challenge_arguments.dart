import 'package:laporhoax/data/models/user_question_model.dart';
import 'package:laporhoax/domain/entities/user.dart';

class ChallengeArguments {
  final User user;
  final UserQuestionModel challenge;

  ChallengeArguments(this.user, this.challenge);
}
