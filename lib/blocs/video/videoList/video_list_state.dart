part of 'video_list_bloc.dart';

abstract class VideoListState extends Equatable {
  const VideoListState();

  @override
  List<Object> get props => [];
}

class VideoListInitial extends VideoListState {
  @override
  List<Object> get props => [];
}

class VideosLoading extends VideoListState {}

class VideosLoaded extends VideoListState {
  final List<VideoModel> videos;

  const VideosLoaded([this.videos = const []]);

  @override
  List<Object> get props => [videos];

  @override
  String toString() => 'VideosLoaded { todos: $videos }';
}

class VideosFailure extends VideoListState {
  final String error;

  VideosFailure({this.error});

  @override
  String toString() {
    return 'State VideosFailure{error: $error}';
  }

  @override
  List<Object> get props => [error];
}
