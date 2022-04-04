import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/authentication/Bloc.dart';
import 'package:pikobar_flutter/blocs/messages/messageList/Bloc.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/MessageModel.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/MessageRepository.dart';
import 'package:pikobar_flutter/screens/home/IndexScreen.dart';
import 'package:pikobar_flutter/screens/messages/messagesDetailSecreen.dart';
import 'package:pikobar_flutter/screens/myAccount/OnboardLoginScreen.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:html/parser.dart';

class PersonalMessageScreen extends StatefulWidget {
  final IndexScreenState indexScreenState;
  static bool isSecondTab = false;
  PersonalMessageScreen({Key key, this.indexScreenState, isSecondTab})
      : super(key: key);

  @override
  State<PersonalMessageScreen> createState() => _PersonalMessageScreenState();
}

class _PersonalMessageScreenState extends State<PersonalMessageScreen> {
  final ScrollController _scrollController = ScrollController();
  AuthenticationBloc _authenticationBloc;

  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    // AnalyticsHelper.setCurrentScreen(Analytics.message);
    setState(() {
      PersonalMessageScreen.isSecondTab = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
              create: (BuildContext context) => _authenticationBloc =
                  AuthenticationBloc(authRepository: _authRepository)
                    ..add(AppStarted())),
        ],
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
          if (state is AuthenticationFailure) {
            // Show an error message dialog when login,
            // except for errors caused by users who were canceled to login.
            if (!state.error.contains('ERROR_ABORTED_BY_USER') &&
                !state.error.contains('NoSuchMethodError')) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => DialogTextOnly(
                        description: state.error.toString(),
                        buttonText: "OK",
                        onOkPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                        },
                      ));
            }
            Scaffold.of(context).hideCurrentSnackBar();
          } else if (state is AuthenticationLoading) {
            // Show dialog when loading
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).primaryColor,
                content: Row(
                  children: <Widget>[
                    const CircularProgressIndicator(),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Text(Dictionary.loading),
                    )
                  ],
                ),
                duration: const Duration(seconds: 15),
              ),
            );
          } else {
            Scaffold.of(context).hideCurrentSnackBar();
          }
        }, child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (
            BuildContext context,
            AuthenticationState state,
          ) {
            if (state is AuthenticationUnauthenticated ||
                state is AuthenticationLoading) {
              // When user is not login show login screen
              return OnBoardingLoginScreen(
                authenticationBloc: _authenticationBloc,
                showTitle: false,
              );
            } else if (state is AuthenticationAuthenticated ||
                state is AuthenticationLoading) {
              // When user already login get data user from firestore

              return BlocProvider<MessageListBloc>(
                create: (_) => MessageListBloc()
                  ..add(MessageListLoad(
                      collection: 'personal_broadcasts',
                      indexScreenState: widget.indexScreenState,
                      tableName: 'PersonalMessages')),
                child: BlocBuilder<MessageListBloc, MessageListState>(
                  builder: (context, state) {
                    return state is MessageListLoaded
                        ? state.data.isEmpty
                            ? EmptyData(
                                message: Dictionary.emptyData,
                                desc: Dictionary.descEmptyData,
                                isFlare: false,
                                image:
                                    "${Environment.imageAssets}not_found.png",
                              )
                            : ListView.separated(
                                controller: _scrollController,
                                itemCount: state.data.length,
                                separatorBuilder: (context, index) {
                                  return Container(
                                    color: ColorBase.grey,
                                    height: 1,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  bool hasRead =
                                      state.data[index].readAt != null &&
                                          state.data[index].readAt != 0;

                                  if (MessageRepository.hasNullField(
                                      state.data[index])) {
                                    return Container();
                                  }

                                  return GestureDetector(
                                    child: Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                          vertical: Dimens.padding),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.only(
                                                  right: Dimens.padding),
                                              child: Stack(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: hasRead
                                                            ? 0.0
                                                            : 2.0),
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
                                                            decoration:
                                                                new BoxDecoration(
                                                              color: Colors.red,
                                                              shape: BoxShape
                                                                  .circle,
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
                                                      fontFamily:
                                                          FontsFamily.roboto,
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
                                                        state.data[index]
                                                            .publishedAt),
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color:
                                                          ColorBase.netralGrey,
                                                      fontFamily:
                                                          FontsFamily.roboto,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  _parseHtmlString(state
                                                      .data[index].content),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          FontsFamily.roboto,
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
                                      _openDetail(
                                          state.data[index], index, state.data);
                                    },
                                  );
                                },
                              )
                        : _buildLoading();
                  },
                ),
              );
            } else if (state is AuthenticationFailure ||
                state is AuthenticationLoading) {
              return OnBoardingLoginScreen(
                authenticationBloc: _authenticationBloc,
                showTitle: false,
              );
            } else {
              return Container();
            }
          },
        )));
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

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }
}
