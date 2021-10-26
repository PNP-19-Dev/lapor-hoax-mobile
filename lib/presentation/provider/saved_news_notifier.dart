import 'package:flutter/material.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/usecases/get_saved_feeds.dart';

class SavedNewsNotifier extends ChangeNotifier {
  var _saveListFeeds = <Feed>[];

  List<Feed> get saveListFeeds => _saveListFeeds;

  var _feedListState = RequestState.Empty;

  RequestState get feedListState => _feedListState;

  String _message = '';

  String get message => _message;

  SavedNewsNotifier({required this.getSavedFeeds});

  final GetSavedFeeds getSavedFeeds;

  Future<void> fetchSavedFeeds() async {
    _feedListState = RequestState.Loading;
    notifyListeners();

    final result = await getSavedFeeds.execute();
    result.fold(
      (failure) {
        _feedListState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (feedData) {
        _feedListState = RequestState.Loaded;
        _saveListFeeds = feedData;

        if (feedData.isEmpty) {
          _feedListState = RequestState.Empty;
          _message = "Empty Data";
          notifyListeners();
        }

        notifyListeners();
      },
    );
  }
}
