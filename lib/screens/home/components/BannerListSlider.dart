import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/PikobarPlaceholder.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerListSlider extends StatefulWidget {
  @override
  BannerListSliderState createState() => BannerListSliderState();
}

class BannerListSliderState extends State<BannerListSlider> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('banners')
          .orderBy('sequence')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildLoading();
          default:
            return _buildSlider(snapshot);
        }
      },
    );
  }

  Widget _buildLoading() {
    return AspectRatio(
      aspectRatio: 21 / 9,
      child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Skeleton(
                    width: MediaQuery.of(context).size.width,
                  ),
                ));
          }),
    );
  }

  _buildSlider(AsyncSnapshot<QuerySnapshot> snapshot) {
    return CarouselSlider(
      initialPage: 0,
      enableInfiniteScroll: snapshot.data.documents.length > 1 ? true : false,
      aspectRatio: 21 / 9,
      viewportFraction: snapshot.data.documents.length > 1 ? 0.8 : 0.95,
      autoPlay: snapshot.data.documents.length > 1 ? true : false,
      autoPlayInterval: Duration(seconds: 5),
      items: snapshot.data.documents.map((DocumentSnapshot document) {
        return Builder(builder: (BuildContext context) {
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                    imageUrl: document['url']??'',
                    imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                    placeholder: (context, url) => Center(
                        heightFactor: 10.2,
                        child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0)),
                        ),
                        child: PikobarPlaceholder())),
              ),
            ),
            onTap: () {
              if (document['action_url'] != null) {
                _clickAction(document['action_url']);
                AnalyticsHelper.setLogEvent(Analytics.tappedBanner,
                    <String, dynamic>{'url': document['action_url']});
              }
            },
          );
        });
      }).toList(),
    );
  }

  _clickAction(String url) async {
    if (url.contains('youtube')) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      Navigator.of(context)
          .pushNamed(NavigationConstrants.Browser, arguments: url);
    }
  }
}
