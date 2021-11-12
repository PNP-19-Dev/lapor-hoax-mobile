import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/account/login_page.dart';
import 'package:laporhoax/presentation/provider/login_cubit.dart';
import 'package:mockito/mockito.dart';

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

  testWidgets('Page should display register page items',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(LoginInitial());
    when(bloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(LoginPage()));

    final texts = find.byType(Text);
    expect(texts, findsNWidgets(6));

    final inputs = find.byType(TextFormField);
    expect(inputs, findsNWidgets(2));

    final textButton = find.byType(InkWell);
    expect(textButton, findsOneWidget);

    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
  });
}
