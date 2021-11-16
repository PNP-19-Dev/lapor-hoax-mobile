/*
 * Created by andii on 12/11/21 23.40
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.34
 */
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('testing app', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      await driver.close();
    });
  });
}
