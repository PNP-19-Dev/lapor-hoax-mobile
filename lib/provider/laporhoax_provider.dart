import 'package:flutter/cupertino.dart';
import 'package:laporhoax/data/api/laporhoax_api.dart';
import 'package:laporhoax/data/model/feed.dart';
import 'package:laporhoax/util/result_state.dart';

class LaporhoaxProvider extends ChangeNotifier {
  final LaporhoaxApi apiservice;

  LaporhoaxProvider({required this.apiservice}) {
    _getFeed();
  }

  String _message = '';

  late List<Feed> _feed;
  late ResultState _state;

  List<Feed> get feed => _feed;

  String get message => _message;

  ResultState get state => _state;

  Future<dynamic> _getFeed() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final feed = await apiservice.getFeed();

      if (feed.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _feed = feed;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error ---> $e';
    }
  }
}
