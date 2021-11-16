/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.01
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/account/account_page.dart';
import 'package:laporhoax/presentation/pages/static/static_page_viewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  testWidgets('Page should display static web page',
      (WidgetTester tester) async {
    final staticDataWeb =
        StaticDataWeb(title: 'Kebijakan Privasi', fileName: 'privacy_policy');

        await tester.pumpWidget(MaterialApp(
            home: StaticPageViewer(
              data: staticDataWeb,
            )));

        final item = find.byType(WebView);
        expect(item, findsOneWidget);
      });
}
