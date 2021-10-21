import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/domain/entities/user_question.dart';

class ChallengeArguments {
  final User user;
  final UserQuestion challenge;

  ChallengeArguments(this.user, this.challenge);
}
