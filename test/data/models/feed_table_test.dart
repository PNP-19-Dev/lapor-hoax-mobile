/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.01
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/feed_table.dart';
import 'package:laporhoax/domain/entities/feed.dart';

void main() {
  final tFeedTable = FeedTable(
    id: 1,
    title: "title",
    thumbnail: "thumbnail",
    date: "date",
  );

  final tFeed = Feed(
    id: 1,
    title: "title",
    content: null,
    thumbnail: "thumbnail",
    date: "date",
    view: null,
    author: null,
  );

  final feedMap = {
    'id': 1,
    'title': 'title',
    'thumbnail': 'thumbnail',
    'date': 'date',
  };

  group('Feed Table', () {
    test('should be a subclass of FeedTable from Entity', () async {
      final result = FeedTable.fromEntity(tFeed);
      expect(result, tFeedTable);
    });

    test('should be a subclass of FeedTable from Map', () async {
      final result = FeedTable.fromMap(feedMap);
      expect(result, tFeedTable);
    });

    test('should be a valid JSON', () async {
      final result = tFeedTable.toJson();
      expect(result, feedMap);
    });

    test('should be a valid Feed', () async {
      final result = tFeedTable.toEntity();
      expect(result, tFeed);
    });
  });
}
