import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/blocs/video/videoList/Bloc.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/models/VideoModel.dart';
import 'package:pikobar_flutter/repositories/VideoRepository.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';

class VideoListBloc extends Bloc<VideoListEvent, VideoListState> {
  final VideoRepository _videoRepository = VideoRepository();
  LabelNew labelNew = LabelNew();

  VideoListBloc() : super(VideoListInitial());

  @override
  Stream<VideoListState> mapEventToState(
    VideoListEvent event,
  ) async* {
    if (event is LoadVideos) {
      yield VideosLoading();
      List<VideoModel> allVideos =
          await _videoRepository.getVideo(limit: event.limit);
      labelNew.insertDataLabel(allVideos, Dictionary.labelVideos);
      yield VideosLoaded(allVideos);
    }
  }
}
