import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/MessageModel.dart';
import 'package:pikobar_flutter/repositories/MessageRepository.dart';
import 'package:pikobar_flutter/screens/home/IndexScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:html/parser.dart';

class Messages extends StatefulWidget {
  final IndexScreenState indexScreenState;

  Messages({this.indexScreenState});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  ScrollController _scrollController = ScrollController();
  List<MessageModel> listMessage = [];
  bool isInsertData = false;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.message);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.defaultAppBar(
            title: Dictionary.message,
            actions: <Widget>[
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text(Dictionary.markAsRead),
                  ),
                ],
                initialValue: 1,
                onCanceled: () {},
                onSelected: (value) async {
                  if (value == 1) {
                    await MessageRepository().updateAllReadData();
                    widget.indexScreenState.getCountMessage();
                    setState(() {
                      for (int i = 0; i < listMessage.length; i++) {
                        listMessage[i].readAt = 1;
                      }
                    });
                  }
                },
                icon: Icon(Icons.more_vert),
              ),
            ]),
        body: !isInsertData
            ? StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('broadcasts')
                    .orderBy('published_at', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return ErrorContent(error: snapshot.error);
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return _buildLoading();
                    default:
                      if (!isInsertData) {
                        insertIntoDatabase(snapshot);
                      }
                      isInsertData = true;
                      return _buildContent();
                  }
                },
              )
            : _buildContent());
  }

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  _buildLoading() {
    return ListView.builder(
      itemCount: 5,
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
                          height: 20.0),
                      Skeleton(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 20.0,
                            margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                            color: Colors.grey[300]),
                      ),
                      Skeleton(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 20.0,
                            margin: EdgeInsets.only(bottom: 5.0),
                            color: Colors.grey[300]),
                      ),
                      Skeleton(
                        child: Container(
                            width: MediaQuery.of(context).size.width - 170,
                            height: 20.0,
                            margin: EdgeInsets.only(bottom: 15.0),
                            color: Colors.grey[300]),
                      ),
                      Skeleton(
                          width: MediaQuery.of(context).size.width - 250,
                          height: 15.0),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> insertIntoDatabase(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await MessageRepository().insertToDatabase(snapshot.data.documents);
    widget.indexScreenState.getCountMessage();
    listMessage.clear();
    listMessage = await MessageRepository().getRecords();
    setState(() {});
  }

  _buildContent() {
    return listMessage.isNotEmpty
        ? ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(15.0),
            itemCount: listMessage.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: GestureDetector(
                  child: Card(
                      color: listMessage[index].readAt == null ||
                              listMessage[index].readAt == 0
                          ? Color(0xFFFFF9EE)
                          : null,
                      margin: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
                      elevation: 0.5,
                      child: Container(
                        margin: EdgeInsets.all(15.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(right: 10.0, top: 5.0),
                                child: Image.asset(
                                  '${Environment.iconAssets}broadcast.png',
                                  width: 24.0,
                                  height: 24.0,
                                )),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    listMessage[index].title,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0xff4F4F4F),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 8.0, bottom: 15.0),
                                    child: Text(
                                      _parseHtmlString(
                                          listMessage[index].content),
                                      maxLines: 3,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Color(0xff828282)),
                                    ),
                                  ),
                                  Text(
                                    unixTimeStampToDateTime(
                                        listMessage[index].pubilshedAt),
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: Color(0xffBDBDBD)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  onTap: () {
                    _openDetail(listMessage[index], index);
                  },
                ),
              );
            },
          )
        : _buildLoading();
  }

  _openDetail(MessageModel messageModel, int index) async {
    await MessageRepository().updateReadData(messageModel.title);
    widget.indexScreenState.getCountMessage();
    await Navigator.pushNamed(context, NavigationConstrants.BroadcastDetail,
        arguments: messageModel);
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
