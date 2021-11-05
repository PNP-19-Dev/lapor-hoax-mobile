import 'package:flutter/cupertino.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/data/models/register_model.dart';
import 'package:laporhoax/data/models/user_response.dart';
import 'package:laporhoax/data/models/user_token.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/domain/entities/user_question.dart';
import 'package:laporhoax/domain/usecases/get_password_reset.dart';
import 'package:laporhoax/domain/usecases/get_session_data.dart';
import 'package:laporhoax/domain/usecases/get_session_status.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/post_change_password.dart';
import 'package:laporhoax/domain/usecases/post_fcm_token.dart';
import 'package:laporhoax/domain/usecases/post_login.dart';
import 'package:laporhoax/domain/usecases/post_register.dart';
import 'package:laporhoax/domain/usecases/post_user_challenge.dart';
import 'package:laporhoax/domain/usecases/put_fcm_token.dart';
import 'package:laporhoax/domain/usecases/remove_session_data.dart';
import 'package:laporhoax/domain/usecases/save_session_data.dart';

class UserNotifier extends ChangeNotifier {
  static const String messageLogin = 'Anda Login';
  static const String messageLogout = 'Anda Logout';
  static const String messageRegister = 'Register Berhasil!';
  static const String messageQuestion = 'Pertanyaan Keamanan Telah Diperbarui!';

  final GetUser getUser;
  final PostLogin postLogin;
  final PostRegister postRegister;
  final GetPasswordReset getPasswordReset;
  final GetSessionData getSessionData;

  final PostFCMToken postFCMToken;
  final PutFCMToken putFCMToken;
  final PostChangePassword postChangePassword;
  final PostUserChallenge postUserChallenge;
  final RemoveSessionData removeSessionData;
  final SaveSessionData saveSessionData;
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
    required this.getSessionStatus,
    required this.postLogin,
    required this.postRegister,
    required this.putFCMToken,
  });

  RequestState _sessionState = RequestState.Empty;

  RequestState get sessionState => _sessionState;

  RequestState _userState = RequestState.Empty;

  RequestState get userState => _userState;

  String _sessionMessage = '';

  String get sessionMessage => _sessionMessage;

  SessionData? _sessionData;

  SessionData? get sessionData => _sessionData;

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
      notifyListeners();
    }, (sessionData) {
      _sessionData = sessionData;
      notifyListeners();
    });
  }

  Future<void> logout(SessionData data) async {
    final result = await removeSessionData.execute(data);

    result.fold((failure) {
      _sessionMessage = failure.message;
    }, (session) {
      _sessionMessage = messageLogout;
      notifyListeners();
    });
  }

  RequestState _fcmState = RequestState.Empty;

  RequestState get fcmState => _fcmState;

  String _fcmMessage = '';

  String get fcmMessage => _fcmMessage;

  Future<void> postToken(int userid, String token) async {
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

  Future<void> putToken(int userid, String token) async {
    _fcmState = RequestState.Loading;
    notifyListeners();

    final result = await putFCMToken.execute(userid, token);

    result.fold((failure) {
      _fcmMessage = failure.message;
      _fcmState = RequestState.Error;
      notifyListeners();
    }, (message) {
      _fcmMessage = message;
      _fcmState = RequestState.Loaded;
      notifyListeners();
    });
  }


  User? _user;

  User? get user => _user;

  String _userMessage = '';

  String get userMessage => _userMessage;

  Future<void> getUserData(String email) async {
    _userState = RequestState.Loading;
    notifyListeners();

    final result = await getUser.execute(email);

    result.fold((failure) {
      _userState = RequestState.Error;
      _userMessage = failure.message;
      print('failuremessage ${failure.message}');
    }, (user) {
      _userState = RequestState.Loaded;
      _user = user;
      notifyListeners();
    });
  }

  late UserToken _userToken;

  UserToken get userToken => _userToken;

  RequestState _loginState = RequestState.Empty;

  RequestState get loginState => _loginState;

  String _loginMessage = '';

  String get loginMessage => _loginMessage;

  Future<void> login(String username, String password) async {
    _loginState = RequestState.Loading;
    notifyListeners();

    final result = await postLogin.execute(username, password);
    final user = await getUser.execute(username);

    result.fold((failure) {
      _loginMessage = failure.message;
      _loginState = RequestState.Error;
    }, (userToken) {
      _userToken = userToken;
      user.fold((failure) {
        _userState = RequestState.Error;
      }, (user) {
        var data = SessionData(
          email: user.email,
          userid: user.id,
          token: userToken.token!,
          expiry: userToken.expiry!,
          username: user.username,
        );
        saveSessionData.execute(data);
        _loginMessage = messageLogin;
      });
      _loginState = RequestState.Success;
      notifyListeners();
    });
  }

  late UserResponse _userResponse;

  UserResponse get userResponse => _userResponse;

  RequestState _registerState = RequestState.Empty;

  RequestState get registerState => _registerState;

  String _registerMessage = '';

  String get registerMessage => _registerMessage;

  Future<void> register(RegisterModel user) async {
    _registerState = RequestState.Loading;
    notifyListeners();

    final result = await postRegister.execute(user);

    result.fold((failure) {
      _registerMessage = failure.message;
      _registerState = RequestState.Error;
    }, (userResponse) {
      _userResponse = userResponse;
      _registerMessage = messageRegister;
      _registerState = RequestState.Loaded;
      notifyListeners();
    });
  }

  static const String messageReset = 'RESETED';
  String _resetMessage = '';

  String get resetMessage => _resetMessage;

  Future<void> reset(String email) async {
    final result = await getPasswordReset.execute(email);

    result.fold((failure) {
      _resetMessage = failure.message;
    }, (response) {
      _resetMessage = messageReset;
    });
    notifyListeners();
  }

  String _challengeMessage = '';

  String get challengeMessage => _challengeMessage;

  RequestState _challengeState = RequestState.Empty;

  RequestState get challengeState => _challengeState;

  Future<void> postChallenge(UserQuestion challenge) async {
    final result = await postUserChallenge.execute(challenge);

    result.fold(
      (failure) {
        _challengeMessage = failure.message;
      },
      (message) {
        _challengeState = RequestState.Success;
        _challengeMessage = messageQuestion;
      },
    );
    notifyListeners();
  }

  String _passwordChangeMessage = '';

  String get passwordChangeMessage => _passwordChangeMessage;
  static const String messageChangePassword = 'password telah diganti';

  Future<void> changePassword(
      String oldPass, String newPass, String token) async {
    final result = await postChangePassword.execute(oldPass, newPass, token);

    result.fold(
      (failure) {
        _passwordChangeMessage = failure.message;
      },
      (message) {
        _passwordChangeMessage = messageChangePassword;
      },
    );
    notifyListeners();
  }
}
