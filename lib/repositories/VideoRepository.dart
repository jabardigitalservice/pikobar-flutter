import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/models/VideoModel.dart';

class VideoRepository {
  final videoCollection = Firestore.instance.collection(Collections.videos);

  Stream<List<VideoModel>> getVideo() {
    return videoCollection.orderBy('published_at', descending: true).snapshots().map(
        (QuerySnapshot snapshot) => snapshot.documents
            .map((doc) => VideoModel.fromFirestore(doc))
            .toList());
  }
}
