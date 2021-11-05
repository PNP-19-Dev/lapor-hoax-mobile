import 'package:core/data/models/feed_model.dart';
import 'package:core/domain/entities/feed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tFeedModel = FeedModel(
      id: 1,
      title: "title",
      content: "content",
      thumbnail: "thumbnail",
      date: "date",
      view: 0,
      author: 1);

  final tFeed = Feed(
      id: 1,
      title: "title",
      content: "content",
      thumbnail: "thumbnail",
      date: "date",
      view: 0,
      author: 1);

  test('should be a subclass of Feed entity', () async {
    final result = tFeedModel.toEntity();
    expect(result, tFeed);
  });
}
