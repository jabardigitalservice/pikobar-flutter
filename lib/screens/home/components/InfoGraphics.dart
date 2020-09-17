import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/infographics/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/CustomBubbleTab.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/infoGraphics/DetailInfoGraphicScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';

class InfoGraphics extends StatefulWidget {
  @override
  _InfoGraphicsState createState() => _InfoGraphicsState();
}

class _InfoGraphicsState extends State<InfoGraphics> {
  InfoGraphicsListBloc infoGraphicsListBloc;

  List<String> listItemTitleTab = [
    Dictionary.titleLatestNews,
    Dictionary.center,
    Dictionary.who,
  ];

  List<String> listCollectionData = [
    kInfographics,
    kInfographicsCenter,
    kInfographicsWho,
  ];

  List<String> analyticsData = [
    Analytics.tappedInfographicJabar,
    Analytics.tappedInfographicCenter,
    Analytics.tappedInfographicWho,
  ];

  @override
  void initState() {
    infoGraphicsListBloc = BlocProvider.of<InfoGraphicsListBloc>(context);
    infoGraphicsListBloc.add(
        InfoGraphicsListLoad(infoGraphicsCollection: kInfographics, limit: 3));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
        builder: (context, remoteState) {
      if (remoteState is RemoteConfigLoaded) {
        Map<String, dynamic> getLabel =
        RemoteConfigHelper.decode(remoteConfig: remoteState.remoteConfig, firebaseConfig: FirebaseConfig.labels, defaultValue: FirebaseConfig.labelsDefaultValue);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    getLabel['info_graphics']['title'],
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontsFamily.lato,
                        fontSize: 16.0),
                  ),
                  InkWell(
                    child: Text(
                      Dictionary.more,
                      style: TextStyle(
                          color: ColorBase.green,
                          fontWeight: FontWeight.w600,
                          fontFamily: FontsFamily.lato,
                          fontSize: 12.0),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                          context, NavigationConstrants.InfoGraphics);

                      AnalyticsHelper.setLogEvent(
                          Analytics.tappedInfoGraphicsMore);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                getLabel['info_graphics']['description'],
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: FontsFamily.lato,
                    fontSize: 12.0),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 5),
                child: CustomBubbleTab(
                  listItemTitleTab: listItemTitleTab,
                  indicatorColor: ColorBase.green,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  onTap: (index) {
                    setState(() {});
                    infoGraphicsListBloc.add(InfoGraphicsListLoad(
                        infoGraphicsCollection: listCollectionData[index],
                        limit: 3));
                    AnalyticsHelper.setLogEvent(analyticsData[index]);
                  },
                  tabBarView: <Widget>[
                    _buildInfographic(),
                    _buildInfographic(),
                    _buildInfographic(),
                  ],
                  heightTabBarView: 260,
                )),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Dictionary.infoGraphics,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontsFamily.lato,
                        fontSize: 16.0),
                  ),
                  InkWell(
                    child: Text(
                      Dictionary.more,
                      style: TextStyle(
                          color: ColorBase.green,
                          fontWeight: FontWeight.w600,
                          fontFamily: FontsFamily.lato,
                          fontSize: 12.0),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                          context, NavigationConstrants.InfoGraphics);

                      AnalyticsHelper.setLogEvent(
                          Analytics.tappedInfoGraphicsMore);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                Dictionary.descInfoGraphic,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: FontsFamily.lato,
                    fontSize: 12.0),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        );
        ;
      }
    });
  }

  Widget _buildInfographic() {
    return BlocBuilder<InfoGraphicsListBloc, InfoGraphicsListState>(
      builder: (context, state) {
        return state is InfoGraphicsListLoaded
            ? _buildContent(state.infoGraphicsList)
            : _buildLoading();
      },
    );
  }

  Widget _buildLoading() {
    return Container(
      height: 260,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          padding: const EdgeInsets.only(
              left: 11.0, right: 16.0, top: 16.0, bottom: 16.0),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
                width: 150,
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 140,
                      width: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Skeleton(
                          width: MediaQuery.of(context).size.width / 1.4,
                          padding: 10.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Skeleton(
                                  height: 20.0,
                                  width:
                                      MediaQuery.of(context).size.width / 1.8,
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
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          child: Skeleton(
                            height: 20.0,
                            width: 20.0,
                            padding: 10.0,
                          ),
                        )
                      ],
                    ),
                  ],
                ));
          }),
    );
  }

  Widget _buildContent(List<DocumentSnapshot> listData) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: listData.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: listData.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot document = listData[index];
                return Container(
                  padding: EdgeInsets.only(left: 10),
                  width: 150,
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          height: 140,
                          width: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: document['images'][0] ?? '',
                              alignment: Alignment.topCenter,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                  heightFactor: 4.2,
                                  child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) => Container(
                                height:
                                    MediaQuery.of(context).size.height / 3.3,
                                color: Colors.grey[200],
                                child: Image.asset(
                                    '${Environment.iconAssets}pikobar.png',
                                    fit: BoxFit.fitWidth),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetailInfoGraphicScreen(
                                  dataInfoGraphic: document)));

                          AnalyticsHelper.setLogEvent(
                              Analytics.tappedInfoGraphicsDetail,
                              <String, dynamic>{'title': document['title']});
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        DetailInfoGraphicScreen(
                                            dataInfoGraphic: document)));

                                AnalyticsHelper.setLogEvent(
                                    Analytics.tappedInfoGraphicsDetail,
                                    <String, dynamic>{
                                      'title': document['title']
                                    });
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                       Expanded(
                                         child:  Text(
                                           unixTimeStampToDateTime(
                                               document['published_date']
                                                   .seconds),
                                           style: TextStyle(
                                               color: Colors.grey,
                                               fontFamily: FontsFamily.lato,
                                               fontSize: 10.0,
                                               fontWeight: FontWeight.w600),
                                           textAlign: TextAlign.left,
                                           maxLines: 2,
                                           overflow: TextOverflow.ellipsis,
                                         ),
                                       )
//                                    Container(
//                                      height: 30,
//                                      child: IconButton(
//                                        icon: Icon(FontAwesomeIcons.share,
//                                            size: 17, color: Color(0xFF27AE60)),
//                                        onPressed: () {
//                                          InfoGraphicsServices()
//                                              .shareInfoGraphics(
//                                                  document['title'],
//                                                  document['images']);
//                                        },
//                                      ),
//                                    )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      document['title'],
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: FontsFamily.lato,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20)
                    ],
                  ),
                );
              })
          : EmptyData(
              message: Dictionary.emptyData,
              desc: '',
              isFlare: false,
              image: "${Environment.imageAssets}not_found.png",
            ),
    );
  }
}
