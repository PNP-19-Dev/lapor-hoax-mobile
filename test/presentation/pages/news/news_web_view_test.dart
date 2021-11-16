/*
 * Created by andii on 16/11/21 09.46
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 16/11/21 09.19
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/news/news_web_view.dart';
import 'package:laporhoax/presentation/provider/detail_cubit.dart';
import 'package:laporhoax/presentation/provider/item_cubit.dart';
import 'package:mockito/mockito.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockDetailCubit detailBloc;
  late MockItemCubit itemBloc;

  setUp(() {
    detailBloc = MockDetailCubit();
    itemBloc = MockItemCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailCubit>.value(value: detailBloc),
        BlocProvider<ItemCubit>.value(value: itemBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display empty when initialization',
          (WidgetTester tester) async {
        when(detailBloc.state).thenReturn(DetailInitial());
        when(detailBloc.stream).thenAnswer((_) => Stream.empty());

        when(itemBloc.state).thenReturn(ItemUnsaved());
        when(itemBloc.stream).thenAnswer((_) => Stream.value(ItemUnsaved()));

        await tester.pumpWidget(_makeTestableWidget(NewsWebView(id: 1)));

        final empty = find.byKey(Key('empty_news_detail'));
        expect(empty, findsOneWidget);
      });

  testWidgets('Page should display progress bar when loading',
          (WidgetTester tester) async {
        when(detailBloc.state).thenReturn(DetailLoading());
        when(detailBloc.stream).thenAnswer((_) => const Stream.empty());

        when(itemBloc.state).thenReturn(ItemUnsaved());
        when(itemBloc.stream).thenAnswer((_) => Stream.value(ItemUnsaved()));

        await tester.pumpWidget(_makeTestableWidget(NewsWebView(id: 1)));

        final centerFinder = find.byType(Center);
        expect(centerFinder, findsOneWidget);

        final progress = find.byType(CircularProgressIndicator);
        expect(progress, findsOneWidget);
      });

  testWidgets('Page should display item when data fetched',
          (WidgetTester tester) async {
        when(detailBloc.state).thenReturn(DetailHasData(testFeed));
        when(detailBloc.stream).thenAnswer((_) => Stream.value(DetailHasData(testFeed)));

        when(itemBloc.state).thenReturn(ItemUnsaved());
        when(itemBloc.stream).thenAnswer((_) => Stream.value(ItemUnsaved()));

        await tester.pumpWidget(_makeTestableWidget(NewsWebView(id: 1)));

        final safeArea = find.byType(SafeArea);
        expect(safeArea, findsOneWidget);

        final web = find.byType(WebView);
        expect(web, findsOneWidget);
      });

  testWidgets('Page should error item when data failed to fetch',
          (WidgetTester tester) async {
        when(detailBloc.state).thenReturn(DetailError('Failure'));
        when(detailBloc.stream).thenAnswer((_) => Stream.value(DetailError('Failure')));

        when(itemBloc.state).thenReturn(ItemUnsaved());
        when(itemBloc.stream).thenAnswer((_) => Stream.value(ItemUnsaved()));

        await tester.pumpWidget(_makeTestableWidget(NewsWebView(id: 1)));

        final center = find.byType(Center);
        expect(center, findsOneWidget);

        final error = find.text('Failure');
        expect(error, findsOneWidget);
      });
}
