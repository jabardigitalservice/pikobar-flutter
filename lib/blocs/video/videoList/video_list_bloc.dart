import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/models/VideoModel.dart';
import 'package:pikobar_flutter/repositories/VideoRepository.dart';

part 'video_list_event.dart';
part 'video_list_state.dart';

class VideoListBloc extends Bloc<VideoListEvent, VideoListState> {
  final VideoRepository _videoRepository;
  StreamSubscription _videosSubscription;

  VideoListBloc({@required VideoRepository videoRepository})
      : assert(videoRepository != null),
        _videoRepository = videoRepository;

  @override
  VideoListState get initialState => VideoListInitial();

  @override
  Stream<VideoListState> mapEventToState(
    VideoListEvent event,
  ) async* {
    if (event is LoadVideos) {
      yield* _mapLoadVideosToState();
    } else if (event is VideosUpdated) {
      yield* _mapVideosUpdateToState(event);
    }
  }

  Stream<VideoListState> _mapLoadVideosToState() async* {
    yield VideosLoading();
    _videosSubscription?.cancel();
    _videosSubscription = _videoRepository.getVideo().listen(
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
