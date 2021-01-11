import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:pikobar_flutter/blocs/authentication/Bloc.dart';
import 'package:pikobar_flutter/blocs/profile/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogQrCode.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/ProfileRepository.dart';
import 'package:pikobar_flutter/screens/myAccount/OnboardLoginScreen.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/HealthCheck.dart';
import 'package:pikobar_flutter/utilities/FirestoreHelper.dart';
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
  final ProfileRepository _profileRepository = ProfileRepository();
  ProfileBloc _profileBloc;

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
          BlocProvider<ProfileBloc>(
              create: (BuildContext context) => _profileBloc =
                  ProfileBloc(profileRepository: _profileRepository)),
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
                      CircularProgressIndicator(),
                      Container(
                        margin: EdgeInsets.only(left: 15.0),
                        child: Text(Dictionary.loading),
                      )
                    ],
                  ),
                  duration: Duration(seconds: 15),
                ),
              );
            } else {
              Scaffold.of(context).hideCurrentSnackBar();
            }
          },
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: CustomAppBar.animatedAppBar(
                  showTitle: true, title: Dictionary.profile),
              body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
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
                    AuthenticationAuthenticated _profileLoaded =
                        state as AuthenticationAuthenticated;
                    HealthCheck().isUserHealty(_profileLoaded.record.uid);
                    return BlocBuilder<ProfileBloc, ProfileState>(builder: (
                      BuildContext context,
                      ProfileState state,
                    ) {
                      if (state is ProfileLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is ProfileLoaded) {
                        ProfileLoaded _getProfile = state;
                        return _buildContent(
                            _getProfile.profile, _profileLoaded);
                      } else {
                        _profileBloc
                            .add(ProfileLoad(uid: _profileLoaded.record.uid));
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    });
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
              )),
        ));
  }

  // Function to build content
  Widget _buildContent(
      DocumentSnapshot state, AuthenticationAuthenticated _profileLoaded) {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                child: CircleAvatar(
                  minRadius: 90,
                  maxRadius: 150,
                  backgroundImage: (_profileLoaded.record.photoUrlFull) != null
                      // if image user is null show default image
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
                        state['name'],
                        style: TextStyle(
                            color: ColorBase.grey800,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.roboto),
                      ),
                    ),
                    Container(
                      height: 30.0,
                      child: Text(_profileLoaded.record.email,
                          style: TextStyle(
                              color: ColorBase.grey800,
                              fontSize: 12,
                              fontFamily: FontsFamily.roboto)),
                    ),
                    // Get health status visible from remote config
                    BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
                      builder: (context, remoteState) {
                        return remoteState is RemoteConfigLoaded
                            ? _buildHealthStatus(
                                remoteState.remoteConfig, state)
                            : Container();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.only(left: 20, top: 40),
          child: Text(Dictionary.qrCode,
              style: TextStyle(
                  color: ColorBase.grey800,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: FontsFamily.roboto)),
        ),
        InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                builder: (context) {
                  return DialogQrCode(idUser: state['id']);
                });
          },
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorBase.menuBorderColor)),
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
                                color: ColorBase.grey800,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: FontsFamily.roboto),
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

        Padding(
          padding: EdgeInsets.only(left: 20, top: 20),
          child: Text(Dictionary.accountManage,
              style: TextStyle(
                  color: ColorBase.grey800,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: FontsFamily.roboto)),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                _buildGroupMenu(state),
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
                                color: ColorBase.grey800,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                fontFamily: FontsFamily.roboto),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: ColorBase.grey800,
                        size: 18,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  color: ColorBase.menuBorderColor,
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
                          style: TextStyle(
                              color: ColorBase.grey800,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: FontsFamily.roboto),
                        ),
                      ],
                    ),
                    Text(
                      _versionText + ' ' + Dictionary.betaText,
                      style: TextStyle(color: ColorBase.darkGrey),
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
        // Get terms and condition string from remote config
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
            borderSide: BorderSide(color: ColorBase.softRed),
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
                        color: ColorBase.red400,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.roboto),
                  ))),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.17,
        )
      ],
    );
  }

  // Function to build text terms and conditions
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
                  fontFamily: FontsFamily.roboto,
                  fontWeight: FontWeight.bold,
                  color: ColorBase.netralGrey,
                  height: 1.7,
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

  // Function to build health status container
  _buildHealthStatus(RemoteConfig remoteConfig, DocumentSnapshot data) {
    Color cardColor = ColorBase.grey;
    Color textColor = Colors.white;
    String uriImage = '${Environment.iconAssets}user_health.png';
    // Get data health status visible or not
    bool visible = remoteConfig != null &&
            remoteConfig.getBool(FirebaseConfig.healthStatusVisible) != null
        ? remoteConfig.getBool(FirebaseConfig.healthStatusVisible)
        : false;
    // Get data health status color from remote config
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

        case "OTG":
          cardColor = HexColor.fromHex(healthStatusColor['otg'] != null
              ? healthStatusColor['otg']
              : Colors.black);
          break;

        default:
          cardColor = Colors.grey;
      }
    }
    // Check if health status visible or not
    return visible && data['health_status_text'] != null
        ? Container(
            decoration: BoxDecoration(
                color: cardColor, borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Text(
                data['health_status_text'],
                style: TextStyle(
                    fontFamily: FontsFamily.roboto,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
            ))
        : Container();
  }

  // Function to build group menu
  FutureBuilder<RemoteConfig> _buildGroupMenu(DocumentSnapshot data) {
    // Get data group menu from remote config
    return FutureBuilder<RemoteConfig>(
        future: setupRemoteConfig(),
        builder: (BuildContext context, AsyncSnapshot<RemoteConfig> snapshot) {
          var groupMenu;
          String role, healthStatus;
          int groupMenuLength = 0;
          if (snapshot.data != null) {
            groupMenu = json.decode(
                snapshot.data.getString(FirebaseConfig.groupMenuProfile));
            // Set default value to public if data [role] in collection users is null
            if (getField(data, 'role') == null ||
                getField(data, 'role') == '') {
              role = 'public';
            } else {
              role = getField(data, 'role');
            }
            // Set default value to healthy if data [health_status] in collection users is null
            if (data['health_status'] == null || data['health_status'] == '') {
              healthStatus = 'healthy';
            } else {
              healthStatus = data['health_status'].toLowerCase();
            }
            // Filtering data by role and health status and visible or not
            groupMenu.removeWhere((element) => !element['role'].contains(role));
            groupMenu.removeWhere(
                (element) => !element['health_status'].contains(healthStatus));
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

  // Function to build list of group menu
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
                              color: ColorBase.grey800,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: FontsFamily.roboto),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: ColorBase.grey800,
                      size: 18,
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
                    color: ColorBase.menuBorderColor,
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

  // Function to call remote config
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
