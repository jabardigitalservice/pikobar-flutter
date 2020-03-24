import 'package:flutter/material.dart';

String getYtThumbnail({@required String youtubeUrl, @required bool error}) {
  Uri uri = Uri.parse(youtubeUrl);
  String thumbnailUrl = "";
  if (!error) {
    thumbnailUrl =
        'https://img.youtube.com/vi/${uri.queryParameters['v']}/maxresdefault.jpg';
  } else {
    thumbnailUrl =
        'https://img.youtube.com/vi/${uri.queryParameters['v']}/hqdefault.jpg';
  }
  return thumbnailUrl;
}
