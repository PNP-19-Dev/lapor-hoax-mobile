import 'package:flutter/cupertino.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/data/models/register_model.dart';
import 'package:laporhoax/data/models/token_id.dart';
import 'package:laporhoax/data/models/user_response.dart';
import 'package:laporhoax/data/models/user_token.dart';
import 'package:laporhoax/domain/entities/question.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/domain/entities/user_question.dart';
import 'package:laporhoax/domain/usecases/get_password_reset.dart';
import 'package:laporhoax/domain/usecases/get_questions.dart';
import 'package:laporhoax/domain/usecases/get_session_data.dart';
import 'package:laporhoax/domain/usecases/get_session_status.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/get_user_challenge.dart';
import 'package:laporhoax/domain/usecases/post_change_password.dart';
import 'package:laporhoax/domain/usecases/post_fcm_token.dart';
import 'package:laporhoax/domain/usecases/post_login.dart';
import 'package:laporhoax/domain/usecases/post_register.dart';
import 'package:laporhoax/domain/usecases/post_user_challenge.dart';
import 'package:laporhoax/domain/usecases/remove_session_data.dart';
import 'package:laporhoax/domain/usecases/save_session_data.dart';
import 'package:laporhoax/domain/usecases/update_session_data.dart';

class UserNotifier extends ChangeNotifier {
  final GetUser getUser;
  final GetQuestions getQuestions;
  final GetPasswordReset getPasswordReset;
  final GetSessionData getSessionData;
  final PostLogin postLogin;
  final PostRegister postRegister;
  final PostFCMToken postFCMToken;
  final PostChangePassword postChangePassword;
  final PostUserChallenge postUserChallenge;
  final RemoveSessionData removeSessionData;
  final SaveSessionData saveSessionData;
  final UpdateSessionData updateSessionData;
  final GetSessionStatus getSessionStatus;
  final GetUserChallenge getUserChallenge;

  UserNotifier(
      {required this.getUser,
      required this.getQuestions,
      required this.getPasswordReset,
      required this.getSessionData,
      required this.postLogin,
      required this.postRegister,
      required this.postFCMToken,
      required this.postChangePassword,
      required this.postUserChallenge,
      required this.saveSessionData,
      required this.removeSessionData,
      required this.updateSessionData,
      required this.getSessionStatus,
      required this.getUserChallenge});

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

  late TokenId _tokenId;

  TokenId get tokenId => _tokenId;

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
        var token = userToken.token;
        _tokenId = TokenId(token: token!, id: user.id.toString());

        var data = SessionData(
          username: user.username,
          email: user.email,
          userid: user.id,
          token: userToken.token!,
          expiry: userToken.expiry!,
        );

        saveSessionData.execute(data);
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
      _loginState = RequestState.Error;
    }, (userResponse) {
      _userResponse = userResponse;
      _loginState = RequestState.Loaded;
      notifyListeners();
    });
  }

  Map<int, String> _questionMap = {};

  Map<int, String> get questionMap => _questionMap;

  List<Question> _questions = [];

  List<Question> get question => _questions;

  RequestState _questionState = RequestState.Empty;

  RequestState get questionState => _questionState;

  String _questionMessage = '';

  String get questionMessage => _questionMessage;

  Future<void> fetchQuestions() async {
    _questionState = RequestState.Loading;
    notifyListeners();

    final result = await getQuestions.execute();

    result.fold((failure) {
      _questionMessage = failure.message;
      _questionState = RequestState.Error;
    }, (questions) {
      _questions = questions;
      _questionMap = _questionToMap();
      _questionState = RequestState.Loaded;
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

  late UserQuestion _userQuestion;

  UserQuestion get userQuestion => _userQuestion;

  String _userQuestionMessage = '';

  String get userQuestionMessage => _userQuestionMessage;

  RequestState _userQuestionState = RequestState.Empty;

  RequestState get userQuestionState => _userQuestionState;

  Future<void> getUserSecurityQuestion(String id) async {
    _userQuestionState = RequestState.Loading;
    notifyListeners();

    final result = await getUserChallenge.execute(id);

    result.fold((failure) {
      _userQuestionMessage = failure.message;
      _userQuestionState = RequestState.Error;
    }, (userQuestion) {
      _userQuestion = userQuestion;
      _userQuestionState = RequestState.Loaded;
      notifyListeners();
    });
  }

  Map<int, String> _questionToMap() {
    Map<int, String> map = {};
    _questions.forEach((element) {
      map[element.id] = '${element.question}';
    });
    return map;
  }
}
