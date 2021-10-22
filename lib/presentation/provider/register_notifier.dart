import 'package:flutter/cupertino.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/data/models/register_model.dart';
import 'package:laporhoax/data/models/user_response.dart';
import 'package:laporhoax/domain/usecases/post_register.dart';

class RegisterNotifier extends ChangeNotifier {
  final PostRegister postRegister;

  RegisterNotifier({required this.postRegister});

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
      _registerState = RequestState.Loaded;
      notifyListeners();
    });
  }
}
