/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.01
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/report/report_page.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/presentation/provider/report_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockLoginCubit loginBloc;
  late MockReportCubit reportBloc;

  setUp(() {
    loginBloc = MockLoginCubit();
    reportBloc = MockReportCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>.value(value: loginBloc),
        BlocProvider<ReportCubit>.value(value: reportBloc),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display not login state of report page',
          (WidgetTester tester) async {
        when(loginBloc.state).thenReturn(LoginEnded());
        when(loginBloc.stream).thenAnswer((_) => Stream.empty());

        await tester.pumpWidget(_makeTestableWidget(ReportPage()));

        final item = find.byKey(Key('report_is_welcome'));
        expect(item, findsOneWidget);
      });

  testWidgets('Page should display login state of report page',
          (WidgetTester tester) async {
        when(loginBloc.state).thenReturn(LoginSuccessWithData(testSessionData));
        when(loginBloc.stream)
            .thenAnswer((_) => Stream.value(LoginSuccessWithData(testSessionData)));

        when(reportBloc.state).thenReturn(CategoryFetched([testCategory]));
        when(reportBloc.stream)
            .thenAnswer((_) => Stream.value(CategoryFetched([testCategory])));

        await tester.pumpWidget(_makeTestableWidget(ReportPage()));

        final item = find.byKey(Key('report_is_lapor'));
        expect(item, findsOneWidget);
      });
}
