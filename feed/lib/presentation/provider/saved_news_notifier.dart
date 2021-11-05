import 'package:core/domain/entities/feed.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';

import '../../../domain/usecases/get_saved_feeds.dart';

class SavedNewsNotifier extends ChangeNotifier {
  var _saveListFeeds = <Feed>[];

  List<Feed> get saveListFeeds => _saveListFeeds;

  var _feedListState = RequestState.empty;

  RequestState get feedListState => _feedListState;

  String _message = '';

  String get message => _message;

  SavedNewsNotifier({required this.getSavedFeeds});

  final GetSavedFeeds getSavedFeeds;

  Future<void> fetchSavedFeeds() async {
    _feedListState = RequestState.loading;
    notifyListeners();

    final result = await getSavedFeeds.execute();
    result.fold(
      (failure) {
        _feedListState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (feedData) {
        _feedListState = RequestState.loaded;
        _saveListFeeds = feedData;

        if (feedData.isEmpty) {
          _feedListState = RequestState.empty;
          _message = "Empty Data";
          notifyListeners();
        }

        notifyListeners();
      },
    );
  }
}
