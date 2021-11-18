import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/MessageModel.dart';
import 'package:pikobar_flutter/repositories/MessageRepository.dart';
import 'package:pikobar_flutter/screens/home/IndexScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';

class Messages extends StatefulWidget {
  final IndexScreenState indexScreenState;

  Messages({Key key, this.indexScreenState}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  ScrollController _scrollController = ScrollController();
  List<MessageModel> listMessage = [];

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.message);
    getDataFromServer();
    super.initState();
  }

  void getDataFromServer() {
    FirebaseFirestore.instance
        .collection('broadcasts')
        .orderBy('published_at', descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      insertIntoDatabase(snapshot);
    }).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FutureBuilder<int>(
            future: MessageRepository().hasUnreadData(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != 0) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: RaisedButton(
                    color: ColorBase.primaryLightGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: ColorBase.primaryGreen)),
                    onPressed: () async {
                      await AnalyticsHelper.setLogEvent(
                          Analytics.tappedReadAllMessage);
                      await MessageRepository().updateAllReadData();
                      widget.indexScreenState.getCountMessage();
                      setState(() {
                        for (int i = 0; i < listMessage.length; i++) {
                          listMessage[i].readAt = 1;
                        }
                      });
                    },
                    child: Text(
                      Dictionary.markAsRead,
                      style: TextStyle(
                          color: ColorBase.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsFamily.roboto,
                          fontSize: 11),
                    ),
                  ),
                );
              }
              return Container();
            }),
        appBar: CustomAppBar.animatedAppBar(
            title: Dictionary.message, showTitle: true, fontSize: 20),
        body: _buildContent());
  }

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  _buildLoading() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => Card(
          margin: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
          elevation: 0.2,
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 10.0, top: 5.0),
                    child: Skeleton(
                      width: 24.0,
                      height: 24.0,
                    )),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Skeleton(
                          width: MediaQuery.of(context).size.width,
                          height: 10.0),
                      Skeleton(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 10.0,
                            margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                            color: Colors.grey[300]),
                      ),
                      Skeleton(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 10.0,
                            margin: EdgeInsets.only(bottom: 5.0),
                            color: Colors.grey[300]),
                      ),
                      Skeleton(
                        child: Container(
                            width: MediaQuery.of(context).size.width - 170,
                            height: 10.0,
                            margin: EdgeInsets.only(bottom: 15.0),
                            color: Colors.grey[300]),
                      ),
                      Skeleton(
                          width: MediaQuery.of(context).size.width - 250,
                          height: 10.0),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> insertIntoDatabase(QuerySnapshot snapshot) async {
    await MessageRepository().insertToDatabase(snapshot.docs);
    widget.indexScreenState.getCountMessage();
    listMessage.clear();
    listMessage = await MessageRepository().getRecords();
  }

  _buildContent() {
    return listMessage.isNotEmpty
        ? ListView.separated(
            controller: _scrollController,
            itemCount: listMessage.length,
            separatorBuilder: (context, index) {
              return Container(
                color: ColorBase.grey,
                height: 1,
                margin: EdgeInsets.symmetric(horizontal: Dimens.padding),
              );
            },
            itemBuilder: (context, index) {
              bool hasRead = listMessage[index].readAt != null &&
                  listMessage[index].readAt != 0;

              if (MessageRepository.hasNullField(listMessage[index])) {
                return Container();
              }

              return GestureDetector(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(Dimens.padding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: Dimens.padding),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.only(top: hasRead ? 0.0 : 2.0),
                                child: Image.asset(
                                  '${Environment.iconAssets}broadcast.png',
                                  width: 32.0,
                                  height: 32.0,
                                ),
                              ),
                              hasRead
                                  ? Container()
                                  : Positioned(
                                      right: 0.0,
                                      child: Container(
                                        width: 12.0,
                                        height: 12.0,
                                        decoration: new BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    )
                            ],
                          )),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              listMessage[index].title,
                              style: TextStyle(
                                  fontFamily: FontsFamily.roboto,
                                  fontSize: 14.0,
                                  height: Dimens.lineHeight,
                                  color: ColorBase.grey800,
                                  fontWeight: hasRead
                                      ? FontWeight.w400
                                      : FontWeight.w700),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 8.0, bottom: 13.0),
                              child: Text(
                                unixTimeStampToDateTime(
                                    listMessage[index].publishedAt),
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: ColorBase.netralGrey,
                                  fontFamily: FontsFamily.roboto,
                                ),
                              ),
                            ),
                            Text(
                              _parseHtmlString(listMessage[index].content),
                              maxLines: 3,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontFamily: FontsFamily.roboto,
                                  fontSize: 12.0,
                                  height: Dimens.lineHeight,
                                  color: hasRead
                                      ? ColorBase.netralGrey
                                      : ColorBase.grey800),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _openDetail(listMessage[index], index);
                },
              );
            },
          )
        : _buildLoading();
  }

  _openDetail(MessageModel messageModel, int index) async {
    widget.indexScreenState.getCountMessage();
    await Navigator.pushNamed(context, NavigationConstrants.BroadcastDetail,
        arguments: messageModel.id);
    setState(() {
      listMessage[index].readAt = 1;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
