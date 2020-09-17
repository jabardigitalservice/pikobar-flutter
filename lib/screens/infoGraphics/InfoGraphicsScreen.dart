import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/infographics/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/CustomBubbleTab.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/PikobarPlaceholder.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/infoGraphics/DetailInfoGraphicScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';

class InfoGraphicsScreen extends StatefulWidget {
  @override
  _InfoGraphicsScreenState createState() => _InfoGraphicsScreenState();
}

class _InfoGraphicsScreenState extends State<InfoGraphicsScreen> {
  InfoGraphicsListBloc _infoGraphicsListBloc = InfoGraphicsListBloc();

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
    AnalyticsHelper.setCurrentScreen(Analytics.infoGraphics);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.defaultAppBar(title: Dictionary.infoGraphics),
        body: MultiBlocProvider(
          providers: [
            BlocProvider<InfoGraphicsListBloc>(
              create: (context) => _infoGraphicsListBloc
                ..add(InfoGraphicsListLoad(
                    infoGraphicsCollection: kInfographics)),
            ),
          ],
          child: Container(
              child: CustomBubbleTab(
            listItemTitleTab: listItemTitleTab,
            indicatorColor: ColorBase.green,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            onTap: (index) {
              setState(() {});
              _infoGraphicsListBloc.add(InfoGraphicsListLoad(
                  infoGraphicsCollection: listCollectionData[index]));
              AnalyticsHelper.setLogEvent(analyticsData[index]);
            },
            tabBarView: <Widget>[
              _buildInfoGraphic(),
              _buildInfoGraphic(),
              _buildInfoGraphic(),
            ],
            heightTabBarView: MediaQuery.of(context).size.height - 148,
          )),
        ));
  }

  Widget _buildInfoGraphic() {
    return BlocBuilder<InfoGraphicsListBloc, InfoGraphicsListState>(
      builder: (context, state) {
        return state is InfoGraphicsListLoaded
            ? _buildContent(state.infoGraphicsList)
            : _buildLoading();
      },
    );
  }

  Widget _buildContent(List<DocumentSnapshot> listData) {
    return listData.isNotEmpty
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.7),
            shrinkWrap: true,
            itemCount: listData.length,
            padding: EdgeInsets.only(bottom: 20.0, left: 14.0),
            itemBuilder: (_, int index) {
              return _cardContent(listData[index]);
            },
          )
        : EmptyData(
            message: Dictionary.emptyData,
            desc: '',
            isFlare: false,
            image: "${Environment.imageAssets}not_found.png",
          );
  }

  _buildLoading() {
    return Container(
        child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 0.7),
      shrinkWrap: true,
      itemCount: 10,
      padding: EdgeInsets.only(bottom: 20.0, left: 5.0, right: 5.0),
      itemBuilder: (_, int index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 1.5,
          margin: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
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
                    left: 10.0, right: 14.0, top: 14.0, bottom: 14.0),
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
      },
    ));
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      DetailInfoGraphicScreen(dataInfoGraphic: data)));

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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DetailInfoGraphicScreen(dataInfoGraphic: data)));

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
                              Expanded(
                                child: Text(
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
                              )
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
