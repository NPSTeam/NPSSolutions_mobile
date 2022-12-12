import 'package:intl/intl.dart';

DateTime stringToDateTime(String dateTimeStr) {
  return DateFormat("yyyy-MM-ddThh:mm:ss").parse(dateTimeStr, true);
}

String dateTimeToString(DateTime dateTime,
    [String? format = "yyyy-MM-dd hh:mm"]) {
  return DateFormat(format).format(dateTime);
}

DateTime utcToLocalDateTime(DateTime dateTime) {
  return dateTime.toLocal();
}
