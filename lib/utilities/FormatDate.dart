import 'package:intl/intl.dart';

String unixTimeStampToDateTime(int millisecond) {
  var format = DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id');
  var dateTimeString = format.format(DateTime.fromMillisecondsSinceEpoch(millisecond * 1000));

  return dateTimeString;
}

String unixTimeStampToDate(int millisecond) {
  var format = DateFormat.yMMMMEEEEd('id');
  var dateString = format.format(DateTime.fromMillisecondsSinceEpoch(millisecond * 1000));
  return dateString;
}

String unixTimeStampToDateWithoutDay(int millisecond) {
  var format = DateFormat.yMMMMd('id');
  var dateString = format.format(DateTime.fromMillisecondsSinceEpoch(millisecond * 1000));
  return dateString;
}

String unixTimeStampToDateWithoutMultiplication(int millisecond) {
  var format = DateFormat.yMMMMEEEEd('id');
  var dateString = format.format(DateTime.fromMillisecondsSinceEpoch(millisecond));
  return dateString;
}

String unixTimeStampToTimeAgo(int millisecond) {
  var format = DateFormat.yMMMMEEEEd('id');
  var dateString = format.format(DateTime.fromMillisecondsSinceEpoch(millisecond * 1000));
  Duration diff = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(millisecond * 1000));

  if (diff.inDays > 7) {
    return dateString;
  } else
  if (diff.inDays > 0) {
    return "${diff.inDays} hari yang lalu";
  } else
  if (diff.inHours > 0) {
    return "${diff.inHours} jam yang lalu";
  } else
  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} menit yang lalu";
  } else {
    return "Baru saja";
  }
}