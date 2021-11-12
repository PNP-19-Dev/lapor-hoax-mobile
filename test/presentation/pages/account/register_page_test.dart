import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/account/register_page.dart';
import 'package:laporhoax/presentation/provider/register_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late MockRegisterCubit bloc;

  setUp(() {
    bloc = MockRegisterCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<RegisterCubit>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display register page items',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(RegisterInitial());
    when(bloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(_makeTestableWidget(RegisterPage()));

    final texts = find.byType(Text);
    expect(texts, findsNWidgets(7));

    final inputs = find.byType(TextFormField);
    expect(inputs, findsNWidgets(4));

    final textButton = find.byType(InkWell);
    expect(textButton, findsNWidgets(2));

    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
  });
}
