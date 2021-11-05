import 'package:core/domain/entities/feed.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';

import '../../domain/usecases/get_feeds.dart';

class FeedNotifier extends ChangeNotifier {

  List<Feed> _feeds = [];

  List<Feed> get feeds => _feeds;

  RequestState _feedState = RequestState.empty;
  RequestState get feedState => _feedState;

  String _message = '';

  String get message => _message;

  FeedNotifier({
    required this.getFeeds,
  });

  final GetFeeds getFeeds;

  Future<void> fetchFeeds() async {
    _feedState = RequestState.loading;
    notifyListeners();

    final result = await getFeeds.execute();

    result.fold((failure) {
      _message = failure.message;
      _feedState = RequestState.error;
    }, (feedsData) {
      _feeds = feedsData;
      _feedState = RequestState.loaded;
      notifyListeners();
    });
  }
}
