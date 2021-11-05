import 'package:core/domain/entities/feed.dart';
import 'package:dartz/dartz.dart';
import 'package:feed/domain/usecases/get_feeds.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/feed_test_helpers.mocks.dart';

void main() {
  late GetFeeds usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetFeeds(mockRepository);
  });

  final tFeed = Feed(
    id: 26,
    title: "Libur Maulid Nabi 2021 Digeser: Tanggal dan Alasannya",
    content: "content",
    thumbnail:
    "https://django-lapor-hoax.s3.amazonaws.com/feeds/1.jpeg?AWSAccessKeyId=AKIAXSGIDQGEESDBZHGJ&Signature=yXthBiGVfwxxC%2Flai%2FvL0PZAMz4%3D&Expires=1634826461",
    date: "2021-10-13T01:34:58.831621+07:00",
    view: 0,
    author: 1,
  );
  final tFeedList = [tFeed];

  group('GetFeeds Test', () {
    group('execute', () {
      test('should get list of feeds when execute function is called',
          () async {
        // arrange
        when(mockRepository.getFeeds())
            .thenAnswer((_) async => Right(tFeedList));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(tFeedList));
      });
    });
  });
}
