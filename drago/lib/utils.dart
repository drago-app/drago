// _idParser(String id) => (id[2] == '_') ? id.substring(3, id.length) : id;

import 'package:number_display/number_display.dart';

Duration age(DateTime given) => DateTime.now().difference(given);
String ageString(Duration age) {
  if (age.inDays > 0) {
    return '${age.inDays.toString()}d';
  } else if (age.inHours > 0) {
    return '${age.inHours.toString()}h';
  } else if (age.inMinutes > 0) {
    return '${age.inMinutes.toString()}m';
  } else {
    return '${age.inSeconds.toString()}s';
  }
}

String createdUtcToAge(DateTime createdUtc) => ageString(age(createdUtc));

String doubleToString(double d) {
  return ((d * 100.00).toInt()).toString() + '%';
}

final display = createDisplay(length: 3, decimal: 2);
String truncateLongInt(int upvotes) {
  return display(upvotes);
}
