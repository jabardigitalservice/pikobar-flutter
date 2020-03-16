import 'package:timeago/timeago.dart' as time_ago;

String fromTimeMillis(int millisecond) {
  time_ago.setLocaleMessages('id', time_ago.IdMessages());

  return time_ago.format(DateTime.fromMillisecondsSinceEpoch(millisecond * 1000),
      locale: 'id');
}
