import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/news/news_web_view.dart';
import 'package:laporhoax/presentation/provider/detail_cubit.dart';
import 'package:laporhoax/presentation/provider/item_cubit.dart';
import 'package:mockito/mockito.dart';

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
}
