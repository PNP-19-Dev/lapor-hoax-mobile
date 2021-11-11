import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/usecases/get_user.dart';
import 'package:laporhoax/domain/usecases/post_login.dart';
import 'package:laporhoax/domain/usecases/save_session_data.dart';

class LoginCubit extends Cubit<LoginState> {
  final PostLogin _login;
  final GetUser _user;
  final SaveSessionData _save;

  LoginCubit(this._login, this._user, this._save) : super(LoginInitial());

  /*TODO UPDATE THE FCM TOKEN
  final data = Provider.of<UserNotifier>(
          context,
          listen: false)
      .user;
  String? token = await FirebaseMessaging
      .instance
      .getToken();
  if (token != null) {
    await Provider.of<UserNotifier>(context,
            listen: false)
        .putToken(data!.id, token);
  }*/

  Future<void> login(String username, String password) async {
    emit(Login());
    final result = await _login.execute(username, password);
    final user = await _user.execute(username);
    result.fold(
      (failure) => emit(LoginFailure(failure.message)),
      (token) {
        user.fold(
          (failure) => LoginFailure(failure.message),
          (user) {
            _save.execute(SessionData(
              email: user.email,
              userid: user.id,
              token: token.token!,
              expiry: token.expiry!,
              username: user.username,
            ));
            emit(LoginSuccess());
          },
        );
      },
    );
  }
}

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class Login extends LoginState {}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);

  @override
  List<Object> get props => [message];
}

class LoginSuccess extends LoginState {}

