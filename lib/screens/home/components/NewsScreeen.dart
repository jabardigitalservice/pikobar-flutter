import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/news/newsList/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/LabelNewScreen.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/NewsType.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/LabelNewModel.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';
import 'package:pikobar_flutter/screens/home/components/CovidInformationScreen.dart';
import 'package:pikobar_flutter/screens/news/News.dart';
import 'package:pikobar_flutter/screens/news/NewsDetailScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';

// ignore: must_be_immutable
class NewsScreen extends StatefulWidget {
  final String news;
  final int maxLength;
  final String searchQuery;
  CovidInformationScreenState covidInformationScreenState;

  NewsScreen(
      {Key key,
      @required this.news,
      this.maxLength,
      this.searchQuery,
      this.covidInformationScreenState})
      : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  NewsListBloc newsListBloc;
  List<LabelNewModel> dataLabel = [];
  bool isGetDataLabel = true;
  LabelNew labelNew;

  @override
  void initState() {
    labelNew = LabelNew();
    if (widget.maxLength != null) {
      newsListBloc = BlocProvider.of<NewsListBloc>(context);
      newsListBloc
          .add(NewsListLoad(NewsType.allArticles, statImportantInfo: true));
    }
    super.initState();
  }

  getDataLabel() {
    if (isGetDataLabel) {
      labelNew.getDataLabel(Dictionary.labelNews).then((value) {
        if (!mounted) return;
        setState(() {
          dataLabel = value;
        });
      });
      isGetDataLabel = false;
    }
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
      builder: (context, remoteState) {
        return remoteState is RemoteConfigLoaded
            ? _buildHeader(remoteState.remoteConfig)
            : Container();
      },
    );
  }

  Widget _buildHeader(RemoteConfig remoteConfig) {
    return BlocListener<NewsListBloc, NewsListState>(
        listener: (context, state) {
      if (state is NewsListLoaded) {
        isGetDataLabel = true;
        getDataLabel();
      }
    }, child: BlocBuilder<NewsListBloc, NewsListState>(
      builder: (context, state) {
        return state is NewsListLoaded
            ? widget.maxLength != null
                ? _buildContent(state.newsList, remoteConfig)
                : _buildContentList(state.newsList)
            : widget.maxLength != null
                ? _buildLoadingNew()
                : _buildLoading();
      },
    ));
  }

  _buildContent(List<NewsModel> list, RemoteConfig remoteConfig) {
    Map<String, dynamic> getLabel = RemoteConfigHelper.decode(
        remoteConfig: remoteConfig,
        firebaseConfig: FirebaseConfig.labels,
        defaultValue: FirebaseConfig.labelsDefaultValue);

    if (widget.searchQuery != null) {
      list = list
          .where((test) => test.title
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase()))
          .toList();

      if (list.isEmpty) {
        widget.covidInformationScreenState.isEmptyDataNews = true;
      }
    }
    return list.isNotEmpty
        ? Container(
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.only(
                        left: Dimens.padding,
                        right: Dimens.padding,
                        bottom: Dimens.padding),
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          getLabel['news']['title'],
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
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsListScreen(
                                    news: Dictionary.allNews,
                                    covidInformationScreenState:
                                        widget.covidInformationScreenState),
                              ),
                            ) as bool;

                            if (result) {
                              isGetDataLabel = result;
                              getDataLabel();
                            }

                            AnalyticsHelper.setLogEvent(Analytics.tappedMore);
                          },
                        ),
                      ],
                    )),
                Container(
                  height: 265,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                      padding: const EdgeInsets.only(
                          right: Dimens.padding, bottom: Dimens.padding),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length < widget.maxLength
                          ? list.length
                          : widget.maxLength,
                      itemBuilder: (context, index) {
                        NewsModel newsmodel = list[index];
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
                                      imageUrl: newsmodel.image ?? '',
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
                                        newsmodel.id,
                                        newsmodel.publishedAt.toString(),
                                        dataLabel,
                                        Dictionary.labelNews);
                                    if (widget.covidInformationScreenState !=
                                        null) {
                                      widget.covidInformationScreenState.widget
                                          .homeScreenState
                                          .getAllUnreadData();
                                    }
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(
                                          id: newsmodel.id,
                                          news: widget.news,
                                          model: list[index]),
                                    ),
                                  );
                                  AnalyticsHelper.setLogEvent(
                                      Analytics.tappedNewsDetail,
                                      <String, dynamic>{
                                        'title': newsmodel.title
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
                                              newsmodel.id,
                                              newsmodel.publishedAt.toString(),
                                              dataLabel,
                                              Dictionary.labelNews);
                                          if (widget
                                                  .covidInformationScreenState !=
                                              null) {
                                            widget.covidInformationScreenState
                                                .widget.homeScreenState
                                                .getAllUnreadData();
                                          }
                                        });

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                NewsDetailScreen(
                                                    id: newsmodel.id,
                                                    news: widget.news,
                                                    model: list[index]),
                                          ),
                                        );
                                        AnalyticsHelper.setLogEvent(
                                            Analytics.tappedNewsDetail,
                                            <String, dynamic>{
                                              'title': newsmodel.title
                                            });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              newsmodel.title,
                                              style: TextStyle(
                                                  fontSize:
                                                      Dimens.textSubtitleSize,
                                                  fontFamily:
                                                      FontsFamily.roboto,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                labelNew.isLabelNew(
                                                        newsmodel.id.toString(),
                                                        dataLabel)
                                                    ? LabelNewScreen()
                                                    : Container(),
                                                Expanded(
                                                  child: Text(
                                                    unixTimeStampToCustomDateFormat(
                                                        newsmodel.publishedAt,
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
            ),
          )
        : Container();
  }

  Widget designNewsHome(NewsModel data) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
          elevation: 0,
          color: Colors.white,
          onPressed: () async {
            setState(() {
              labelNew.readNewInfo(data.id, data.publishedAt.toString(),
                  dataLabel, Dictionary.labelNews);
              if (widget.covidInformationScreenState != null) {
                widget.covidInformationScreenState.widget.homeScreenState
                    .getAllUnreadData();
              }
            });

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailScreen(
                    id: data.id, news: widget.news, model: data),
              ),
            );

            AnalyticsHelper.setLogEvent(Analytics.tappedNewsDetail,
                <String, dynamic>{'title': data.title});
          },
          child: Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.news == Dictionary.importantInfo
                    ? Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 6),
                            width: 70,
                            height: 70,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                imageUrl: data.image,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                    heightFactor: 4.2,
                                    child: CupertinoActivityIndicator()),
                                errorWidget: (context, url, error) => Container(
                                    height: MediaQuery.of(context).size.height /
                                        3.3,
                                    color: Colors.grey[200],
                                    child: Image.asset(
                                        '${Environment.iconAssets}pikobar.png',
                                        fit: BoxFit.fitWidth)),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Image.asset(
                                '${Environment.imageAssets}label.png',
                                fit: BoxFit.fill,
                                width: 65.0,
                                height: 32.0),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 9, left: 5),
                            child: Text(
                              Dictionary.labelImportantInfo,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      )
                    : Container(
                        width: 70,
                        height: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: data.image,
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
                                    fit: BoxFit.fitWidth)),
                          ),
                        ),
                      ),
                Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  width: MediaQuery.of(context).size.width - 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.title,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      data.newsChannelIcon.isNotEmpty
                                          ? Image.network(
                                              data.newsChannelIcon,
                                              width: 25.0,
                                              height: 25.0,
                                            )
                                          : Container(),
                                      SizedBox(width: 3.0),
                                      Expanded(
                                        child: Text(
                                          data.newsChannel,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.grey),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
//                              Expanded(
//                                child:
                              widget.news != Dictionary.importantInfo
                                  ? Text(
                                      unixTimeStampToDateTime(data.publishedAt),
                                      style: TextStyle(
                                          fontSize: 10.0, color: Colors.grey),
                                    )
                                  : Container(),
//                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget designListNews(NewsModel data) {
    return Container(
        child: Column(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            elevation: 0,
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 35,
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: data.image,
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
                                    fit: BoxFit.fitWidth)),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 35,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.black12.withOpacity(0.2),
                          shape: BoxShape.rectangle,
                          borderRadius:
                              BorderRadius.circular(Dimens.dialogRadius),
                        ),
                      ),
                      Positioned(
                        left: 10,
                        right: 10,
                        bottom: 0,
                        top: 215,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                labelNew.isLabelNew(
                                        data.id.toString(), dataLabel)
                                    ? LabelNewScreen()
                                    : Container(),
                                Expanded(
                                  child: Text(
                                    unixTimeStampToDateTime(data.publishedAt),
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              data.title,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            onPressed: () async {
              setState(() {
                labelNew.readNewInfo(data.id, data.publishedAt.toString(),
                    dataLabel, Dictionary.labelNews);
                if (widget.covidInformationScreenState != null) {
                  widget.covidInformationScreenState.widget.homeScreenState
                      .getAllUnreadData();
                }
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailScreen(
                      id: data.id, news: widget.news, model: data),
                ),
              );
              AnalyticsHelper.setLogEvent(Analytics.tappedNewsDetail,
                  <String, dynamic>{'title': data.title});
            },
          ),
        ),
      ],
    ));
  }

  _buildContentList(List<NewsModel> list) {
    if (widget.searchQuery != null) {
      list = list
          .where((test) => test.title
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase()))
          .toList();
    }

    getDataLabel();
    return list.isNotEmpty
        ? ListView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.only(bottom: 10.0),
            itemBuilder: (BuildContext context, int index) {
              return designListNews(list[index]);
            },
          )
        : ListView(
            children: [
              EmptyData(
                message: Dictionary.emptyData,
                desc: Dictionary.descEmptyData,
                isFlare: false,
                image: "${Environment.imageAssets}not_found.png",
              )
            ],
          );
  }

  _buildLoading() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.maxLength != null ? widget.maxLength : 6,
            padding: const EdgeInsets.only(
                right: Dimens.padding,
                top: Dimens.padding,
                bottom: Dimens.padding),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: const EdgeInsets.only(left: Dimens.padding),
                height: 300.0,
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Skeleton(
                          width: MediaQuery.of(context).size.width - 40),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _buildLoadingNew() {
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
                      ],
                    ),
                  ],
                ));
          }),
    );
  }
}
