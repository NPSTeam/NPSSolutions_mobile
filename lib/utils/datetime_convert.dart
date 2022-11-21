import 'package:intl/intl.dart';

DateTime stringToDateTime(String dateTimeStr) {
  return DateFormat("yyyy-MM-ddThh:mm:ss").parse(dateTimeStr);
}
