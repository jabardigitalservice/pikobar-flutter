import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/login/LoginScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';
import 'dart:convert';

class GroupHomeBanner extends StatefulWidget {
  @override
  _GroupHomeBannerState createState() => _GroupHomeBannerState();
}

class _GroupHomeBannerState extends State<GroupHomeBanner> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
      builder: (context, state) {
        return state is RemoteConfigLoaded
            ? _groupBannerContainer(state.remoteConfig)
            : Container();
      },
    );
  }

  Container _groupBannerContainer(RemoteConfig remoteConfig) {
    var groupBanner;
    if (remoteConfig.getString(FirebaseConfig.groupHomeBanner).isNotEmpty) {
      groupBanner =
          json.decode(remoteConfig.getString(FirebaseConfig.groupHomeBanner));
      return Container(
        child: Column(
          children: getGroupMenu(groupBanner, remoteConfig),
        ),
      );
    } else {
      return Container();
    }
  }

  List<Widget> getGroupMenu(
      List<dynamic> groupBanner, RemoteConfig remoteConfig) {
    List<Widget> list = List();

    for (int i = 0; i < groupBanner.length; i++) {
      Column column = Column(
        children: <Widget>[
          groupBanner[i]['enabled']
              ? Container(
                  height: 98.0,
                  padding: EdgeInsets.fromLTRB(
                      Dimens.padding, 0.0, Dimens.padding, Dimens.padding),
                  color: Colors.white,
                  child: RaisedButton(
                      splashColor: Colors.green,
                      padding: EdgeInsets.all(0.0),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          CachedNetworkImage(
                              imageUrl: groupBanner[i]['image'],
                              imageBuilder: (context, imageProvider) =>
                                  Image.network(groupBanner[i]['image']),
                              placeholder: (context, url) => Center(
                                  child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          topRight: Radius.circular(5.0)),
                                    ),
                                  )),
                          Expanded(
                              child: Container(
                            margin: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
                            child: Text(
                              groupBanner[i]['caption'],
                              style: TextStyle(
                                  fontFamily: FontsFamily.productSans,
                                  fontSize: 14.0,
                                  height: 1.2,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                          Container(
                              margin: EdgeInsets.only(right: 20.0),
                              child: Icon(Icons.chevron_right))
                        ],
                      ),
                      onPressed: () async {
                        bool hasToken = await AuthRepository().hasToken();
                        if (!hasToken) {
                          bool isLoggedIn = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen(
                                      title: Dictionary.checkDistribution)));

                          if (isLoggedIn != null && isLoggedIn) {
                            var url =
                                await userDataUrlAppend(groupBanner[i]['url']);
                            openChromeSafariBrowser(url: url);
                          }
                        } else {
                          var url =
                              await userDataUrlAppend(groupBanner[i]['url']);
                          openChromeSafariBrowser(url: url);
                        }
                      }),
                )
              : Container()
        ],
      );

      list.add(column);
    }
    return list;
  }
}
