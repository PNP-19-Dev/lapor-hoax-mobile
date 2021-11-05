import 'package:core/domain/entities/feed.dart';
import 'package:dartz/dartz.dart';
import 'package:feed/domain/usecases/get_feed_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/feed_test_helpers.mocks.dart';

void main() {
  late GetFeedDetail usecase;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    usecase = GetFeedDetail(mockRepository);
  });

  const tId = 1;
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

  group('GetFeedDetail Test', () {
    group('execute', () {
      test('should get feed detail from the repository', () async {
        // arrange
        when(mockRepository.getFeedDetail(tId))
            .thenAnswer((_) async => Right(tFeed));
        // act
        final result = await usecase.execute(tId);
        // assert
        expect(result, Right(tFeed));
      });
    });
  });
}
