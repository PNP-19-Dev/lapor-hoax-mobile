/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.56
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/feed_model.dart';
import 'package:laporhoax/domain/entities/feed.dart';

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

  final feedMap = {
    'id' : 1,
    'title' : 'title',
    'content' : 'content',
    'thumbnail' : 'thumbnail',
    'date' : 'date',
    'view' : 0,
    'author' : 1,
  };

  group('Feed Model', (){
    test('should be a subclass of Feed entity', () async {
      final result = tFeedModel.toEntity();
      expect(result, tFeed);
    });

    test('should be a valid JSON', () async {
      final result = tFeedModel.toJson();
      expect(result, feedMap);
    });

    test('should be a valid FeedModel', () async {
      final result = FeedModel.fromJson(feedMap);
      expect(result, tFeedModel);
    });
  });
}
