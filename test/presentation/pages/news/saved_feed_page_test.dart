/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.01
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/news/saved_news.dart';
import 'package:laporhoax/presentation/provider/saved_feed_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockSavedFeedCubit bloc;

  setUp(() {
    bloc = MockSavedFeedCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SavedFeedCubit>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(SavedFeedLoading());
        when(bloc.stream).thenAnswer((_) => const Stream.empty());

        await tester.pumpWidget(_makeTestableWidget(SavedNews()));

        final loading = find.byKey(Key('saved_news_loading'));

        expect(loading, findsOneWidget);
      });

  testWidgets('Page should display a list when data fetched',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(SavedFeedHasData([testFeed]));
        when(bloc.stream)
            .thenAnswer((_) => Stream.value(SavedFeedHasData([testFeed])));

        await tester.pumpWidget(_makeTestableWidget(SavedNews()));

        final item = find.byKey(Key('saved_feed_has_data'));

        expect(item, findsOneWidget);
      });

  testWidgets('Page should display an empty error when data empty',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(SavedFeedEmpty('Kosong'));
        when(bloc.stream)
            .thenAnswer((_) => Stream.value(SavedFeedEmpty('Kosong')));

        await tester.pumpWidget(_makeTestableWidget(SavedNews()));

        final item = find.byKey(Key('error_message'));
        expect(item, findsOneWidget);
      });

  testWidgets('Page should display an error when data failed to fetch',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(SavedFeedError('Failure'));
        when(bloc.stream)
            .thenAnswer((_) => Stream.value(SavedFeedError('Failure')));

        await tester.pumpWidget(_makeTestableWidget(SavedNews()));

        final item = find.byKey(Key('error_message'));
        expect(item, findsOneWidget);
      });
}
