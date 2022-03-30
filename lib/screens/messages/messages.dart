import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart';
import 'package:pikobar_flutter/blocs/messages/messageList/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/CustomBubbleTab.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/MessageModel.dart';
import 'package:pikobar_flutter/repositories/MessageRepository.dart';
import 'package:pikobar_flutter/screens/home/IndexScreen.dart';
import 'package:pikobar_flutter/screens/messages/messagesDetailSecreen.dart';
import 'package:pikobar_flutter/screens/messages/personalMessageScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';

class Messages extends StatefulWidget {
  final IndexScreenState indexScreenState;

  Messages({Key key, this.indexScreenState}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final ScrollController _scrollController = ScrollController();
  List<MessageModel> listMessage = [];

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.message);
    super.initState();
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
                    await MessageRepository().updateAllReadData('Messages');
                    await MessageRepository()
                        .updateAllReadData('PersonalMessages');
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
        child: CustomBubbleTab(
          titleHeader: Dictionary.message,
          listItemTitleTab: ['General', 'Personal'],
          indicatorColor: ColorBase.green,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          scrollController: _scrollController,
          onTap: (index) {
            setState(() {});
          },
          tabBarView: [
            _buildContent(),
            PersonalMessageScreen(
              indexScreenState: widget.indexScreenState,
            )
          ],
          isExpand: true,
        ),
      ),
    );
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
            margin: EdgeInsets.symmetric(vertical: 15.0),
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

  _buildContent() {
    return BlocProvider<MessageListBloc>(
        create: (_) => MessageListBloc()
          ..add(MessageListLoad(
              collection: 'broadcasts',
              indexScreenState: widget.indexScreenState,
              tableName: 'Messages')),
        child: BlocListener<MessageListBloc, MessageListState>(
          listener: (BuildContext context, MessageListState state) {
            if (state is MessageListLoaded) {
              setState(() {
                listMessage = state.data;
              });
            }
          },
          child: BlocBuilder<MessageListBloc, MessageListState>(
            builder: (context, state) {
              return state is MessageListLoaded
                  ? ListView.separated(
                      controller: _scrollController,
                      itemCount: state.data.length,
                      separatorBuilder: (context, index) {
                        return Container(
                          color: ColorBase.grey,
                          height: 1,
                        );
                      },
                      itemBuilder: (context, index) {
                        bool hasRead = state.data[index].readAt != null &&
                            state.data[index].readAt != 0;

                        if (MessageRepository.hasNullField(state.data[index])) {
                          return Container();
                        }

                        return GestureDetector(
                          child: Container(
                            color: Colors.white,
                            padding:
                                EdgeInsets.symmetric(vertical: Dimens.padding),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    margin:
                                        EdgeInsets.only(right: Dimens.padding),
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: hasRead ? 0.0 : 2.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        state.data[index].title,
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
                                        margin: EdgeInsets.only(
                                            top: 8.0, bottom: 13.0),
                                        child: Text(
                                          unixTimeStampToDateTime(
                                              state.data[index].publishedAt),
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: ColorBase.netralGrey,
                                            fontFamily: FontsFamily.roboto,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        _parseHtmlString(
                                            state.data[index].content),
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
                            _openDetail(state.data[index], index, state.data);
                          },
                        );
                      },
                    )
                  : _buildLoading();
            },
          ),
        ));
  }

  _openDetail(
      MessageModel messageModel, int index, List<MessageModel> data) async {
    widget.indexScreenState.getCountMessage();
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MessageDetailScreen(
                id: messageModel.id,
                collection: 'broadcasts',
                tableName: 'Messages',
              )),
    );

    setState(() {
      data[index].readAt = 1;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
