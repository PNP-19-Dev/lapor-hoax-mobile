import 'package:laporhoax/data/models/challenge.dart';
import 'package:laporhoax/domain/entities/User.dart';

class ChallengeArguments {
  final User user;
  final Challenge challenge;

  ChallengeArguments(this.user, this.challenge);
}
