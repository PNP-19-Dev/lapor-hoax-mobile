/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.59
 */

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/domain/usecases/get_feed_detail.dart';
import 'package:laporhoax/presentation/provider/detail_cubit.dart';
import 'package:laporhoax/utils/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'detail_cubit_test.mocks.dart';

@GenerateMocks([GetFeedDetail])
void main() {
  late DetailCubit bloc;
  late MockGetFeedDetail _detail;

  setUp(() {
    _detail = MockGetFeedDetail();
    bloc = DetailCubit(_detail);
  });

  const id = 1;

  blocTest<DetailCubit, DetailState>(
    'Should fetch detail of feed when usecase is called',
    build: () {
      when(_detail.execute(id)).thenAnswer((_) async => Right(testFeed));
      return bloc;
    },
    act: (cubit) => cubit.fetchDetail(id),
    expect: () => <DetailState>[
      DetailLoading(),
      DetailHasData(testFeed),
    ],
  );

  blocTest<DetailCubit, DetailState>(
    'Should return error callback when usecase is unsuccessful',
    build: () {
      when(_detail.execute(id))
          .thenAnswer((_) async => Left(ServerFailure('Failure')));
      return bloc;
    },
    act: (cubit) => cubit.fetchDetail(id),
    expect: () => <DetailState>[
      DetailLoading(),
      DetailError('Failure'),
    ],
  );
}
