import 'package:flutter/material.dart';
import 'package:laporhoax/common/state_enum.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/usecases/get_feed_save_status.dart';
import 'package:laporhoax/domain/usecases/get_feeds.dart';
import 'package:laporhoax/domain/usecases/get_saved_feeds.dart';
import 'package:laporhoax/domain/usecases/remove_feed.dart';
import 'package:laporhoax/domain/usecases/save_feed.dart';

class FeedNotifier extends ChangeNotifier {
  static const feedSavedMessage = 'Berita Telah Disimpan';
  static const feedRemovedMessage = 'Berita Telah Dihapus';

  List<Feed> _feeds = [];

  List<Feed> get feeds => _feeds;

  RequestState _feedState = RequestState.Empty;
  RequestState get feedState => _feedState;

  bool _isFeedSaved = false;

  bool get isFeedSaved => _isFeedSaved;

  String _message = '';

  String get message => _message;

  FeedNotifier({
    required this.getFeeds,
    required this.saveFeed,
    required this.removeFeed,
    required this.getFeedSaveStatus,
    required this.getSavedFeeds,
  });

  final GetFeeds getFeeds;
  final SaveFeed saveFeed;
  final RemoveFeed removeFeed;
  final GetFeedSaveStatus getFeedSaveStatus;
  final GetSavedFeeds getSavedFeeds;

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

  String _savedFeedMessage = '';

  String get savedFeedMessage => _savedFeedMessage;

  Future<void> saveFeedItem(Feed feed) async {
    final result = await saveFeed.execute(feed);

    await result.fold((failure) async {
      _savedFeedMessage = failure.message;
    }, (successMessage) async {
      _savedFeedMessage = successMessage;
    });

    await loadSavedFeedStatus(feed.id);
  }

  Future<void> removeFeedItem(Feed feed) async {
    final result = await removeFeed.execute(feed);

    await result.fold((failure) async {
      _savedFeedMessage = failure.message;
    }, (successMessage) async {
      _savedFeedMessage = successMessage;
    });

    await loadSavedFeedStatus(feed.id);
  }

  Future<void> loadSavedFeedStatus(int id) async {
    final result = await getFeedSaveStatus.execute(id);
    _isFeedSaved = result;
    notifyListeners();
  }
}
