

import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/VideoModel.dart';

abstract class VideoListState extends Equatable {
  const VideoListState([List props = const <dynamic>[]]);
}

class VideoListInitial extends VideoListState {
  @override
  List<Object> get props => [];
}

class VideosLoading extends VideoListState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class VideosLoaded extends VideoListState {
  final List<VideoModel> videos;

  const VideosLoaded(this.videos);

  @override
  List<Object> get props => [videos];
}
