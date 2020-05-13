import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/VideoModel.dart';

abstract class VideoListEvent extends Equatable {
  const VideoListEvent([List props = const <dynamic>[]]);
}

class LoadVideos extends VideoListEvent {
  final limit;

  LoadVideos({this.limit});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class VideosUpdated extends VideoListEvent {
  final List<VideoModel> videos;

  const VideosUpdated(this.videos);

  @override
  List<Object> get props => [videos];
}
