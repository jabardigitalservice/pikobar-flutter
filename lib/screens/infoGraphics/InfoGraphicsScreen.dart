import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/HeroImagePreviewScreen.dart';
import 'package:pikobar_flutter/components/PikobarPlaceholder.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/screens/infoGraphics/infoGraphicsServices.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';

class InfoGraphicsScreen extends StatefulWidget {
  @override
  _InfoGraphicsScreenState createState() => _InfoGraphicsScreenState();
}

class _InfoGraphicsScreenState extends State<InfoGraphicsScreen> {
  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.infoGraphics);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: Dictionary.infoGraphics),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection(Collections.infographics)
            .orderBy('published_date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final List data = snapshot.data.documents;
            final int dataCount = data.length;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio:
                      0.6),
              shrinkWrap: true,
              itemCount: dataCount,
              padding: EdgeInsets.only(bottom: 20.0, top: 10.0, left: 14.0),
              itemBuilder: (_, int index) {
                return _cardContent(data[index]);
              },
            );
          } else {
            return _buildLoading();
          }
        },
      ),
    );
    //   body:
  }

  _buildLoading() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 1.5,
      margin: EdgeInsets.only(right: 14, top: 10, bottom: 0),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.20,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Skeleton(
              width: MediaQuery.of(context).size.width,
              padding: 10.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 14.0, right: 14.0, top: 14.0, bottom: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Skeleton(
                        height: 20.0,
                        width: MediaQuery.of(context).size.width / 1.4,
                        padding: 10.0,
                      ),
                      SizedBox(height: 8),
                      Skeleton(
                        height: 20.0,
                        width: MediaQuery.of(context).size.width / 2,
                        padding: 10.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Skeleton(
                    height: 20.0,
                    width: 20,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardContent(DocumentSnapshot data) {
    return Container(
      margin: EdgeInsets.only(right: 14, top: 10, bottom: 0),
      child: Column(
        children: <Widget>[
          InkWell(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: CachedNetworkImage(
                imageUrl: data['images'][0] ?? '',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Center(
                    heightFactor: 10.2, child: CupertinoActivityIndicator()),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0)),
                  ),
                  child: PikobarPlaceholder(),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HeroImagePreview(
                      Dictionary.heroImageTag,
                      galleryItems: data['images'],
                    ),
                  ));

              AnalyticsHelper.setLogEvent(Analytics.tappedInfoGraphicsDetail,
                  <String, dynamic>{'title': data['title']});
            },
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 9.0, top: 14.0, bottom: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HeroImagePreview(
                              Dictionary.heroImageTag,
                              galleryItems: data['images'],
                            ),
                          ));

                      AnalyticsHelper.setLogEvent(
                          Analytics.tappedInfoGraphicsDetail,
                          <String, dynamic>{'title': data['title']});
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                unixTimeStampToDateTime(
                                    data['published_date'].seconds),
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: FontsFamily.lato,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
//                              Container(
//                                height: 25,
//                                child: IconButton(
//                                  padding: EdgeInsets.all(0),
//                                  alignment: Alignment.topRight,
//                                  icon: Icon(FontAwesomeIcons.share,
//                                      size: 17, color: Color(0xFF27AE60)),
//                                  onPressed: () {
//                                    InfoGraphicsServices()
//                                        .shareInfoGraphics(
//                                        data['title'],
//                                        data['images']);
//                                  },
//                                ),
//                              )
                            ]),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          data['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.lato,
                          ),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
