import 'package:intl/intl.dart';

class UtilFunction {
  static String dateTimeToString(
    DateTime? dateTime, {
    String format = 'dd/MM/yyyy – HH:mm',
  }) {
    if (dateTime == null) return '';

    return DateFormat(format).format(dateTime);
  }
}
