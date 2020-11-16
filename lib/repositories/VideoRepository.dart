import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/VideoModel.dart';

class VideoRepository {
  final videoCollection = FirebaseFirestore.instance.collection(kVideos);

  Stream<List<VideoModel>> getVideo({int limit}) {
    Query videoQuery =
        videoCollection.orderBy('published_at', descending: true);

    if (limit != null) {
      videoQuery = videoQuery.limit(limit);
    }

    return videoQuery.snapshots().map((QuerySnapshot snapshot) => snapshot
        .docs
        .map((doc) => VideoModel.fromFirestore(doc))
        .toList());
  }
}
