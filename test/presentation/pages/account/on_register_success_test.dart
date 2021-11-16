/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.01
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/presentation/pages/account/on_register_success.dart';

void main() {
  Widget _makeTestableWidget(Widget body) {
    return MaterialApp(
      home: body,
    );
  }

  testWidgets('Page should display on register success page',
          (WidgetTester tester) async {
        await tester.pumpWidget(_makeTestableWidget(OnRegisterSuccess('Success')));

        final image = find.byType(SvgPicture);
        expect(image, findsOneWidget);

        final message = find.text('Success');
        expect(message, findsOneWidget);

        final text = find.byType(Text);
        expect(text, findsNWidgets(3));

        final button = find.byType(ElevatedButton);
        expect(button, findsOneWidget);
      });
}
