import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/report/on_loading_report.dart';

import '../../../dummy_data/dummy_objects.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
    );
  }

  testWidgets('Page should display success report page',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        _makeTestableWidget(OnSuccessReport(reportItem: testReport)));

    final item = find.byType(Text);
    expect(item, findsNWidgets(5));

    final text = find.byType(SvgPicture);
    expect(text, findsOneWidget);

    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);

    final seeRecent = find.byType(InkWell);
    expect(seeRecent, findsNWidgets(2));
  });

  testWidgets('Page should display error report page',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(OnFailureReport()));

    final item = find.byType(Text);
    expect(item, findsNWidgets(4));

    final text = find.byType(SvgPicture);
    expect(text, findsOneWidget);

    final button = find.byType(ElevatedButton);
    expect(button, findsOneWidget);
  });
}
