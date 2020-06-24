import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/blocs/video/videoList/Bloc.dart';
import 'package:pikobar_flutter/repositories/VideoRepository.dart';

class VideoListBloc extends Bloc<VideoListEvent, VideoListState> {
  final VideoRepository _videoRepository = VideoRepository();
  StreamSubscription _videosSubscription;

  @override
  VideoListState get initialState => VideoListInitial();

  @override
  Stream<VideoListState> mapEventToState(
    VideoListEvent event,
  ) async* {
    if (event is LoadVideos) {
      yield* _mapLoadVideosToState(limit: event.limit);
    } else if (event is VideosUpdated) {
      yield* _mapVideosUpdateToState(event);
    }
  }

  Stream<VideoListState> _mapLoadVideosToState({int limit}) async* {
    yield VideosLoading();
    _videosSubscription?.cancel();
    _videosSubscription = _videoRepository.getVideo(limit: limit).listen(
          (videos) => add(VideosUpdated(videos)),
        );
  }

  Stream<VideoListState> _mapVideosUpdateToState(VideosUpdated event) async* {
    yield VideosLoaded(event.videos);
  }

  @override
  Future<void> close() {
    _videosSubscription?.cancel();
    return super.close();
  }
}
