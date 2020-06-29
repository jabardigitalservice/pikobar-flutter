import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:pikobar_flutter/blocs/authentication/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogQrCode.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/screens/myAccount/OnboardLoginScreen.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/HexColor.dart';
import 'package:pikobar_flutter/utilities/OpenChromeSapariBrowser.dart';

import 'TermsConditions.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthRepository _authRepository = AuthRepository();
  AuthenticationBloc _authenticationBloc;
  String _versionText = Dictionary.version;
  RemoteConfigBloc _remoteConfigBloc;

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
    return MultiBlocProvider(
        providers: [
          BlocProvider<RemoteConfigBloc>(
              create: (BuildContext context) => _remoteConfigBloc =
                  RemoteConfigBloc()..add(RemoteConfigLoad())),
          BlocProvider<AuthenticationBloc>(
              create: (BuildContext context) => _authenticationBloc =
                  AuthenticationBloc(authRepository: _authRepository)
                    ..add(AppStarted())),
        ],
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
              backgroundColor: Color(0xffFFFFFF),
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
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 30.0,
                      child: Text(
                        state.data['name'],
                        style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.lato),
                      ),
                    ),
                    Container(
                      height: 30.0,
                      child: Text(_profileLoaded.record.email,
                          style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 14,
                              fontFamily: FontsFamily.lato)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
          bloc: _remoteConfigBloc,
          builder: (context, remoteState) {
            return remoteState is RemoteConfigLoaded
                ? _buildHealthStatus(remoteState.remoteConfig, state.data)
                : Container();
          },
        ),
        SizedBox(
          height: 15,
          child: Container(
            color: ColorBase.grey,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 10),
          child: Text(Dictionary.qrCode,
              style: TextStyle(
                  color: Color(0xff333333),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: FontsFamily.lato)),
        ),
        InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DialogQrCode(idUser: state.data['id']);
                });
          },
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xffE0E0E0))),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: FontsFamily.lato),
                          ),
                        ],
                      ),
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
          height: 15,
          child: Container(
            color: ColorBase.grey,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20, top: 10),
          child: Text(Dictionary.accountManage,
              style: TextStyle(
                  color: Color(0xff333333),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: FontsFamily.lato)),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                _buildGroupMenu(state.data),
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
                                  '${Environment.iconAssets}editProfile.png')),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            Dictionary.edit,
                            style: TextStyle(
                                color: Color(0xff333333),
                                fontSize: 12,
                                fontFamily: FontsFamily.lato),
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
                Divider(
                  color: Color(0xffE0E0E0),
                  thickness: 1,
                ),
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
        BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
          builder: (context, state) {
            return state is RemoteConfigLoaded
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _buildTermsConditions(state.remoteConfig),
                  )
                : Container();
          },
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: OutlineButton(
            borderSide: BorderSide(color: Color(0xffEB5757)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: Colors.white,
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
                        color: Color(0xffEB5757),
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.lato),
                  ))),
            ),
          ),
        )
      ],
    );
  }

  _buildTermsConditions(RemoteConfig remoteConfig) {
    var termsConditions;
    if (remoteConfig.getString(FirebaseConfig.termsConditions).isNotEmpty) {
      termsConditions =
          json.decode(remoteConfig.getString(FirebaseConfig.termsConditions));
      return Container(
        child: RichText(
          text: TextSpan(
              text: termsConditions['agreement'],
              style: TextStyle(
                  fontFamily: FontsFamily.lato,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff828282),
                  fontSize: 11.0),
              children: <TextSpan>[
                TextSpan(
                    text: Dictionary.termsConditions,
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TermsConditionsPage(termsConditions)),
                        );
                      })
              ]),
        ),
      );
    } else {
      return Container();
    }
  }

  _buildHealthStatus(RemoteConfig remoteConfig, DocumentSnapshot data) {
    Color cardColor = ColorBase.grey;
    Color textColor = Colors.white;
    String uriImage = '${Environment.iconAssets}user_health.png';

    bool visible = remoteConfig != null &&
            remoteConfig.getBool(FirebaseConfig.healthStatusVisible) != null
        ? remoteConfig.getBool(FirebaseConfig.healthStatusVisible)
        : false;

    if (remoteConfig != null &&
        remoteConfig.getString(FirebaseConfig.healthStatusColors) != null &&
        data['health_status'] != null) {
      Map<String, dynamic> healthStatusColor = json
          .decode(remoteConfig.getString(FirebaseConfig.healthStatusColors));

      switch (data['health_status']) {
        case "HEALTHY":
          cardColor = HexColor.fromHex(healthStatusColor['healthy'] != null
              ? healthStatusColor['healthy']
              : ColorBase.green);
          break;

        case "ODP":
          cardColor = HexColor.fromHex(healthStatusColor['odp'] != null
              ? healthStatusColor['odp']
              : Colors.yellow);
          textColor = Colors.black;
          uriImage = '${Environment.iconAssets}user_health_black.png';
          break;

        case "PDP":
          cardColor = HexColor.fromHex(healthStatusColor['pdp'] != null
              ? healthStatusColor['pdp']
              : Colors.orange);
          textColor = Colors.black;
          uriImage = '${Environment.iconAssets}user_health_black.png';
          break;

        case "CONFIRMED":
          cardColor = HexColor.fromHex(healthStatusColor['confirmed'] != null
              ? healthStatusColor['confirmed']
              : Colors.red);
          break;

        default:
          cardColor = Colors.grey;
      }
    }

    return visible && data['health_status_text'] != null
        ? Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
            decoration: BoxDecoration(
                color: cardColor, borderRadius: BorderRadius.circular(8)),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 32,
                      margin: EdgeInsets.only(right: 16.0),
                      child: Image.asset(uriImage),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            Dictionary.yourHealthStatus,
                            style: TextStyle(
                                fontFamily: FontsFamily.lato,
                                fontSize: 12,
                                color: textColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            data['health_status_text'],
                            style: TextStyle(
                                fontFamily: FontsFamily.lato,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textColor),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          )
        : Container();
  }

  FutureBuilder<RemoteConfig> _buildGroupMenu(DocumentSnapshot data) {
    return FutureBuilder<RemoteConfig>(
        future: setupRemoteConfig(),
        builder: (BuildContext context, AsyncSnapshot<RemoteConfig> snapshot) {
          var groupMenu;
          String role,healthStatus;
          int groupMenuLength = 0;
          if (snapshot.data != null) {
            groupMenu = json.decode(
                snapshot.data.getString(FirebaseConfig.groupMenuProfile));
            if (data['role'] == null || data['role'] == '') {
              role = 'public';
            } else {
              role = data['role'];
            }
             if (data['health_status'] == null || data['health_status'] == '') {
              healthStatus = 'healthy';
            } else {
              healthStatus = data['health_status'].toLowerCase();
            }
            groupMenu.removeWhere((element) => !element['role'].contains(role));
            groupMenu.removeWhere((element) => !element['health_status'].contains(healthStatus));
            groupMenu.removeWhere((element) => element['enabled'] == false);
            groupMenuLength = groupMenu.length;
          }

          return snapshot.data != null && groupMenuLength != 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[Column(children: getGroupMenu(groupMenu))],
                )
              : Container();
        });
  }

  List<Widget> getGroupMenu(List<dynamic> groupMenu) {
    List<Widget> list = List();

    for (int i = 0; i < groupMenu.length; i++) {
      Column column = Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              InkWell(
                onTap: () async {
                  var url = await userDataUrlAppend(groupMenu[i]['url']);
                  openChromeSafariBrowser(url: url);
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
                          style: TextStyle(
                              color: Color(0xff333333),
                              fontSize: 12,
                              fontFamily: FontsFamily.lato),
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
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    color: Color(0xffE0E0E0),
                    thickness: 1,
                  ),
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
      FirebaseConfig.groupMenuProfile: false,
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
    if (_remoteConfigBloc != null) {
      _remoteConfigBloc.close();
    }
    super.dispose();
  }
}
