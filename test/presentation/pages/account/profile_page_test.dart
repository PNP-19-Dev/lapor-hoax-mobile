import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/account/profile_page.dart';
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

  testWidgets('Page should display register page items',
      (WidgetTester tester) async {
    when(bloc.state).thenReturn(LoginSuccessWithData(testSessionData));
    when(bloc.stream)
        .thenAnswer((_) => Stream.value(LoginSuccessWithData(testSessionData)));

    await tester.pumpWidget(_makeTestableWidget(ProfilePage(
      email: testSessionData.email,
    )));

    final texts = find.byType(Text);
    expect(texts, findsNWidgets(5));

    final inputs = find.byType(TextFormField);
    expect(inputs, findsNWidgets(2));

    final textButton = find.byType(InkWell);
    expect(textButton, findsNWidgets(2));
  });
}
