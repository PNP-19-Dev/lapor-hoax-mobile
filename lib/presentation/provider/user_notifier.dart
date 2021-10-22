import 'package:flutter/cupertino.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/domain/usecases/get_password_reset.dart';
import 'package:laporhoax/domain/usecases/get_session_data.dart';
import 'package:laporhoax/domain/usecases/get_session_status.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/post_change_password.dart';
import 'package:laporhoax/domain/usecases/post_fcm_token.dart';
import 'package:laporhoax/domain/usecases/post_user_challenge.dart';
import 'package:laporhoax/domain/usecases/remove_session_data.dart';
import 'package:laporhoax/domain/usecases/save_session_data.dart';
import 'package:laporhoax/domain/usecases/update_session_data.dart';

class UserNotifier extends ChangeNotifier {
  final GetUser getUser;

  final GetPasswordReset getPasswordReset;
  final GetSessionData getSessionData;

  final PostFCMToken postFCMToken;
  final PostChangePassword postChangePassword;
  final PostUserChallenge postUserChallenge;
  final RemoveSessionData removeSessionData;
  final SaveSessionData saveSessionData;
  final UpdateSessionData updateSessionData;
  final GetSessionStatus getSessionStatus;

  UserNotifier({
    required this.getUser,
    required this.getPasswordReset,
    required this.getSessionData,
    required this.postFCMToken,
    required this.postChangePassword,
    required this.postUserChallenge,
    required this.saveSessionData,
    required this.removeSessionData,
    required this.updateSessionData,
    required this.getSessionStatus,
  });

  RequestState _sessionState = RequestState.Empty;

  RequestState get sessionState => _sessionState;

  RequestState _userState = RequestState.Empty;

  RequestState get userState => _userState;

  String _sessionMessage = '';

  String get sessionMessage => _sessionMessage;

  late SessionData _sessionData;

  SessionData get sessionData => _sessionData;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> isLogin() async {
    final result = await getSessionStatus.execute();
    _isLoggedIn = result;
    notifyListeners();
  }

  Future<void> getSession() async {
    final result = await getSessionData.execute();
    result.fold((failure) {
      _sessionMessage = failure.message;
    }, (sessionData) {
      _sessionData = sessionData!;
      notifyListeners();
    });
  }

  Future<void> logout(SessionData data) async {
    final result = await removeSessionData.execute(data);

    result.fold((failure) {
      _sessionMessage = failure.message;
    }, (session) {
      _sessionMessage = session;
      notifyListeners();
    });
  }

  RequestState _fcmState = RequestState.Empty;

  RequestState get fcmState => _fcmState;

  String _fcmMessage = '';

  String get fcmMessage => _fcmMessage;

  Future<void> postToken(String userid, String token) async {
    _fcmState = RequestState.Loading;
    notifyListeners();

    final result = await postFCMToken.execute(userid, token);

    result.fold((failure) {
      _fcmMessage = failure.message;
      _fcmState = RequestState.Error;
    }, (message) {
      _fcmMessage = message;
      _fcmState = RequestState.Loaded;
      notifyListeners();
    });
  }

  late User _user;

  User get user => _user;

  String _userMessage = '';

  String get userMessage => _userMessage;

  Future<void> getUserData(String email) async {
    _userState = RequestState.Loading;
    notifyListeners();

    final result = await getUser.execute(email);

    result.fold((failure) {
      _userMessage = failure.message;
      _userState = RequestState.Error;
    }, (user) {
      _user = user;
      _userState = RequestState.Loaded;
      notifyListeners();
    });
  }
}
