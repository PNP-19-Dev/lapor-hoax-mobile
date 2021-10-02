import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formattedDate(String dateTime) {
    final input = dateTime.replaceAll('T', ' ');
    return DateFormat('dd MMMM yyyy H.mm').format(DateTime.parse(input));
  }
}
