import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formattedDate(String dateTime) {
    final input = dateTime.replaceAll('T', ' ');
    return DateFormat('dd MMMM yyyy H.mm').format(DateTime.parse(input));
  }

  static String formattedDateToken(String dateTime) {
    final input = dateTime.replaceAll('T', ' ');
    return DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.parse(input));
  }
}
