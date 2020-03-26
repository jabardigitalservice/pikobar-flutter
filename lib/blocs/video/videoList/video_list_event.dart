part of 'video_list_bloc.dart';

abstract class VideoListEvent extends Equatable {
  const VideoListEvent();

  @override
  List<Object> get props => [];
}

class LoadVideos extends VideoListEvent {}

class VideosUpdated extends VideoListEvent {
  final List<VideoModel> videos;

  const VideosUpdated(this.videos);

  @override
  List<Object> get props => [videos];
}
