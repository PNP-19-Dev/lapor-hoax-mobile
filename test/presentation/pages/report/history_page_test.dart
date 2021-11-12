/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.01
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/data/models/token_id.dart';
import 'package:laporhoax/presentation/pages/report/history_page.dart';
import 'package:laporhoax/presentation/provider/history_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockHistoryCubit bloc;

  setUp(() {
    bloc = MockHistoryCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<HistoryCubit>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tokenId = TokenId(1, 'token');

  testWidgets('Should show loading widget when fetching data',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(HistoryLoading());
        when(bloc.stream).thenAnswer((_) => Stream.empty());

        await tester.pumpWidget(_makeTestableWidget(HistoryPage(tokenId: tokenId)));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  testWidgets('Should show slidable when data is fetched',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(HistoryHasData([testReport]));
        when(bloc.stream)
            .thenAnswer((_) => Stream.value(HistoryHasData([testReport])));

        await tester.pumpWidget(_makeTestableWidget(HistoryPage(tokenId: tokenId)));

        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(Slidable), findsWidgets);
      });

  testWidgets('Should show error when data is error to fetch or empty',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(HistoryError('Failure'));
        when(bloc.stream).thenAnswer((_) => Stream.value(HistoryError('Failure')));

        await tester.pumpWidget(_makeTestableWidget(HistoryPage(tokenId: tokenId)));

        expect(find.byKey(Key('history_page_item_error')), findsOneWidget);
      });
}
