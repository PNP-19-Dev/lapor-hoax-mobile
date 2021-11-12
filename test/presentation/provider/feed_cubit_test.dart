import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_feeds.dart';
import 'package:laporhoax/presentation/provider/feed_cubit.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'feed_cubit_test.mocks.dart';

@GenerateMocks([
  GetFeeds,
])
void main() {
  late FeedCubit bloc;
  late MockGetFeeds _feeds;

  setUp(() {
    _feeds = MockGetFeeds();
    bloc = FeedCubit(_feeds);
  });

  blocTest<FeedCubit, FeedState>(
    'Should fetch data when usecases is called',
    build: () {
      when(_feeds.execute()).thenAnswer((_) async => Right([testFeed]));
      return bloc;
    },
    act: (bloc) => bloc.fetchFeeds(),
    expect: () => <FeedState>[
      FeedLoading(),
      FeedHasData([testFeed]),
    ],
  );

  blocTest<FeedCubit, FeedState>(
    'Should return error callback when data is unsuccessful',
    build: () {
      when(_feeds.execute())
          .thenAnswer((_) async => Left(ServerFailure('Failure')));
      return bloc;
    },
    act: (bloc) => bloc.fetchFeeds(),
    expect: () => <FeedState>[
      FeedLoading(),
      FeedError('Failure'),
    ],
  );
}
