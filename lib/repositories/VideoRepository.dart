import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/VideoModel.dart';

class VideoRepository {
  final videoCollection = Firestore.instance.collection(Collections.videos);

  Stream<List<VideoModel>> getVideo({int limit}) {
    Query videoQuery = videoCollection.orderBy('published_at', descending: true);

    if (limit != null) {
      videoQuery = videoQuery.limit(limit);
    }

    return videoQuery.snapshots().map(
        (QuerySnapshot snapshot) => snapshot.documents
            .map((doc) => VideoModel.fromFirestore(doc))
            .toList());
  }
}
