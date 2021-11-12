import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/account/account_page.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockLoginCubit bloc;

  setUp(() {
    bloc = MockLoginCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<LoginCubit>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should welcome when not login',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(LoginEnded());
    when(bloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(AccountPage()));

    final finder = find.byKey(Key('account_page_logout'));
    expect(finder, findsOneWidget);
  });

  testWidgets('Page should display account menu when user is logged in',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(LoginSuccessWithData(testSessionData));
    when(bloc.stream)
        .thenAnswer((_) => Stream.value(LoginSuccessWithData(testSessionData)));

    await tester.pumpWidget(_makeTestableWidget(AccountPage()));

    final finder = find.byKey(Key('account_page_login'));
    expect(finder, findsOneWidget);
  });
}
