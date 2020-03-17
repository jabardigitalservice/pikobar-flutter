import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class BannerListSlider extends StatefulWidget {
  @override
  BannerListSliderState createState() => BannerListSliderState();
}

class BannerListSliderState extends State<BannerListSlider> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('banners').snapshots(),
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Skeleton(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                  ),
                ));
          }),
    );
  }

  _buildSlider(AsyncSnapshot<QuerySnapshot> snapshot) {
    return CarouselSlider(
      initialPage: 0,
      enableInfiniteScroll: true,
      aspectRatio: 21 / 9,
      viewportFraction: 0.9,
      autoPlay: true,
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
                    imageUrl: document['action_url'],
                    imageBuilder: (context, imageProvider) =>
                        Container(
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
                    placeholder: (context, url) =>
                        Center(
                            heightFactor: 10.2,
                            child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) =>
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5.0),
                                  topRight: Radius.circular(5.0)),
                            ),
                            child: Image.asset(
                                '${Environment.imageAssets}placeholder.png',
                                fit: BoxFit.fitWidth))),
              ),
            ),
            onTap: () {
              //_clickAction(data);
            },
          );
        });
      }).toList(),
      onPageChanged: (index) {

      },
    );
  }

/*_clickAction(BannerModel record) {
     if (record.type == 'internal') {
       switch (record.internalCategory) {
         case 'news':
           _openDetailNews(record.internalEntityId);
           break;

         case 'polling':
           _openDetailPolling(record.internalEntityId);
           break;

         case 'survey':
           _openDetailSurvey(record.internalEntityId);
           break;

         case 'news-important':
           _openDetailImportantInfo(record.internalEntityId);
           break;
       }
     } else {
       _openInAppBrowser(record.linkUrl);
     }
   }

   _openDetailNews(int id) {
     Navigator.of(context).push(MaterialPageRoute(
         builder: (context) => NewsDetailScreen(newsId: id, isIdKota: false)));
   }

   _openDetailSurvey(int id) async {
     try {
       String externalUrl = await SurveyRepository().getUrl(id);
       await Navigator.pushNamed(context, NavigationConstrants.Browser,
           arguments: externalUrl);
     } catch (e) {
       unawaited(Fluttertoast.showToast(
           msg: CustomException.onConnectionException(e.toString()),
           toastLength: Toast.LENGTH_LONG,
           gravity: ToastGravity.TOP,
           backgroundColor: Colors.red,
           textColor: Colors.white));
     }
   }

   _openDetailImportantInfo(int id) {
     Navigator.push(
         context,
         MaterialPageRoute(
             builder: (context) => ImportantInfoDetailScreen(id: id)));
   }

   _openDetailPolling(int id) async {
     PollingRepository _pollingRepository = PollingRepository();

     try {
       bool isVoted = await _pollingRepository.getVoteStatus(pollingId: id);

       if (!isVoted) {
         PollingModel record = await _pollingRepository.getDetail(id);
         await Navigator.pushNamed(context, NavigationConstrants.PollingDetail,
             arguments: record);
       } else {
         unawaited(Fluttertoast.showToast(
             msg: Dictionary.pollingHasVotedMessage,
             toastLength: Toast.LENGTH_LONG,
             gravity: ToastGravity.TOP,
             backgroundColor: Colors.blue,
             textColor: Colors.white));
       }
     } catch (e) {
       unawaited(Fluttertoast.showToast(
           msg: CustomException.onConnectionException(e.toString()),
           toastLength: Toast.LENGTH_LONG,
           gravity: ToastGravity.TOP,
           backgroundColor: Colors.red,
           textColor: Colors.white));
     }
   }

   _openInAppBrowser(String externalUrl) async {
     if (externalUrl != null) {
       if (externalUrl.contains('market') ||
           externalUrl.contains('play.google')) {
         if (await canLaunch(externalUrl)) {
           await launch(externalUrl);
         } else {
           throw 'Could not launch $externalUrl';
         }
       } else {
         await Navigator.pushNamed(context, NavigationConstrants.Browser,
             arguments: externalUrl);
       }
     }
   }*/

}
