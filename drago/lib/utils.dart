_idParser(String id) => (id[2] == '_') ? id.substring(3, id.length) : id;

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
