import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/utilities/launchExternal.dart';
import 'package:pikobar_flutter/utilities/youtubeThumnail.dart';
import 'package:shimmer/shimmer.dart';

class VideosScreen extends StatefulWidget {
  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Dictionary.videoUpToDate),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(Collections.videos)
            .orderBy('sequence')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.isNotEmpty) {
              return _buildContent(snapshot);
            } else {
              return EmptyData(message: Dictionary.emptyData);
            }
          } else {
            return _buildLoading();
          }
        },
      ),
    );
  }

  _buildLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Column(
        children: <Widget>[
          Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    color: Colors.grey[300]),
                Container(
                  padding: EdgeInsets.all(17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 20.0,
                          color: Colors.grey[300]),
                      SizedBox(height: 5.0),
                      Container(
                          width: MediaQuery.of(context).size.width - 160,
                          height: 20.0,
                          color: Colors.grey[300]),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildContent(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Container(
      child: ListView.builder(
          itemCount: snapshot.data.documents.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final DocumentSnapshot document = snapshot.data.documents[index];

            return Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: getYtThumbnail(
                              youtubeUrl: document['url'], error: false),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            heightFactor: 4.2,
                            child: CupertinoActivityIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Container(height: 200, color: Colors.grey[200]),
                        ),
                        Image.asset(
                          '${Environment.iconAssets}play_button.png',
                          scale: 1.5,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    launchExternal(document['url']);
                  },
                ),
                Container(
                  padding: EdgeInsets.all(17),
                  child: Column(
                    children: <Widget>[
                      Text(
                        document['title'],
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
