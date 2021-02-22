import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/infographics/infographicslist/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/LabelNewScreen.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
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
import 'package:pikobar_flutter/utilities/LabelNew.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';

// ignore: must_be_immutable
class InfoGraphics extends StatefulWidget {
  final String searchQuery;
  CovidInformationScreenState covidInformationScreenState;

  InfoGraphics({Key key, this.searchQuery, this.covidInformationScreenState})
      : super(key: key);

  @override
  _InfoGraphicsState createState() => _InfoGraphicsState();
}

class _InfoGraphicsState extends State<InfoGraphics> {
  InfoGraphicsListBloc infoGraphicsListBloc;
  bool isGetDataLabel = true;
  LabelNew labelNew;
  List<LabelNewModel> dataLabel = [];

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
    labelNew = LabelNew();
    infoGraphicsListBloc = BlocProvider.of<InfoGraphicsListBloc>(context);
    infoGraphicsListBloc.add(InfoGraphicsListLoad(
        infoGraphicsCollection: kAllInfographics, limit: 5));
    super.initState();
  }

  getDataLabel() {
    if (isGetDataLabel) {
      labelNew.getDataLabel(Dictionary.labelInfoGraphic).then((value) {
        if (!mounted) return;
        setState(() {
          dataLabel = value;
        });
      });
      isGetDataLabel = false;
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
                        fontFamily: FontsFamily.roboto,
                        fontSize: 16.0),
                  ),
                  InkWell(
                    child: Text(
                      Dictionary.more,
                      style: TextStyle(
                          color: ColorBase.green,
                          fontWeight: FontWeight.w600,
                          fontFamily: FontsFamily.roboto,
                          fontSize: Dimens.textSubtitleSize),
                    ),
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                              context, NavigationConstrants.InfoGraphics,
                              arguments: widget.covidInformationScreenState)
                          as bool;
                      if (result) {
                        isGetDataLabel = result;
                        getDataLabel();
                      }

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
                    fontFamily: FontsFamily.roboto,
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
    return BlocListener<InfoGraphicsListBloc, InfoGraphicsListState>(
        listener: (context, state) {
      if (state is InfoGraphicsListLoaded) {
        getDataLabel();
      }
    }, child: BlocBuilder<InfoGraphicsListBloc, InfoGraphicsListState>(
      builder: (context, state) {
        return state is InfoGraphicsListLoaded
            ? _buildContent(state.infoGraphicsList, getLabel)
            : _buildLoading();
      },
    ));
  }

  Widget _buildLoading() {
    return Container(
      height: 265,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          padding: const EdgeInsets.only(
              right: Dimens.padding,
              top: Dimens.padding,
              bottom: Dimens.padding),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
                width: 150.0,
                height: 150.0,
                padding: const EdgeInsets.only(left: Dimens.padding),
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
                          fontFamily: FontsFamily.roboto,
                          fontSize: Dimens.textTitleSize),
                    ),
                    InkWell(
                      child: Text(
                        Dictionary.more,
                        style: TextStyle(
                            color: ColorBase.green,
                            fontWeight: FontWeight.w600,
                            fontFamily: FontsFamily.roboto,
                            fontSize: Dimens.textSubtitleSize),
                      ),
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                                context, NavigationConstrants.InfoGraphics,
                                arguments: widget.covidInformationScreenState)
                            as bool;
                        if (result) {
                          isGetDataLabel = result;
                          getDataLabel();
                        }

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
                    padding: const EdgeInsets.only(
                        right: Dimens.padding, bottom: Dimens.padding),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.searchQuery != null
                        ? listData.length
                        : listData.length < 5
                            ? listData.length
                            : 5,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot document = listData[index];
                      return Container(
                        padding: EdgeInsets.only(left: Dimens.padding),
                        width: 150.0,
                        height: 150.0,
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
                              onTap: () async {
                                setState(() {
                                  labelNew.readNewInfo(
                                      document.id,
                                      document['published_date']
                                          .seconds
                                          .toString(),
                                      dataLabel,
                                      Dictionary.labelInfoGraphic);
                                  widget.covidInformationScreenState.widget
                                      .homeScreenState
                                      .getAllUnreadData();
                                });
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
                                    onTap: () async {
                                      setState(() {
                                        labelNew.readNewInfo(
                                            document.id,
                                            document['published_date']
                                                .seconds
                                                .toString(),
                                            dataLabel,
                                            Dictionary.labelInfoGraphic);
                                        widget.covidInformationScreenState
                                            .widget.homeScreenState
                                            .getAllUnreadData();
                                      });
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
                                                fontSize:
                                                    Dimens.textSubtitleSize,
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
                                              labelNew.isLabelNew(
                                                      document.id.toString(),
                                                      dataLabel)
                                                  ? LabelNewScreen()
                                                  : Container(),
                                              Expanded(
                                                child: Text(
                                                  unixTimeStampToCustomDateFormat(
                                                      document['published_date']
                                                          .seconds,
                                                      'EEEE, dd MMM yyyy'),
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
}
