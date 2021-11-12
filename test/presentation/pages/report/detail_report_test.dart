/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.59
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/report/detail_report_page.dart';

import '../../../dummy_data/dummy_objects.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
    );
  }

  testWidgets('Page should display detail report', (WidgetTester tester) async {
    await tester
        .pumpWidget(_makeTestableWidget(DetailReportPage(report: testReport)));

    final img = find.byType(CachedNetworkImage);
    expect(img, findsOneWidget);

    final link = find.byType(InkWell);
    expect(link, findsOneWidget);

    final text = find.byType(Text);
    expect(text, findsNWidgets(12));
  });
}
