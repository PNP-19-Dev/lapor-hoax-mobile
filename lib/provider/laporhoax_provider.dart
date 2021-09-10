import 'package:flutter/cupertino.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/data/model/user.dart';
import 'package:laporhoax/util/result_state.dart';

class LaporhoaxProvider extends ChangeNotifier {
  final LaporhoaxApi apiservice;

  LaporhoaxProvider({required this.apiservice});

  late User _userResult;
  late ResultState _state;

  User get userResult => _userResult;

  ResultState get state => _state;

  Future<dynamic> login(String username, String password) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await apiservice.postLogin(username, password);
      _state = ResultState.HasData;
      notifyListeners();
      return result;
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
    }
  }

  Future<dynamic> register() async {
    _state = ResultState.Loading;
    notifyListeners();
  }
}
