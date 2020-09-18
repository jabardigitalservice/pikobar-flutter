import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/news/newsList/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/RemoteConfigBloc.dart';
import 'package:pikobar_flutter/components/CustomBubbleTab.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/screens/home/components/NewsScreeen.dart';
import 'package:pikobar_flutter/screens/news/News.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';
import 'package:pikobar_flutter/utilities/StatShowImportantInfo.dart';

// ignore: must_be_immutable
class TabNewsScreen extends StatefulWidget {
  @override
  _TabNewsScreenState createState() => _TabNewsScreenState();
}

class _TabNewsScreenState extends State<TabNewsScreen> {
  NewsListBloc newsListBloc;
  bool checkInitTypeNews = true;
  List<String> listItemTitleTab = [
    Dictionary.importantInfo,
    Dictionary.latestNews,
    Dictionary.nationalNews,
    Dictionary.worldNews
  ];

  List<String> listCollectionData = [
    kImportantInfor,
    kNewsJabar,
    kNewsNational,
    kNewsWorld
  ];

  List<String> analyticsData = [
    Analytics.tappedImportantInfo,
    Analytics.tappedNewsJabar,
    Analytics.tappedNewsNational,
    Analytics.tappedNewsWorld,
  ];

  buildContent(RemoteConfigLoaded state) {
    if (checkInitTypeNews) {
      if (!StatShowImportantInfo.getStatImportantTab(state)) {
        listItemTitleTab.removeAt(0);
        listCollectionData.removeAt(0);
        analyticsData.removeAt(0);
        newsListBloc.add(NewsListLoad(kNewsJabar));
        checkInitTypeNews = false;
      } else {
        newsListBloc.add(NewsListLoad(kImportantInfor));
        checkInitTypeNews = false;
      }
    }
    Map<String, dynamic> getLabel =
    RemoteConfigHelper.decode(remoteConfig: state.remoteConfig, firebaseConfig: FirebaseConfig.labels, defaultValue: FirebaseConfig.labelsDefaultValue);
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(
                  left: Dimens.padding,
                  right: Dimens.padding,
                  top: Dimens.padding),
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    getLabel['news']['title'],
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewsListScreen(news: Dictionary.allNews),
                        ),
                      );
                      AnalyticsHelper.setLogEvent(Analytics.tappedMore);
                    },
                  ),
                ],
              )),
          Container(
            padding: EdgeInsets.only(
                left: Dimens.padding, right: Dimens.padding, top: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              getLabel['news']['description'],
              style: TextStyle(
                color: Colors.black,
                fontFamily: FontsFamily.lato,
                fontSize: 12.0,
              ),
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
                  newsListBloc.add(NewsListLoad(listCollectionData[index]));
                  AnalyticsHelper.setLogEvent(analyticsData[index]);
                },
                tabBarView: <Widget>[
                  if (StatShowImportantInfo.getStatImportantTab(state))
                    NewsScreen(news: Dictionary.importantInfo, maxLength: 3),
                  NewsScreen(news: Dictionary.latestNews, maxLength: 3),
                  NewsScreen(news: Dictionary.nationalNews, maxLength: 3),
                  NewsScreen(news: Dictionary.worldNews, maxLength: 3),
                ],
                heightTabBarView: 320,
                paddingTopTabBarView: 10,
              )),
        ],
      ),
    );
  }

  @override
  void initState() {
    newsListBloc = BlocProvider.of<NewsListBloc>(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
        builder: (context, state) {
      return state is RemoteConfigLoaded ? buildContent(state) : Container();
    });
  }
}
