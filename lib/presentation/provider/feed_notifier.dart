import 'package:flutter/material.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/usecases/get_feeds.dart';

class FeedNotifier extends ChangeNotifier {

  List<Feed> _feeds = [];

  List<Feed> get feeds => _feeds;

  RequestState _feedState = RequestState.Empty;
  RequestState get feedState => _feedState;

  String _message = '';

  String get message => _message;

  FeedNotifier({
    required this.getFeeds,
  });

  final GetFeeds getFeeds;

  Future<void> fetchFeeds() async {
    _feedState = RequestState.Loading;
    notifyListeners();

    final result = await getFeeds.execute();

    result.fold((failure) {
      _message = failure.message;
      _feedState = RequestState.Error;
    }, (feedsData) {
      _feeds = feedsData;
      _feedState = RequestState.Loaded;
      notifyListeners();
    });
  }
}
