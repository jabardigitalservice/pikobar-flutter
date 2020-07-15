import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/authentication/Bloc.dart';
import 'package:pikobar_flutter/components/Announcement.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/myAccount/OnboardLoginScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';
import 'package:shimmer/shimmer.dart';

class SurveysScreen extends StatefulWidget {
  @override
  _SurveysScreenState createState() => _SurveysScreenState();
}

class _SurveysScreenState extends State<SurveysScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AuthRepository _authRepository = AuthRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.survey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
        create: (BuildContext context) => _authenticationBloc =
            AuthenticationBloc(authRepository: _authRepository)
              ..add(AppStarted()),
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationFailure) {
              if (!state.error.contains('ERROR_ABORTED_BY_USER') && !state.error.contains('NoSuchMethodError')) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        DialogTextOnly(
                          description: state.error.toString(),
                          buttonText: "OK",
                          onOkPressed: () {
                            Navigator.of(context).pop(); // To close the dialog
                          },
                        ));
              }
              _scaffoldKey.currentState.hideCurrentSnackBar();
            } else if (state is AuthenticationLoading) {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  content: Row(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Container(
                        margin: EdgeInsets.only(left: 15.0),
                        child: Text(Dictionary.loading),
                      )
                    ],
                  ),
                  duration: Duration(seconds: 5),
                ),
              );
            } else {
              _scaffoldKey.currentState.hideCurrentSnackBar();
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar.defaultAppBar(
              title: Dictionary.survey,
            ),
            body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (
                BuildContext context,
                AuthenticationState state,
              ) {
                if (state is AuthenticationUnauthenticated ||
                    state is AuthenticationLoading) {
                  return OnBoardingLoginScreen(
                    authenticationBloc: _authenticationBloc,
                    positionBottom: 20.0,
                  );
                } else if (state is AuthenticationAuthenticated ||
                    state is AuthenticationLoading) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection(Collections.surveys)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.documents.isNotEmpty) {
                          return _buildContent(snapshot);
                        } else {
                          return EmptyData(message: 'Tidak ada data survei');
                        }
                      } else {
                        return _buildLoading();
                      }
                    },
                  );
                } else if (state is AuthenticationFailure ||
                    state is AuthenticationLoading) {
                  return OnBoardingLoginScreen(
                    authenticationBloc: _authenticationBloc,
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ));
  }

  _buildLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(15.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width - 65,
                            height: 20.0,
                            color: Colors.grey[300]),
                        SizedBox(height: 5.0),
                        Container(
                            width: MediaQuery.of(context).size.width - 65,
                            height: 20.0,
                            color: Colors.grey[300]),
                        SizedBox(height: 5.0),
                        Container(
                            width: 150.0, height: 20.0, color: Colors.grey[300]),
                      ],
                    ),
                  ),

                  Skeleton(child: Icon(Icons.chevron_right))

                ],
              )),

          Container(
            height: 10.0,
            color: ColorBase.grey,
          )
        ],
      ),
    );
  }

  _buildContent(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
      margin: EdgeInsets.symmetric(
                vertical: 10, horizontal: 10),
            child: Announcement(
              content: Dictionary.surveyInfo,
              textStyleContent: TextStyle(
                  fontFamily: FontsFamily.lato,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  height: 1.5),
            ),
          ),
          Container(
            child: ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final DocumentSnapshot document =
                      snapshot.data.documents[index];

                  return Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.all(Dimens.padding),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 25.0),
                                  child: Text(document['title'],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: FontsFamily.lato,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                ),
                              ),
                              Icon(Icons.chevron_right)
                            ],
                          ),
                        ),
                        onTap: () {
                          openChromeSafariBrowser(url: document['url']);
                        },
                      ),
                      Container(
                        height: 10.0,
                        color: ColorBase.grey,
                      )
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }
}
