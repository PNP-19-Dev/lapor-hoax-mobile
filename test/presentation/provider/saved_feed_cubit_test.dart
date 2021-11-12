import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_saved_feeds.dart';
import 'package:laporhoax/presentation/provider/saved_feed_cubit.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'saved_feed_cubit_test.mocks.dart';

@GenerateMocks([
  GetSavedFeeds,
])
void main() {
  late SavedFeedCubit bloc;
  late MockGetSavedFeeds _getFeeds;

  setUp(() {
    _getFeeds = MockGetSavedFeeds();
    bloc = SavedFeedCubit(_getFeeds);
  });

  blocTest<SavedFeedCubit, SavedFeedState>(
    'should get data from usecases',
    build: () {
      when(_getFeeds.execute()).thenAnswer((_) async => Right([testFeed]));
      return bloc;
    },
    act: (cubit) => cubit.fetchSavedFeeds(),
    verify: (cubit) => cubit.fetchSavedFeeds(),
    expect: () => [
      SavedFeedLoading(),
      SavedFeedHasData([testFeed]),
    ],
  );

  blocTest<SavedFeedCubit, SavedFeedState>(
    'should return empty data from usecases when data is empty',
    build: () {
      when(_getFeeds.execute()).thenAnswer((_) async => Right([]));
      return bloc;
    },
    act: (cubit) => cubit.fetchSavedFeeds(),
    verify: (cubit) => cubit.fetchSavedFeeds(),
    expect: () => [
      SavedFeedLoading(),
      SavedFeedEmpty('Kamu belum menyimpan berita apapun!'),
    ],
  );

  blocTest<SavedFeedCubit, SavedFeedState>(
    'should return error when data is unsuccessful',
    build: () {
      when(_getFeeds.execute())
          .thenAnswer((_) async => Left(ServerFailure('Failure')));
      return bloc;
    },
    act: (cubit) => cubit.fetchSavedFeeds(),
    verify: (cubit) => cubit.fetchSavedFeeds(),
    expect: () => [
      SavedFeedLoading(),
      SavedFeedError('Failure'),
    ],
  );
}
