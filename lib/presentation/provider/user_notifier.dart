import 'package:flutter/cupertino.dart';
import 'package:laporhoax/domain/usecases/get_password_reset.dart';
import 'package:laporhoax/domain/usecases/get_questions.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/post_change_password.dart';
import 'package:laporhoax/domain/usecases/post_fcm_token.dart';
import 'package:laporhoax/domain/usecases/post_login.dart';
import 'package:laporhoax/domain/usecases/post_register.dart';
import 'package:laporhoax/domain/usecases/post_user_challenge.dart';

class UserNotifier extends ChangeNotifier {
  final GetUser getUser;
  final GetQuestions getQuestions;
  final GetPasswordReset getPasswordReset;
  final PostLogin postLogin;
  final PostRegister postRegister;
  final PostFCMToken postFCMToken;
  final PostChangePassword postChangePassword;
  final PostUserChallenge postUserChallenge;

  UserNotifier(
      {required this.getUser,
      required this.getQuestions,
      required this.getPasswordReset,
      required this.postLogin,
      required this.postRegister,
      required this.postFCMToken,
      required this.postChangePassword,
      required this.postUserChallenge});
}
