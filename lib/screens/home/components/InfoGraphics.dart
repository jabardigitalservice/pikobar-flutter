import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pikobar_flutter/blocs/infographics/Bloc.dart';
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

class InfoGraphics extends StatefulWidget {
  @override
  _InfoGraphicsState createState() => _InfoGraphicsState();
}

class _InfoGraphicsState extends State<InfoGraphics> {
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
                Dictionary.infoGraphics,
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

                  AnalyticsHelper.setLogEvent(Analytics.tappedInfoGraphicsMore);
                },
              ),
            ],
          ),
        ),
        BlocBuilder<InfoGraphicsListBloc, InfoGraphicsListState>(
          builder: (context, state) {
            return state is InfoGraphicsListLoaded ? _buildContent(state.infoGraphicsList) : _buildLoading();
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

  Widget _buildContent(List<DocumentSnapshot> listData) {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: listData.length,
        itemBuilder: (context, index) {
          final DocumentSnapshot document = listData[index];

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
                        imageUrl: document['images'][0]??'',
                        alignment: Alignment.topCenter,
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
                            galleryItems: document['images'],
                          ),
                        ));

                    AnalyticsHelper.setLogEvent(
                        Analytics.tappedInfoGraphicsDetail,
                        <String, dynamic>{'title': document['title']});
                  },
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HeroImagePreview(
                              Dictionary.heroImageTag,
                              galleryItems: document['images'],
                            ),
                          ));

                      AnalyticsHelper.setLogEvent(
                          Analytics.tappedInfoGraphicsDetail,
                          <String, dynamic>{'title': document['title']});
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            document['title'],
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            unixTimeStampToDateWithoutDay(
                                document['published_date'].seconds),
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.share,
                        size: 17, color: Color(0xFF27AE60)),
                    onPressed: () {
                      InfoGraphicsServices().shareInfoGraphics(
                          document['title'], document['images']);
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}
