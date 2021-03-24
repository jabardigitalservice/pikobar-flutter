String autoReplaceForDailyReport(
    {String otherUID, text, List<String> replaceFrom, replaceTo}) {
  String result = text;
  for (var i = 0; i < replaceFrom.length; i++) {
    result = result.replaceAll(replaceFrom[i], replaceTo[i]);
  }

  return otherUID == null ? text : result;
}
