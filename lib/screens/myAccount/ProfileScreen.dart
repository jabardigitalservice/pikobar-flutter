import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:pikobar_flutter/blocs/authentication/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogQrCode.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/myAccount/OnboardLoginScreen.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/HexColor.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey _tooltipKey = GlobalKey();
  final AuthRepository _authRepository = AuthRepository();
  AuthenticationBloc _authenticationBloc;
  String _versionText = Dictionary.version;

  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _versionText = packageInfo.version != null
            ? packageInfo.version
            : Dictionary.version;
      });
    });
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
              showDialog(
                  context: context,
                  builder: (BuildContext context) => DialogTextOnly(
                        description: state.error.toString(),
                        buttonText: "OK",
                        onOkPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                        },
                      ));
              Scaffold.of(context).hideCurrentSnackBar();
            } else if (state is AuthenticationLoading) {
              Scaffold.of(context).showSnackBar(
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
              Scaffold.of(context).hideCurrentSnackBar();
            }
          },
          child: Scaffold(
              appBar: CustomAppBar.defaultAppBar(title: Dictionary.profile),
              body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (
                  BuildContext context,
                  AuthenticationState state,
                ) {
                  if (state is AuthenticationUnauthenticated ||
                      state is AuthenticationLoading) {
                    return OnBoardingLoginScreen(
                      authenticationBloc: _authenticationBloc,
                    );
                  } else if (state is AuthenticationAuthenticated ||
                      state is AuthenticationLoading) {
                    AuthenticationAuthenticated _profileLoaded =
                        state as AuthenticationAuthenticated;
                    return StreamBuilder<DocumentSnapshot>(
                        stream: Firestore.instance
                            .collection('users')
                            .document(_profileLoaded.record.uid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError)
                            return ErrorContent(error: snapshot.error);
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            default:
                              return snapshot.data.exists
                                  ? _buildContent(snapshot, _profileLoaded)
                                  : Center(
                                      child: CircularProgressIndicator(),
                                    );
                          }
                        });
                  } else {
                    return Container();
                  }
                },
              )),
        ));
  }

  Widget _buildContent(AsyncSnapshot<DocumentSnapshot> state,
      AuthenticationAuthenticated _profileLoaded) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              Container(
                width: 98,
                height: 98,
                child: CircleAvatar(
                  minRadius: 90,
                  maxRadius: 150,
                  backgroundImage: (_profileLoaded.record.photoUrlFull) != null
                      ? NetworkImage(_profileLoaded.record.photoUrlFull)
                      : ExactAssetImage('${Environment.imageAssets}user.png'),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                height: 98,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 30.0,
                      child: Text(
                        state.data['name'],
                        style: TextStyle(
                            color: Color(0xff4F4F4F),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 30.0,
                      child: Text(_profileLoaded.record.email,
                          style: TextStyle(
                            color: Color(0xff828282),
                            fontSize: 14,
                          )),
                    ),
                    state.data != null
                        ? _healthStatus(state.data)
                        : SizedBox(height: 38.0),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogQrCode(idUser: state.data['id']);
                  });
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                height: 20,
                                child: Image.asset(
                                    '${Environment.iconAssets}qr-code.png')),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              Dictionary.qrCodeMenu,
                              style: TextStyle(color: Color(0xff4F4F4F)),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xff828282),
                          size: 15,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _buildGroupMenu(state.data),
          SizedBox(
            height: 10,
          ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, NavigationConstrants.Edit,
                          arguments: state);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                height: 20,
                                child: Image.asset(
                                    '${Environment.iconAssets}edit.png')),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              Dictionary.edit,
                              style: TextStyle(color: Color(0xff4F4F4F)),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xff828282),
                          size: 15,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                              height: 20,
                              child: Image.asset(
                                  '${Environment.iconAssets}versionLogo.png')),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            Dictionary.versionText,
                            style: TextStyle(color: Color(0xff4F4F4F)),
                          ),
                        ],
                      ),
                      Text(
                        _versionText + ' ' + Dictionary.betaText,
                        style: TextStyle(color: Color(0xff828282)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Color(0xffEB5757),
              onPressed: () {
                _authenticationBloc.add(LoggedOut());
              },
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      Dictionary.textLogoutButton,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))),
              ),
            ),
          )
        ],
      ),
    ));
  }

  FutureBuilder<RemoteConfig> _healthStatus(DocumentSnapshot data) {
    Color cardColor = ColorBase.grey;
    Color textColor = Colors.white;
    String uriImage = '${Environment.iconAssets}sthetoscope.png';

    return FutureBuilder<RemoteConfig>(
        future: setupRemoteConfig(),
        builder: (BuildContext context, AsyncSnapshot<RemoteConfig> snapshot) {
          bool visible = snapshot.data != null &&
                  snapshot.data.getBool(FirebaseConfig.healthStatusVisible) !=
                      null
              ? snapshot.data.getBool(FirebaseConfig.healthStatusVisible)
              : false;

          if (snapshot.data != null &&
              snapshot.data.getString(FirebaseConfig.healthStatusColors) !=
                  null &&
              data['health_status'] != null) {
            Map<String, dynamic> healthStatusColor = json.decode(
                snapshot.data.getString(FirebaseConfig.healthStatusColors));

            switch (data['health_status']) {
              case "HEALTHY":
                cardColor = HexColor.fromHex(
                    healthStatusColor['healthy'] != null
                        ? healthStatusColor['healthy']
                        : ColorBase.green);
                break;

              case "ODP":
                cardColor = HexColor.fromHex(healthStatusColor['odp'] != null
                    ? healthStatusColor['odp']
                    : Colors.yellow);
                textColor = Colors.black;
                uriImage = '${Environment.iconAssets}sthetoscope_black.png';
                break;

              case "PDP":
                cardColor = HexColor.fromHex(healthStatusColor['pdp'] != null
                    ? healthStatusColor['pdp']
                    : Colors.orange);
                textColor = Colors.black;
                uriImage = '${Environment.iconAssets}sthetoscope_black.png';
                break;

              case "CONFIRMED":
                cardColor = HexColor.fromHex(
                    healthStatusColor['confirmed'] != null
                        ? healthStatusColor['confirmed']
                        : Colors.red);
                break;

              default:
                cardColor = Colors.grey;
            }
          }

          return visible && data['health_status_text'] != null
              ? Container(
                  decoration: BoxDecoration(
                      color: cardColor, borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(height: 12, child: Image.asset(uriImage)),
                            SizedBox(width: 5),
                            Text(
                                Dictionary.statusUser +
                                    data['health_status_text'],
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                )),
                          ],
                        ),
                        data['health_status_check'] != null
                            ? Text(
                                unixTimeStampToDateTimeWithoutDay(
                                    data['health_status_check'].seconds),
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 10,
                                ))
                            : Container(),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: 38.0,
                );
        });
  }

  FutureBuilder<RemoteConfig> _buildGroupMenu(DocumentSnapshot data) {
    return FutureBuilder<RemoteConfig>(
        future: setupRemoteConfig(),
        builder: (BuildContext context, AsyncSnapshot<RemoteConfig> snapshot) {
          var groupMenu;
          if (snapshot.data != null) {
            groupMenu = json.decode(
                snapshot.data.getString(FirebaseConfig.groupMenuProfile));
          }

          return snapshot.data != null
              ? Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(children: getGroupMenu(groupMenu, data))))
              : Container();
        });
  }

  List<Widget> getGroupMenu(List<dynamic> groupMenu, DocumentSnapshot data) {
    List<Widget> list = List();
    String role;
    if (data['role'] == null) {
      role = 'public';
    } else {
      role = data['role'];
    }
    groupMenu.removeWhere((element) => element['role']!=role);
    for (int i = 0; i < groupMenu.length; i++) {
      Column column = Column(
        children: <Widget>[
           Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        var url = await userDataUrlAppend(groupMenu[i]['url']);
                        openChromeSafariBrowser(url: url);
                        print(url);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                  height: 20,
                                  child: Image.network(groupMenu[i]['icon'])),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                groupMenu[i]['caption'],
                                style: TextStyle(color: Color(0xff4F4F4F)),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xff828282),
                            size: 15,
                          )
                        ],
                      ),
                    ),
                    i==groupMenu.length-1
                        ? Container()
                        : Column(
                            children: <Widget>[
                              SizedBox(
                                height: 5,
                              ),
                              Divider(),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          )
                  ],
                )
              
        ],
      );

      list.add(column);
    }
    return list;
  }

  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    remoteConfig.setDefaults(<String, dynamic>{
      FirebaseConfig.healthStatusVisible: false,
      FirebaseConfig.healthStatusColors: ColorBase.healthStatusColors,
      FirebaseConfig.groupMenuProfile: false
    });

    try {
      await remoteConfig.fetch(expiration: Duration(minutes: 5));
      await remoteConfig.activateFetched();
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }

    return remoteConfig;
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }
}
