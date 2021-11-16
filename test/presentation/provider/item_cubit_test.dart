/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.59
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/datasources/local_data_source.dart';
import 'package:laporhoax/domain/usecases/get_feed_save_status.dart';
import 'package:laporhoax/domain/usecases/remove_feed.dart';
import 'package:laporhoax/domain/usecases/save_feed.dart';
import 'package:laporhoax/presentation/provider/item_cubit.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'item_cubit_test.mocks.dart';

@GenerateMocks([
  GetFeedSaveStatus,
  SaveFeed,
  RemoveFeed,
])
void main() {
  late ItemCubit bloc;
  late MockGetFeedSaveStatus _status;
  late MockSaveFeed _save;
  late MockRemoveFeed _remove;

  setUp(() {
    _status = MockGetFeedSaveStatus();
    _save = MockSaveFeed();
    _remove = MockRemoveFeed();
    bloc = ItemCubit(_status, _save, _remove);
  });

  group('status', () {
    const tId = 1;
    blocTest<ItemCubit, ItemState>(
      'Should return TRUE when item is saved',
      build: () {
        when(_status.execute(tId)).thenAnswer((_) async => true);
        return bloc;
      },
      act: (cubit) => cubit.getStatus(tId),
      verify: (cubit) => cubit.getStatus(tId),
      expect: () => [
        ItemIsSave(),
      ],
    );

    blocTest<ItemCubit, ItemState>(
      'Should return FALSE when item is unSaved',
      build: () {
        when(_status.execute(tId)).thenAnswer((_) async => false);
        return bloc;
      },
      act: (cubit) => cubit.getStatus(tId),
      verify: (cubit) => cubit.getStatus(tId),
      expect: () => [
        ItemUnsaved(),
      ],
    );
  });

  group('Save Feed', () {
    blocTest<ItemCubit, ItemState>(
      'Should return success callback when item is saved',
      build: () {
        when(_save.execute(testFeed))
            .thenAnswer((_) async => Right(LocalDataSource.saveMessage));
        return bloc;
      },
      act: (cubit) => cubit.saveFeed(testFeed),
      verify: (cubit) => cubit.saveFeed(testFeed),
      expect: () => [
        ItemSaved(LocalDataSource.saveMessage),
      ],
    );

    blocTest<ItemCubit, ItemState>(
      "Should return error callback when item can't save",
      build: () {
        when(_save.execute(testFeed))
            .thenAnswer((_) async => Left(DatabaseFailure('Failure')));
        return bloc;
      },
      act: (cubit) => cubit.saveFeed(testFeed),
      verify: (cubit) => cubit.saveFeed(testFeed),
      expect: () => [
        ItemSaveError('Failure'),
      ],
    );
  });

  group('Remove Feed', () {
    blocTest<ItemCubit, ItemState>(
      "Should return success callback when item is removed",
      build: () {
        when(_remove.execute(testFeed))
            .thenAnswer((_) async => Right(LocalDataSource.removeMessage));
        return bloc;
      },
      act: (cubit) => cubit.removeFeed(testFeed),
      verify: (cubit) => cubit.removeFeed(testFeed),
      expect: () => [
        ItemRemoved(LocalDataSource.removeMessage),
      ],
    );

    blocTest<ItemCubit, ItemState>(
      "Should return error callback when item can't deleted",
      build: () {
        when(_remove.execute(testFeed))
            .thenAnswer((_) async => Left(DatabaseFailure('Failure')));
        return bloc;
      },
      act: (cubit) => cubit.removeFeed(testFeed),
      verify: (cubit) => cubit.removeFeed(testFeed),
      expect: () => [
        ItemSaveError('Failure'),
      ],
    );
  });
}
