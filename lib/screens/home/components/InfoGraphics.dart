import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/infographics/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/configs/SharedPreferences/LabelNew.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/LabelNewModel.dart';
import 'package:pikobar_flutter/screens/home/components/CovidInformationScreen.dart';
import 'package:pikobar_flutter/screens/infoGraphics/DetailInfoGraphicScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';

// ignore: must_be_immutable
class InfoGraphics extends StatefulWidget {
  final String searchQuery;
  CovidInformationScreenState covidInformationScreenState;

  InfoGraphics({this.searchQuery, this.covidInformationScreenState});

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

  List<LabelNewModel> dataLabel = [];

  @override
  void initState() {
    infoGraphicsListBloc = BlocProvider.of<InfoGraphicsListBloc>(context);
    infoGraphicsListBloc.add(InfoGraphicsListLoad(
        infoGraphicsCollection: kAllInfographics, limit: 5));
    super.initState();
  }

  Future<Null> getDataLabel() async {
    String label = await LabelNewSharedPreference.getLabelNewInfoGraphics();
    if (label != null) {
      if (!mounted) return;
      setState(() {
        dataLabel = LabelNewModel.decode(label);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
        builder: (context, remoteState) {
      if (remoteState is RemoteConfigLoaded) {
        Map<String, dynamic> getLabel = RemoteConfigHelper.decode(
            remoteConfig: remoteState.remoteConfig,
            firebaseConfig: FirebaseConfig.labels,
            defaultValue: FirebaseConfig.labelsDefaultValue);
        return _buildInfographic(getLabel);
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
                          fontSize: Dimens.textSubtitleSize),
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
      }
    });
  }

  Widget _buildInfographic(Map<String, dynamic> getLabel) {
    return BlocBuilder<InfoGraphicsListBloc, InfoGraphicsListState>(
      builder: (context, state) {
        return state is InfoGraphicsListLoaded
            ? _buildContent(state.infoGraphicsList, getLabel)
            : _buildLoading();
      },
    );
  }

  Widget _buildLoading() {
    return Container(
      height: 265,
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
                      ],
                    ),
                  ],
                ));
          }),
    );
  }

  Widget _buildContent(
      List<DocumentSnapshot> listData, Map<String, dynamic> getLabel) {
    if (widget.searchQuery != null) {
      listData = listData
          .where((test) => test['title']
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase()))
          .toList();
      if (listData.isEmpty) {
        widget.covidInformationScreenState.isEmptyDataInfoGraphic = true;
      }
    }
    getDataLabel();

    return listData.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 10.0),
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
                          fontSize: Dimens.textTitleSize),
                    ),
                    InkWell(
                      child: Text(
                        Dictionary.more,
                        style: TextStyle(
                            color: ColorBase.green,
                            fontWeight: FontWeight.w600,
                            fontFamily: FontsFamily.lato,
                            fontSize: Dimens.textSubtitleSize),
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
              Container(
                height: 265,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.searchQuery != null ? listData.length : 5,
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
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3.3,
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
                                    builder: (context) =>
                                        DetailInfoGraphicScreen(
                                            dataInfoGraphic: document)));

                                AnalyticsHelper.setLogEvent(
                                    Analytics.tappedInfoGraphicsDetail,
                                    <String, dynamic>{
                                      'title': document['title']
                                    });
                              },
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailInfoGraphicScreen(
                                                      dataInfoGraphic:
                                                          document)));

                                      AnalyticsHelper.setLogEvent(
                                          Analytics.tappedInfoGraphicsDetail,
                                          <String, dynamic>{
                                            'title': document['title']
                                          });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            document['title'],
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: FontsFamily.roboto,
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.left,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              isLabelNew(document.id.toString())
                                                  ? Container(
                                                      padding: EdgeInsets.only(
                                                          top: 5,
                                                          bottom: 5,
                                                          left: 7,
                                                          right: 7),
                                                      margin: EdgeInsets.only(
                                                          right: 5),
                                                      decoration: BoxDecoration(
                                                        color: ColorBase.red400,
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius: BorderRadius
                                                            .circular(Dimens
                                                                .dialogRadius),
                                                      ),
                                                      child: Text('Baru',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  FontsFamily
                                                                      .roboto,
                                                              fontSize: 10.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                    )
                                                  : Container(),
                                              Expanded(
                                                child: Text(
                                                  unixTimeStampToDateTime(
                                                      document['published_date']
                                                          .seconds),
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily:
                                                          FontsFamily.roboto,
                                                      fontSize: 10.0,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  textAlign: TextAlign.left,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
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
                    }),
              )
            ],
          )
        : Container();
  }

  bool isLabelNew(String id) {
    var data = dataLabel.where((test) => test.id.toLowerCase().contains(id));
    return data.isNotEmpty;
  }
}
