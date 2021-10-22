import 'package:flutter/cupertino.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/data/models/user_token.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/post_login.dart';
import 'package:laporhoax/domain/usecases/save_session_data.dart';

class LoginNotifier extends ChangeNotifier {
  final GetUser getUser;
  final PostLogin postLogin;
  final SaveSessionData saveSessionData;

  LoginNotifier(
      {required this.getUser,
      required this.postLogin,
      required this.saveSessionData});

  late UserToken _userToken;

  UserToken get userToken => _userToken;

  RequestState _userState = RequestState.Empty;

  RequestState get userState => _userState;

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
}
