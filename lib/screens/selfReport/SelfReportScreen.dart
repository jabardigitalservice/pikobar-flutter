import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/authentication/Bloc.dart';
import 'package:pikobar_flutter/blocs/profile/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/GeocoderRepository.dart';
import 'package:pikobar_flutter/repositories/ProfileRepository.dart';
import 'package:pikobar_flutter/repositories/SelfReportRepository.dart';
import 'package:pikobar_flutter/screens/checkDistribution/components/LocationPicker.dart';
import 'package:pikobar_flutter/screens/myAccount/OnboardLoginScreen.dart';
import 'package:pikobar_flutter/screens/selfReport/ContactHistoryScreen.dart';
import 'package:pikobar_flutter/screens/selfReport/EducationListScreen.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportOption.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FirestoreHelper.dart';
import 'package:pikobar_flutter/utilities/HealthCheck.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';
import 'package:pikobar_flutter/utilities/launchExternal.dart';

class SelfReportScreen extends StatefulWidget {
  final bool toNextScreen;
  SelfReportScreen({Key key, this.toNextScreen = false}) : super(key: key);

  @override
  _SelfReportScreenState createState() => _SelfReportScreenState();
}

class _SelfReportScreenState extends State<SelfReportScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final AuthRepository _authRepository = AuthRepository();
  AuthenticationAuthenticated profileLoaded;

  AuthenticationBloc _authenticationBloc;
  LatLng latLng;
  String addressMyLocation;
  bool hasLogin = false;
  bool isLocationChange = false;
  ScrollController _scrollController;
  final ProfileRepository _profileRepository = ProfileRepository();
  ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    addressMyLocation = '-';
    AnalyticsHelper.setCurrentScreen(Analytics.selfReports);
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.5);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
              create: (context) => _authenticationBloc =
                  AuthenticationBloc(authRepository: _authRepository)
                    ..add(AppStarted())),
          BlocProvider<ProfileBloc>(
              create: (context) => _profileBloc =
                  ProfileBloc(profileRepository: _profileRepository)),
          BlocProvider<RemoteConfigBloc>(
              create: (BuildContext context) =>
                  RemoteConfigBloc()..add(RemoteConfigLoad())),
        ],
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationFailure) {
              // Show an error message dialog when login,
              // except for errors caused by users who were canceled to login.
              if (!state.error.contains('ERROR_ABORTED_BY_USER') &&
                  !state.error.contains('NoSuchMethodError')) {
                showDialog(
                    context: context,
                    builder: (context) => DialogTextOnly(
                          description: state.error.toString(),
                          buttonText: "OK",
                          onOkPressed: () {
                            Navigator.of(context).pop(); // To close the dialog
                          },
                        ));
              }
              _scaffoldKey.currentState.hideCurrentSnackBar();
              setState(() {
                hasLogin = false;
              });
            }
            if (state is AuthenticationLoading) {
              // Show dialog when loading
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  content: Row(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Container(
                        margin: const EdgeInsets.only(left: 15.0),
                        child: Text(Dictionary.loading),
                      )
                    ],
                  ),
                  duration: Duration(seconds: 15),
                ),
              );
              hasLogin = false;
            }
            if (state is AuthenticationUnauthenticated) {
              _scaffoldKey.currentState.hideCurrentSnackBar();
              hasLogin = false;
            }

            if (state is AuthenticationAuthenticated) {
              _scaffoldKey.currentState.hideCurrentSnackBar();
              profileLoaded = state;
              hasLogin = true;
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
            appBar: CustomAppBar.animatedAppBar(
              showTitle: _showTitle,
              title: Dictionary.titleSelfReport,
            ),
            backgroundColor: Colors.white,
            body:
                BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: (
              BuildContext context,
              AuthenticationState state,
            ) {
              if (state is AuthenticationUnauthenticated ||
                  state is AuthenticationLoading) {
                // When user is not login show login screen
                return OnBoardingLoginScreen(
                  authenticationBloc: _authenticationBloc,
                );
              } else if (state is AuthenticationAuthenticated ||
                  state is AuthenticationLoading) {
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
                    return _getProfile.profile.exists
                        ? _buildContent(_getProfile.profile)
                        : _buildContent(null);
                  } else {
                    _profileBloc.add(ProfileLoad(
                        uid: profileLoaded != null
                            ? profileLoaded.record.uid
                            : null));
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
              } else if (state is AuthenticationFailure ||
                  state is AuthenticationLoading) {
                return OnBoardingLoginScreen(
                  authenticationBloc: _authenticationBloc,
                );
              } else {
                return Container();
              }
            }),
          ),
        ));
  }

  /// Function for check if profile not complete user must fill profile in menu edit profile
  bool _isProfileUserNotComplete(DocumentSnapshot state) {
    if (state != null &&
        getField(state, 'name').toString().isNotEmpty &&
        getField(state, 'nik').toString().isNotEmpty &&
        getField(state, 'email').toString().isNotEmpty &&
        getField(state, 'phone_number').toString().isNotEmpty &&
        getField(state, 'address').toString().isNotEmpty &&
        getField(state, 'birthdate').toString().isNotEmpty &&
        getField(state, 'gender').toString().isNotEmpty &&
        getField(state, 'city_id').toString().isNotEmpty &&
        getField(state, 'location').toString().isNotEmpty &&
        getField(state, 'name') != null &&
        getField(state, 'nik') != null &&
        getField(state, 'email') != null &&
        getField(state, 'phone_number') != null &&
        getField(state, 'address') != null &&
        getField(state, 'birthdate') != null &&
        getField(state, 'gender') != null &&
        getField(state, 'city_id') != null &&
        getField(state, 'location') != null) {
      return false;
    } else {
      return true;
    }
  }

  /// Function for build widget content
  Widget _buildContent(DocumentSnapshot state) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            AnimatedOpacity(
              opacity: _showTitle ? 0.0 : 1.0,
              duration: Duration(milliseconds: 250),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  Dictionary.titleSelfReport,
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            hasLogin
                ? _isProfileUserNotComplete(state)
                    ? const SizedBox(
                        height: 20,
                      )
                    : Container()
                : Container(),
            hasLogin
                ? _isProfileUserNotComplete(state)
                    ? _buildAnnounceProfileNotComplete(state)
                    : Container()
                : Container(),
            const SizedBox(
              height: 10,
            ),
            _buildLocation(state),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<bool>(
              future:
                  SelfReportRepository().checkNIK(nik: getField(state, 'nik')),
              builder: (context, snapshot) {
                final bool checkHasData =
                    snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData;
                final bool isQuarantined = (checkHasData && snapshot.data) ||
                    !HealthCheck()
                        .isUserHealty(getField(state, 'health_status'));

                return BlocListener<RemoteConfigBloc, RemoteConfigState>(
                  listener: (_, remoteState) {
                    if (widget.toNextScreen &&
                        remoteState is RemoteConfigLoaded) {
                      final Map<String, dynamic> getLabel =
                          RemoteConfigHelper.decode(
                              remoteConfig: remoteState.remoteConfig,
                              firebaseConfig: FirebaseConfig.nikMessage,
                              defaultValue:
                                  FirebaseConfig.nikMessageDefaultValue);

                      if (hasLogin && !_isProfileUserNotComplete(state)) {
                        _openSelfReportOption(state, isQuarantined, getLabel);
                      } else {
                        _checkUserProfile(
                            checkHasData &&
                                !_isProfileUserNotComplete(state) &&
                                !snapshot.data,
                            getLabel);
                      }
                    }
                  },
                  child: BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
                    builder: (context, remoteState) {
                      if (remoteState is RemoteConfigLoaded) {
                        final Map<String, dynamic> getLabel =
                            RemoteConfigHelper.decode(
                                remoteConfig: remoteState.remoteConfig,
                                firebaseConfig: FirebaseConfig.nikMessage,
                                defaultValue:
                                    FirebaseConfig.nikMessageDefaultValue);
                        final List<dynamic> getListData =
                            RemoteConfigHelper.decode(
                                remoteConfig: remoteState.remoteConfig,
                                firebaseConfig: FirebaseConfig.selfIsolation,
                                defaultValue:
                                    FirebaseConfig.selfIsolationDefaultValue);
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _buildContainer(
                                  imageDisable:
                                      '${Environment.iconAssets}daily_self_report_disable.png',
                                  imageEnable:
                                      '${Environment.iconAssets}daily_self_report_enable.png',
                                  title: Dictionary.dailyMonitoring,
                                  length: 2,
                                  //for give condition onPressed in widget _buildContainer
                                  onPressedEnable: () {
                                    _openSelfReportOption(
                                        state, isQuarantined, getLabel);
                                  },
                                  onPressedDisable: () {
                                    _checkUserProfile(
                                        checkHasData &&
                                            !_isProfileUserNotComplete(state) &&
                                            !snapshot.data,
                                        getLabel);
                                  },
                                  // condition for check if user login and user complete fill that profile
                                  // and health status is not healthy user can access for press the button in _buildContainer
                                  isShowMenu: hasLogin &&
                                      !_isProfileUserNotComplete(state),
                                ),
                                _buildContainer(
                                  imageDisable:
                                      '${Environment.iconAssets}history_contact_disable.png',
                                  imageEnable:
                                      '${Environment.iconAssets}history_contact_enable.png',
                                  title: Dictionary.historyContact,
                                  length: 2,
                                  onPressedEnable: () {
                                    if (latLng == null ||
                                        addressMyLocation == '-' ||
                                        addressMyLocation.isEmpty ||
                                        addressMyLocation == null) {
                                      Fluttertoast.showToast(
                                          backgroundColor: ColorBase.grey500,
                                          msg: Dictionary
                                              .alertLocationSelfReport,
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          fontSize: 16.0);
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ContactHistoryScreen()));
                                    }
                                  },
                                  onPressedDisable: () {
                                    if (checkHasData &&
                                        !_isProfileUserNotComplete(state) &&
                                        !snapshot.data) {
                                      showTextBottomSheet(
                                          context: context,
                                          title: getLabel['title'],
                                          message: getLabel['description']);
                                    } else {
                                      showTextBottomSheet(
                                          context: context,
                                          title: Dictionary.profileNotComplete,
                                          message: Dictionary.descProfile1);
                                    }
                                  },
                                  isShowMenu: hasLogin &&
                                      !_isProfileUserNotComplete(state) &&
                                      (checkHasData
                                          ? (snapshot.data ||
                                              !HealthCheck().isUserHealty(
                                                getField(
                                                    state, 'health_status'),
                                              ))
                                          : !HealthCheck().isUserHealty(
                                              getField(state, 'health_status'),
                                            )),
                                ),
                              ],
                            ),
                            GridView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                      childAspectRatio: 1.4,
                                      maxCrossAxisExtent: 200,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5),
                              children: getGridMenu(getListData),
                            )
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                );
              },
            ),
            const SizedBox(
              height: 30,
            ),
            EducationListScreen(scrollController: _scrollController)
          ],
        ));
  }

  ///Function for build widget announcement if profile user not complete
  Widget _buildAnnounceProfileNotComplete(DocumentSnapshot state) {
    return Container(
      width: (MediaQuery.of(context).size.width),
      margin: const EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
          color: ColorBase.lightRed,
          borderRadius: BorderRadius.circular(Dimens.borderRadius)),
      child: Stack(
        children: <Widget>[
          Image.asset('${Environment.imageAssets}red_intersect.png', width: 73),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        Dictionary.profileNotComplete,
                        style: TextStyle(
                            fontSize: 12.0,
                            color: ColorBase.grey800,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.roboto),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                      child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: Dictionary.descProfile1,
                        style: TextStyle(
                            height: 1.7,
                            fontSize: 12.0,
                            color: ColorBase.netralGrey,
                            fontFamily: FontsFamily.roboto),
                      ),
                      TextSpan(
                          text: Dictionary.descProfile2,
                          style: TextStyle(
                              fontSize: 12.0,
                              height: 1.7,
                              color: Colors.blue,
                              fontFamily: FontsFamily.roboto,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                  context, NavigationConstrants.Edit,
                                  arguments: state);
                            }),
                      TextSpan(
                        text: Dictionary.descProfile3,
                        style: TextStyle(
                            fontSize: 12.0,
                            height: 1.7,
                            color: ColorBase.netralGrey,
                            fontFamily: FontsFamily.roboto),
                      ),
                    ]),
                  ))
                ]),
          ),
        ],
      ),
    );
  }

  ///Function for build widget location user
  Widget _buildLocation(DocumentSnapshot state) {
    if (!isLocationChange) {
      if (state != null) {
        if (getField(state, 'address') != null) {
          addressMyLocation = getField(state, 'address').toString();
        }
        if (getField(state, 'location') != null) {
          latLng =
              LatLng(state['location'].latitude, state['location'].longitude);
        }
      }
    }

    return GestureDetector(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${Dictionary.currentLocationTitleSelfReport}',
                style: TextStyle(
                  fontFamily: FontsFamily.roboto,
                  color: ColorBase.netralGrey,
                  fontWeight: FontWeight.normal,
                  fontSize: 12.0,
                  height: 1.2,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      addressMyLocation,
                      style: TextStyle(
                        fontFamily: FontsFamily.roboto,
                        color: ColorBase.grey800,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        height: 1.2,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {
        hasLogin
            ? !_isProfileUserNotComplete(state) &&
                    !HealthCheck()
                        .isUserHealty(getField(state, 'health_status'))
                ? _handleLocation()
                // ignore: unnecessary_statements
                : null
            // ignore: unnecessary_statements
            : null;
      },
    );
  }

  /// Function for build widget button self report
  _buildContainer(
      {String imageDisable,
      String imageEnable,
      String title,
      int length,
      GestureTapCallback onPressedEnable,
      GestureTapCallback onPressedDisable,
      bool isShowMenu,
      bool isDynamic = false}) {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: RaisedButton(
        elevation: 0,
        padding: EdgeInsets.all(0.0),
        color: ColorBase.greyContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
        ),
        child: Container(
          width: (MediaQuery.of(context).size.width / length),
          padding:
              const EdgeInsets.only(left: 5.0, right: 5.0, top: 15, bottom: 15),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  height: 30,
                  child: isDynamic
                      ? Image.network(imageEnable)
                      : Image.asset(isShowMenu ? imageEnable : imageDisable)),
              Container(
                margin: const EdgeInsets.only(top: 15, right: 10.0),
                child: Text(title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14.0,
                        color:
                            isShowMenu ? ColorBase.grey800 : ColorBase.grey500,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.roboto)),
              )
            ],
          ),
        ),
        onPressed: isShowMenu ? onPressedEnable : onPressedDisable ?? null,
      ),
    ));
  }

  /// Function to get location user
  Future<void> _handleLocation() async {
    //Checking permission status
    final PermissionWithService permissionService =
        Platform.isIOS ? Permission.locationWhenInUse : Permission.location;

    if (await permissionService.status.isGranted) {
      // Permission allowed
      await _openLocationPicker();
    } else {
      // Permission disallowed
      // Show dialog to ask permission
      showDialog(
          context: context,
          builder: (context) => DialogRequestPermission(
                image: Image.asset(
                  '${Environment.iconAssets}map_pin.png',
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                description: Dictionary.permissionLocationSpread,
                onOkPressed: () async {
                  Navigator.of(context).pop();
                  if (await permissionService.status.isDenied) {
                    await AppSettings.openLocationSettings();
                  } else {
                    permissionService.request().then((status) {
                      _onStatusRequested(context, status);
                    });
                  }
                },
                onCancelPressed: () {
                  AnalyticsHelper.setLogEvent(
                      Analytics.permissionDismissLocation);
                  Navigator.of(context).pop();
                },
              ));
    }
  }

  // Function to build list of group menu
  List<Widget> getGridMenu(List<dynamic> getListData) {
    final List<Widget> list = List();

    for (int i = 0; i < getListData.length; i++) {
      final Column column = Column(
        children: <Widget>[
          _buildContainer(
              isDynamic: true,
              imageEnable: getListData[i]['icon'],
              title: getListData[i]['title'],
              length: 2,
              //for give condition onPressed in widget _buildContainer
              onPressedEnable: () async {
                await launchExternal(getListData[i]['url']);
                await AnalyticsHelper.setLogEvent(getListData[i]['analytics']);
              },
              isShowMenu: true)
        ],
      );

      list.add(column);
    }
    return list;
  }

  /// Function to get lat long user and auto complete address field
  Future<void> _openLocationPicker() async {
    latLng = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LocationPicker()));
    final String address = await GeocoderRepository().getAddress(latLng);
    if (address != null) {
      setState(() {
        isLocationChange = true;
        addressMyLocation = address;
      });
    }
  }

  /// Function to get status for access location
  void _onStatusRequested(
      BuildContext context, PermissionStatus statuses) async {
    if (statuses.isGranted) {
      _openLocationPicker();
      AnalyticsHelper.setLogEvent(Analytics.permissionGrantedLocation);
    } else {
      AnalyticsHelper.setLogEvent(Analytics.permissionDeniedLocation);
    }
  }

  void _openSelfReportOption(DocumentSnapshot state, bool isQuarantined,
      Map<String, dynamic> getLabel) {
    if (latLng == null ||
        addressMyLocation == '-' ||
        addressMyLocation.isEmpty ||
        addressMyLocation == null) {
      Fluttertoast.showToast(
          backgroundColor: ColorBase.grey500,
          msg: Dictionary.alertLocationSelfReport,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16.0);
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SelfReportOption(
                location: latLng,
                cityId: getField(state, 'city_id'),
                isHealthStatusChanged:
                    getField(state, 'health_status_changed') ?? false,
                isQuarantined: isQuarantined,
                nikMessage: getLabel,
              )));
    }
  }

  void _checkUserProfile(
      bool isProfileComplete, Map<String, dynamic> getLabel) {
    if (isProfileComplete) {
      showTextBottomSheet(
          context: context,
          title: getLabel['title'],
          message: getLabel['description']);
    } else {
      showTextBottomSheet(
          context: context,
          title: Dictionary.profileNotComplete,
          message: Dictionary.descProfile1);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_authenticationBloc != null) {
      _authenticationBloc.close();
    }
  }
}
