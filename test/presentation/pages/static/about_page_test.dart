import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/static/about_page.dart';
import 'package:laporhoax/presentation/provider/about_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'about_page_test.mocks.dart';

@GenerateMocks([
  AboutCubit,
])
void main(){
  late MockAboutCubit bloc;

  setUp((){
    bloc = MockAboutCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<AboutCubit>.value(
      value: bloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display about page',
          (WidgetTester tester) async {
        when(bloc.state).thenReturn(AboutState('v1.1.0'));
        when(bloc.stream).thenAnswer((_) => Stream.value(AboutState('v1.1.0')));

        await tester.pumpWidget(_makeTestableWidget(About()));

        final item = find.byKey(Key('about_page_version'));
        expect(item, findsOneWidget);
      });
}