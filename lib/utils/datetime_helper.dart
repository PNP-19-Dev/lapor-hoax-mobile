/*
 * Created by andii on 12/11/21 22.55
 * Copyright (c) 2021 . All rights reserved.
 * Last modified 12/11/21 22.55
 */

import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formattedDate(String dateTime) {
    final input = dateTime.replaceAll('T', ' ');
    return DateFormat('dd MMMM yyyy').format(DateTime.parse(input));
  }

  static String formattedDateTime(String dateTime) {
    final input = dateTime.replaceAll('T', ' ');
    return DateFormat('dd MMMM yyyy H.mm').format(DateTime.parse(input));
  }

  static DateTime formattedDateToken(String dateTime) {
    final input = dateTime.replaceAll('T', ' ');
    String data =
    DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.parse(input));
    return DateTime.parse(data);
  }
}
