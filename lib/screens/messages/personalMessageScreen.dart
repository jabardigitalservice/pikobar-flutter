import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/messages/messageList/Bloc.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/MessageModel.dart';
import 'package:pikobar_flutter/repositories/MessageRepository.dart';
import 'package:pikobar_flutter/screens/home/IndexScreen.dart';
import 'package:pikobar_flutter/screens/messages/messagesDetailSecreen.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:html/parser.dart';

class PersonalMessageScreen extends StatefulWidget {
  final IndexScreenState indexScreenState;

  PersonalMessageScreen({Key key, this.indexScreenState}) : super(key: key);

  @override
  State<PersonalMessageScreen> createState() => _PersonalMessageScreenState();
}

class _PersonalMessageScreenState extends State<PersonalMessageScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // AnalyticsHelper.setCurrentScreen(Analytics.message);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageListBloc>(
        create: (_) => MessageListBloc()
          ..add(MessageListLoad(
              collection: 'personal_broadcasts',
              indexScreenState: widget.indexScreenState,
              tableName: 'PersonalMessages')),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
        ));
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

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  _openDetail(
      MessageModel messageModel, int index, List<MessageModel> data) async {
    widget.indexScreenState.getCountMessage();
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MessageDetailScreen(
                id: messageModel.id,
                collection: 'personal_broadcasts',
                tableName: 'PersonalMessages',
              )),
    );
    setState(() {
      data[index].readAt = 1;
    });
  }
}
