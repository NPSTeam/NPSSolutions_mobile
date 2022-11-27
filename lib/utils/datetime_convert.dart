import 'package:intl/intl.dart';

DateTime stringToDateTime(String dateTimeStr) {
  return DateFormat("yyyy-MM-ddThh:mm:ss").parse(dateTimeStr, true);
}

String dateTimeToString(DateTime dateTime) {
  return DateFormat("yyyy-MM-dd hh:mm").format(dateTime);
}

DateTime utcToLocalDateTime(DateTime dateTime) {
  return dateTime.toLocal();
}
