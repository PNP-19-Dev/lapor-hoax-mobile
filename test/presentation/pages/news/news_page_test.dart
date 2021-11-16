/*
 * Created by andii on 16/11/21 09.46
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 09.35
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/news/news_page.dart';
import 'package:laporhoax/presentation/provider/feed_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockFeedCubit bloc;

  setUp(() {
    bloc = MockFeedCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<FeedCubit>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  /*testWidgets('Page should display blank when initialization',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(FeedInitial());
        when(bloc.stream).thenAnswer((_) => Stream.value(FeedInitial()));

        await tester.pumpWidget(_makeTestableWidget(NewsPage()));

        final finder = find.byKey(Key('news_page_init'));
        expect(finder, findsOneWidget);
      });*/

  testWidgets('Page should display progress bar when loading',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(FeedLoading());
        when(bloc.stream).thenAnswer((_) => const Stream.empty());

        final finder = find.byKey(Key('loading_widget'));

        await tester.pumpWidget(_makeTestableWidget(NewsPage()));

        expect(finder, findsOneWidget);
      });

  testWidgets('Page should display items when data success fetched and tap the card item',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(FeedHasData([testFeed]));
        when(bloc.stream).thenAnswer((_) => Stream.value(FeedHasData([testFeed])));

        final finder = find.byKey(Key('home_feed_items'));
        final card = find.byKey(Key('news_card'));
        await tester.pumpWidget(_makeTestableWidget(NewsPage()));

        expect(finder, findsOneWidget);
        expect(card, findsOneWidget);

        await tester.tap(card);
        await tester.pump();
      });

  testWidgets('Page should display items when data success fetched and tap tutorial card',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(FeedHasData([testFeed]));
        when(bloc.stream).thenAnswer((_) => Stream.value(FeedHasData([testFeed])));

        final finder = find.byKey(Key('how_to_use'));

        await tester.pumpWidget(_makeTestableWidget(NewsPage()));

        expect(finder, findsOneWidget);

        await tester.tap(finder);
        await tester.pump();
      });

  testWidgets('Page should display items when data success fetched and tap lapor yuk button',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(FeedHasData([testFeed]));
        when(bloc.stream).thenAnswer((_) => Stream.value(FeedHasData([testFeed])));


        await tester.pumpWidget(_makeTestableWidget(NewsPage()));

        final finder = find.byType(ElevatedButton);
        expect(finder, findsOneWidget);

        final text = find.text('Lapor yuk!');
        expect(text, findsOneWidget);

        await tester.tap(finder);
        await tester.pump();
      });

  testWidgets('Page should display error when data failed fetched',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(FeedError('Error'));
        when(bloc.stream).thenAnswer((_) => Stream.value(FeedError('Error')));

        final finder = find.byKey(Key('home_feed_error'));

        await tester.pumpWidget(_makeTestableWidget(NewsPage()));

        expect(finder, findsOneWidget);
      });
}
