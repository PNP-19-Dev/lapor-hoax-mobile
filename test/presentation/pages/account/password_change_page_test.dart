import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/account/password_change_page.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:laporhoax/presentation/provider/password_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockLoginCubit loginCubit;
  late MockPasswordCubit passwordCubit;

  setUp(() {
    loginCubit = MockLoginCubit();
    passwordCubit = MockPasswordCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>.value(value: loginCubit),
        BlocProvider<PasswordCubit>.value(value: passwordCubit),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display register page items',
      (WidgetTester tester) async {
    when(loginCubit.state).thenReturn(LoginSuccessWithData(testSessionData));
    when(loginCubit.stream)
        .thenAnswer((_) => Stream.value(LoginSuccessWithData(testSessionData)));

    when(passwordCubit.state).thenReturn(PasswordInitial());
    when(passwordCubit.stream).thenAnswer((_) => Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(PasswordChangePage()));

    final texts = find.byType(Text);
    expect(texts, findsNWidgets(5));

    final inputs = find.byType(TextFormField);
    expect(inputs, findsNWidgets(3));

    final textButton = find.byType(InkWell);
    expect(textButton, findsOneWidget);

    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
  });
}
