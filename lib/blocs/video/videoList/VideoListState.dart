import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/VideoModel.dart';

abstract class VideoListState extends Equatable {
  const VideoListState();

  @override
  List<Object> get props => [];
}

class VideoListInitial extends VideoListState {}

class VideosLoading extends VideoListState {}

class VideosLoaded extends VideoListState {
  final List<VideoModel> videos;

  const VideosLoaded(this.videos);

  @override
  List<Object> get props => [videos];
}
