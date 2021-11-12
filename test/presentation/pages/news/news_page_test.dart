import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/news/news_page.dart';
import 'package:laporhoax/presentation/provider/feed_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'news_page_test.mocks.dart';

@GenerateMocks([FeedCubit])
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

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(FeedLoading());
    when(bloc.stream).thenAnswer((_) => const Stream.empty());

    final finder = find.byKey(Key('loading_widget'));

    await tester.pumpWidget(_makeTestableWidget(NewsPage()));

    expect(finder, findsOneWidget);
  });

  testWidgets('Page should display items when data success fetched',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(FeedHasData([testFeed]));
    when(bloc.stream).thenAnswer((_) => Stream.value(FeedHasData([testFeed])));

    final finder = find.byKey(Key('home_feed_items'));

    await tester.pumpWidget(_makeTestableWidget(NewsPage()));

    expect(finder, findsOneWidget);
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
