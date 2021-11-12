/*
 * Created by andii on 12/11/21 23.01
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 23.00
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:laporhoax/utils/datetime_helper.dart';

void main() {
  const date = '2021-10-13T01:34:58.831621+07:00';
  const formatToDate = '12 October 2021';
  const formatToDateAndTime = '12 October 2021 18.34';
  String dateTimeTokenData = '2021-10-12 18:34:58.831';
  var dateTimeToken = DateTime.parse(dateTimeTokenData);

  group('date helper test', () {
    test('expect given date is converted to date', () {
      expect(DateTimeHelper.formattedDate(date), formatToDate);
    });

    test('expect given date is converted to date and time', () {
      expect(DateTimeHelper.formattedDateTime(date), formatToDateAndTime);
    });

    test('expect given date is converted to date for token', () {
      expect(DateTimeHelper.formattedDateToken(date), dateTimeToken);
    });
  });
}
