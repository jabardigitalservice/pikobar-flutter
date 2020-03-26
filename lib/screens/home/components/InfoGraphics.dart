import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pikobar_flutter/components/HeroImagePreviewScreen.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:share/share.dart';

class InfoGraphics extends StatefulWidget {
  @override
  _InfoGraphicsState createState() => _InfoGraphicsState();
}

class _InfoGraphicsState extends State<InfoGraphics> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection(Collections.infographics)
          .orderBy('published_date', descending: true)
          .limit(3)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return _buildContent(snapshot);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildContent(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Info Praktikal',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: FontsFamily.productSans,
                    fontSize: 16.0),
              ),
              InkWell(
                child: Text(
                  Dictionary.more,
                  style: TextStyle(
                      color: Color(0xFF828282),
                      fontWeight: FontWeight.w600,
                      fontFamily: FontsFamily.productSans,
                      fontSize: 14.0),
                ),
                onTap: () {
                  Navigator.pushNamed(
                      context, NavigationConstrants.InfoGraphics);

                  // AnalyticsHelper.setLogEvent(Analytics.tappedVideoMore);
                },
              ),
            ],
          ),
        ),
        ListView.builder(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot document = snapshot.data.documents[index];

              return Container(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        width: 70,
                        height: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: document['images'][0],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                                heightFactor: 4.2,
                                child: CupertinoActivityIndicator()),
                            errorWidget: (context, url, error) => Container(
                              height: MediaQuery.of(context).size.height / 3.3,
                              color: Colors.grey[200],
                              child: Image.asset(
                                  '${Environment.iconAssets}pikobar.png',
                                  fit: BoxFit.fitWidth),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HeroImagePreview(
                                Dictionary.heroImageTag,
                                imageUrl: document['images'][0],
                              ),
                            ));
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      width: MediaQuery.of(context).size.width - 110,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            child: Text(
                              document['title'],
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HeroImagePreview(
                                      Dictionary.heroImageTag,
                                      imageUrl: document['images'][0],
                                    ),
                                  ));
                            },
                          ),
                          Container(
                            // color: Colors.grey,
                            padding: EdgeInsets.only(top: 5.0),
                            child: ButtonBar(
                              buttonPadding: EdgeInsets.all(0),
                              alignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RaisedButton.icon(
                                  onPressed: () {
                                    print('Button Clicked.');
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0))),
                                  icon: Padding(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: Icon(
                                      FontAwesomeIcons.download,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                  label: Padding(
                                    padding: const EdgeInsets.only(right: 18),
                                    child: Text(
                                      'Unduh',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  textColor: Colors.white,
                                  splashColor: Colors.green[300],
                                  color: Color(0xFF27AE60),
                                ),
                                RaisedButton.icon(
                                  onPressed: () {
                                    final _title = document['title'];
                                    final _backLink =
                                        '${UrlThirdParty.urlCoronaInfo}infographics/${document.documentID}';

                                    Share.share(
                                        '$_title\n\n${_backLink != null ? _backLink + '\n' : ''}\nBaca Selengkapnya di aplikasi Pikobar : ${UrlThirdParty.pathPlaystore}');

                                    // AnalyticsHelper.setLogEvent(
                                    //     Analytics.tappedShareNews, <String, dynamic>{
                                    //   'title': widget.documents['title']
                                    // });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    side: BorderSide(color: Color(0xFF27AE60)),
                                  ),
                                  icon: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 18,
                                    ),
                                    child: Icon(
                                      FontAwesomeIcons.shareSquare,
                                      size: 15,
                                      color: Color(0xFF27AE60),
                                    ),
                                  ),
                                  label: Padding(
                                    padding: const EdgeInsets.only(right: 18),
                                    child: Text(
                                      'Bagikan',
                                    ),
                                  ),
                                  textColor: Colors.green,
                                  splashColor: Colors.green[300],
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }
}
