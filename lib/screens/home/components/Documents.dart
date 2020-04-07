import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pikobar_flutter/components/HeroImagePreviewScreen.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/infoGraphics/infoGraphicsServices.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';

class Documents extends StatefulWidget {
  @override
  _DocumentsState createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  @override
  Widget build(BuildContext context) {
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
                Dictionary.documents,
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

                  AnalyticsHelper.setLogEvent(Analytics.tappedDocumentsMore);
                },
              ),
            ],
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection(Collections.infographics)
              .orderBy('published_date', descending: true)
              .limit(3)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return _buildContent(snapshot);
            } else {
              return _buildLoading();
            }
          },
        )
      ],
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 70,
                  height: 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Skeleton(
                      width: MediaQuery.of(context).size.width / 1.4,
                      padding: 10.0,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Skeleton(
                          height: 20.0,
                          width: MediaQuery.of(context).size.width / 1.8,
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
                ),
                Container(
                  child: Skeleton(
                    height: 30.0,
                    width: 30.0,
                    padding: 10.0,
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget _buildContent(AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.grey[200]),
              borderRadius: BorderRadius.circular(4.0)),
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Row(
            children: <Widget>[
              SizedBox(width: 10),
              Text(
                Dictionary.date,
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(width: 40),
              Text(
                Dictionary.titleDocument,
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Container()
            ],
          ),
        ),
        ListView.builder(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, bottom: 16.0, top: 10.0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot document = snapshot.data.documents[index];

              return Container(
                  child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 10),
                      Text(
                         unixTimeStampToDay(
                             document['published_date'].seconds)+',\n'+unixTimeStampToDateWithoutDay(
                             document['published_date'].seconds),
                         style: TextStyle(
                             color: Colors.grey,
                             fontSize: 12.0,
                             fontWeight: FontWeight.w600),
                         textAlign: TextAlign.left,
                         maxLines: 2,
                         overflow: TextOverflow.ellipsis,
                       ),

                      SizedBox(width: 30),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HeroImagePreview(
                                    Dictionary.heroImageTag,
                                    imageUrl: document['images'][0],
                                  ),
                                ));

//                          AnalyticsHelper.setLogEvent(
//                              Analytics.tappedInfoGraphicsDetail,
//                              <String, dynamic>{'title': document['title']});
                          },
                          child: Text(
                            document['title'],
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(FontAwesomeIcons.solidShareSquare,
                              size: 17, color: Color(0xFF27AE60)),
                          onPressed: () {
//                          InfoGraphicsServices().shareInfoGraphics(
//                              document['title'], document['images'][0]);
                          },
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    color: Colors.grey[200],
                    width: MediaQuery.of(context).size.width,
                    height: 1.5,
                  )
                ],
              ));
            })
      ],
    );
  }
}
