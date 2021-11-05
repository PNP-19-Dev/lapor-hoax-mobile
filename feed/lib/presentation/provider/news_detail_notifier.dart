import 'package:core/domain/entities/feed.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';

import '../../../domain/usecases/get_feed_detail.dart';
import '../../../domain/usecases/get_feed_save_status.dart';
import '../../../domain/usecases/remove_feed.dart';
import '../../../domain/usecases/save_feed.dart';

class NewsDetailNotifier extends ChangeNotifier {
  static const feedSavedMessage = 'Berita Telah Disimpan';
  static const feedRemovedMessage = 'Berita Telah Dihapus';

  NewsDetailNotifier({
    required this.getFeedDetail,
    required this.saveFeed,
    required this.removeFeed,
    required this.getFeedSaveStatus,
  });

  final GetFeedDetail getFeedDetail;
  final SaveFeed saveFeed;
  final RemoveFeed removeFeed;
  final GetFeedSaveStatus getFeedSaveStatus;

  late Feed _feed;
  Feed get feed => _feed;

  RequestState _feedState = RequestState.Empty;
  RequestState get feedState => _feedState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoSavedFeed = false;
  bool get isAddedtoSavedFeed => _isAddedtoSavedFeed;

  Future<void> fetchFeedDetail(int id) async {
    _feedState = RequestState.Loading;
    notifyListeners();

    final detailResult = await getFeedDetail.execute(id);
    detailResult.fold(
      (failure) {
        _feedState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (feed) {
        _feed = feed;
        _feedState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  String _saveMessage = '';

  String get saveMessage => _saveMessage;

  Future<void> storeFeed(Feed feed) async {
    final result = await saveFeed.execute(feed);

    await result.fold((failure) async {
      _saveMessage = failure.message;
    }, (successMessage) async {
      _saveMessage = feedSavedMessage;
    });

    await loadFeedStatus(feed.id);
  }

  Future<void> deleteFeed(Feed feed) async {
    final result = await removeFeed.execute(feed);

    await result.fold((failure) async {
      _saveMessage = failure.message;
    }, (successMessage) async {
      _saveMessage = feedRemovedMessage;
    });

    await loadFeedStatus(feed.id);
  }

  Future<void> loadFeedStatus(int id) async {
    final result = await getFeedSaveStatus.execute(id);
    _isAddedtoSavedFeed = result;
    notifyListeners();
  }
}
