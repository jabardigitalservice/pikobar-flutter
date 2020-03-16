// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:package_info/package_info.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:sapawarga/blocs/account_profile/AccountProfileBloc.dart';
// import 'package:sapawarga/blocs/account_profile/AccountProfileEvent.dart';
// import 'package:sapawarga/blocs/account_profile/AccountProfileState.dart';
// import 'package:sapawarga/blocs/account_profile/Bloc.dart';
// import 'package:sapawarga/blocs/authentication/Bloc.dart';
// import 'package:sapawarga/blocs/gamifications/gamification_my_badge/Bloc.dart';
// import 'package:sapawarga/components/BrowserScreen.dart';
// import 'package:sapawarga/components/DialogRequestPermission.dart';
// import 'package:sapawarga/components/DialogTextOnly.dart';
// import 'package:sapawarga/components/RoundedButton.dart';
// import 'package:sapawarga/components/Skeleton.dart';
// import 'package:sapawarga/constants/Analytics.dart';
// import 'package:pedantic/pedantic.dart';
// import 'package:sapawarga/constants/Colors.dart' as color;
// import 'package:sapawarga/constants/Dictionary.dart';
// import 'package:sapawarga/constants/Dimens.dart';
// import 'package:sapawarga/constants/Navigation.dart';
// import 'package:sapawarga/constants/UrlThirdParty.dart';
// import 'package:sapawarga/enums/ChangePasswordType.dart';
// import 'package:sapawarga/environment/Environment.dart';
// import 'package:sapawarga/repositories/AuthProfileRepository.dart';
// import 'package:sapawarga/repositories/GamificationsRepository.dart';
// import 'package:sapawarga/repositories/HumasJabarRepository.dart';
// import 'package:sapawarga/screens/main/account/profile_edit/ProfileEditScreen.dart';
// import 'package:sapawarga/utilities/AnalyticsHelper.dart';
// import 'package:sapawarga/utilities/BasicUtils.dart';

// class ProfileScreen extends StatelessWidget {
//   final AuthProfileRepository authProfileRepository = AuthProfileRepository();

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<AccountProfileBloc>(
//         create: (context) => AccountProfileBloc.profile(
//             authProfileRepository: authProfileRepository),
//         child: _Profile());
//   }
// }

// class _Profile extends StatefulWidget {
//   @override
//   __ProfileState createState() => __ProfileState();
// }

// class __ProfileState extends State<_Profile> {
//   final RefreshController _mainRefreshController = RefreshController();
//   final GamificationsRepository gamificationsRepository =
//       GamificationsRepository();

//   AccountProfileBloc _accountProfileBloc;
//   AccountProfileEditBloc _blocProfile;
//   AuthenticationBloc _authenticationBloc;
//   GamificationsMyBadgeBloc _gamificationsMyBadgeBloc;
//   AccountProfileLoaded stateLoadProfile;
//   String _versionText = Dictionary.version;
//   bool isShowDialog = false;
//   ProgressDialog loadingDialog;

//   @override
//   void initState() {
//     AnalyticsHelper.setCurrentScreen(Analytics.ACCOUNT);
//     AnalyticsHelper.setLogEvent(Analytics.EVENT_DETAIL_ACCOUNT);

//     _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Profile'),
//         ),
//         body: MultiBlocProvider(
//             providers: [
//               BlocProvider<AccountProfileBloc>(
//                 create: (context) =>
//                     _accountProfileBloc = AccountProfileBloc.profile(
//                         authProfileRepository: AuthProfileRepository())
//                       ..add(AccountProfileLoad()),
//               ),
//               BlocProvider<AccountProfileEditBloc>(
//                 create: (context) => _blocProfile = AccountProfileEditBloc(
//                     authProfileRepository: AuthProfileRepository()),
//               ),
//               BlocProvider<GamificationsMyBadgeBloc>(
//                 create: (context) => _gamificationsMyBadgeBloc =
//                     GamificationsMyBadgeBloc(
//                         gamificationsRepository: gamificationsRepository),
//               ),
//             ],
//             child: MultiBlocListener(
//               listeners: [
//                 BlocListener<AccountProfileBloc, AccountProfileState>(
//                     bloc: _accountProfileBloc,
//                     listener: (context, state) {
//                       if (state is AccountProfileLoaded) {
//                         _gamificationsMyBadgeBloc
//                             .add(GamificationsMyBadgeLoad(page: 1));
//                       }
//                     }),
//                 BlocListener<AccountProfileEditBloc, AccountProfileEditState>(
//                     bloc: _blocProfile,
//                     listener: (context, state) {
//                       if (state is AccountProfileEditFailure) {
//                         showDialog(
//                             context: context,
//                             builder: (BuildContext context) => DialogTextOnly(
//                                   description: state.error,
//                                   buttonText: "OK",
//                                   onOkPressed: () {
//                                     Navigator.of(context)
//                                         .pop(); // To close the dialog
//                                   },
//                                 ));
//                       }

//                       if (state is AccountProfileEditValidationError) {
//                         if (state.errors.containsKey('email')) {
//                           showDialog(
//                               context: context,
//                               builder: (BuildContext context) => DialogTextOnly(
//                                     description:
//                                         state.errors['email'][0].toString(),
//                                     buttonText: "OK",
//                                     onOkPressed: () {
//                                       Navigator.of(context)
//                                           .pop(); // To close the dialog
//                                     },
//                                   ));
//                         }
//                       }

//                       if (state is AccountProfileEditPhotoLoading) {
//                         _onWidgetDidBuild(() {
//                           showLoading();
//                         });
//                       }

//                       if (state is AccountProfileEditPhotoUpdated) {
//                         hideLoading();
//                         _onWidgetDidBuild(() {
//                           if (isShowDialog) {
//                             showDialog(
//                                 context: context,
//                                 barrierDismissible: false,
//                                 builder: (BuildContext context) {
//                                   return AlertDialog(
//                                     title: Text(Dictionary.updatePhotoTitle),
//                                     content: Text(Dictionary.successSavePhoto),
//                                     actions: <Widget>[
//                                       FlatButton(
//                                         child: Text(Dictionary.ok),
//                                         onPressed: () {
//                                           _accountProfileBloc
//                                               .add(AccountProfileChanged());
//                                           Navigator.pop(context);
//                                         },
//                                       ),
//                                     ],
//                                   );
//                                 });
//                             isShowDialog = false;
//                           }
//                         });
//                       }
//                     })
//               ],
//               child: BlocBuilder<AccountProfileBloc, AccountProfileState>(
//                   bloc: _accountProfileBloc,
//                   builder: (context, state) {
//                     return Container(
//                         child: state is AccountProfileLoading
//                             ? _buildLoading()
//                             : state is AccountProfileLoaded
//                                 ? _buildContent(state)
//                                 : state is AccountProfileFailure
//                                     ? _buildFailure(state)
//                                     : Container());
//                   }),
//             )));
//   }

//   _buildLoadingMyBadge() {
//     return Skeleton(
//         child: Container(
//             padding: EdgeInsets.only(top: 10),
//             child: Row(children: <Widget>[
//               Container(
//                 margin: EdgeInsets.only(left: 10, right: 10),
//                 height: 86,
//                 width: MediaQuery.of(context).size.width / 4,
//                 decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(18),
//                         bottomLeft: Radius.circular(18))),
//                 child: Column(
//                   children: <Widget>[
//                     Text(
//                       Dictionary.missionDone,
//                       style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.w600),
//                       textAlign: TextAlign.left,
//                     ),
//                     Text(
//                       '0',
//                       style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 45.0,
//                           fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.left,
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(right: 10),
//                 height: 86,
//                 width: MediaQuery.of(context).size.width / 1.55,
//                 decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(8),
//                         bottomRight: Radius.circular(8))),
//                 child: Column(
//                   children: <Widget>[
//                     Text(
//                       Dictionary.missionDone,
//                       style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.w600),
//                       textAlign: TextAlign.left,
//                     ),
//                     Text(
//                       '0',
//                       style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 45.0,
//                           fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.left,
//                     ),
//                   ],
//                 ),
//               ),
//             ])));
//   }

//   _buildMyBadge() {
//     return BlocBuilder<GamificationsMyBadgeBloc, GamificationsMyBadgeState>(
//       bloc: _gamificationsMyBadgeBloc,
//       builder: (context, state) => state is GamificationsMyBadgeLoaded
//           ? _buildMyBadgeContet(state)
//           : state is GamificationsMyBadgeLoading
//               ? _buildLoadingMyBadge()
//               : state is GamificationsMyBadgeFailure
//                   ? Text(state.error)
//                   : Container(),
//     );
//   }

//   _buildMyBadgeContet(GamificationsMyBadgeLoaded state) {
//     return Container(
//       padding: EdgeInsets.only(top: 10),
//       child: Row(children: <Widget>[
//         Container(
//           margin: EdgeInsets.only(right: 10, left: 10),
//           child: Stack(
//             children: <Widget>[
//               Image.asset(
//                   '${Environment.imageAssets}profile_mission_background1.png',
//                   height: 90,
//                   fit: BoxFit.fitWidth),
//               Positioned(
//                   bottom: 0,
//                   top: 10,
//                   left: 5,
//                   right: 0,
//                   child: Column(
//                     children: <Widget>[
//                       Text(
//                         Dictionary.missionDone,
//                         style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.w600),
//                         textAlign: TextAlign.left,
//                       ),
//                       Text(
//                         state.records.meta.totalCount.toString(),
//                         style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 45.0,
//                             fontWeight: FontWeight.bold),
//                         textAlign: TextAlign.left,
//                       ),
//                     ],
//                   ))
//             ],
//           ),
//         ),
//         Stack(
//           children: <Widget>[
//             Image.asset(
//                 '${Environment.imageAssets}profile_mission_background2.png',
//                 height: 90,
//                 width: MediaQuery.of(context).size.width - 150,
//                 fit: BoxFit.fitWidth),
//             Positioned(
//               bottom: 0,
//               top: 10,
//               left: 5,
//               right: 0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.max,
//                 children: <Widget>[
//                   Container(
//                     padding: EdgeInsets.only(left: 10),
//                     child: Text(
//                       Dictionary.badge,
//                       style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.w600),
//                       textAlign: TextAlign.left,
//                     ),
//                   ),
//                   Expanded(
//                       child: Container(
//                     alignment: Alignment.topLeft,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Container(
//                           padding: EdgeInsets.all(10),
//                           child: CachedNetworkImage(
//                             imageUrl: state.records.items[index].gamification
//                                 .imageBadgePathUrl,
//                             fit: BoxFit.fill,
//                             width: 30,
//                             placeholder: (context, url) =>
//                                 Center(child: CupertinoActivityIndicator()),
//                             errorWidget: (context, url, error) => Container(
//                                 height:
//                                     MediaQuery.of(context).size.height / 2.5,
//                                 width: MediaQuery.of(context).size.width / 3.3,
//                                 color: Colors.grey[200],
//                                 child: Image.asset(
//                                     '${Environment.imageAssets}placeholder.png',
//                                     fit: BoxFit.fitWidth)),
//                           ),
//                         );
//                       },
//                       itemCount: state.records.items.length,
//                       physics: NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                     ),
//                   ))
//                 ],
//               ),
//             )
//           ],
//         ),
//       ]),
//     );
//   }

//   _buildLoading() {
//     return SingleChildScrollView(
//       child: Column(
//         children: <Widget>[
//           Container(
//             height: MediaQuery.of(context).size.height / 5.5,
//             child: Stack(
//               children: <Widget>[
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.1,
//                   child: Skeleton(
//                     width: MediaQuery.of(context).size.width,
//                     // height: 35,
//                     // margin: 5.0,
//                   ),
//                 ),
//                 Positioned(
//                   top: 15,
//                   left: Dimens.padding,
//                   child: Container(
//                     width: 97,
//                     height: 97,
//                     child: CircleAvatar(
//                       minRadius: 90,
//                       maxRadius: 150,
//                       backgroundImage:
//                           ExactAssetImage('${Environment.imageAssets}user.png'),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 95,
//                   bottom: 2.0,
//                   left: 130.0,
//                   right: Dimens.padding,
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     // height: 35,
//                     height: MediaQuery.of(context).size.height / 5.5,
//                     // color: Colors.blue,
//                     child: Row(
//                       children: <Widget>[
//                         Skeleton(
//                           child: Container(
//                             margin: EdgeInsets.only(right: 24.0),
//                             height: 30.0,
//                             width: 24.0,
//                             child: Icon(
//                               FontAwesomeIcons.instagram,
//                               size: 27,
//                             ),
//                           ),
//                         ),
//                         Skeleton(
//                             child: Container(
//                           margin: EdgeInsets.only(right: 24.0),
//                           height: 30.0,
//                           width: 24.0,
//                           child: Icon(
//                             FontAwesomeIcons.facebookSquare,
//                             size: 27,
//                           ),
//                         )),
//                         Skeleton(
//                             child: Container(
//                           margin: EdgeInsets.only(right: 24.0),
//                           height: 30.0,
//                           width: 24.0,
//                           child: Icon(
//                             FontAwesomeIcons.twitter,
//                             size: 27,
//                           ),
//                         )),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           _buildLoadingMyBadge(),
//           Container(
//               padding: EdgeInsets.all(Dimens.padding),
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 children: <Widget>[
//                   _buildButtonProfileLoading(
//                     '${Environment.iconAssets}icon_profile.png',
//                     Dictionary.profile,
//                     18,
//                     null,
//                   ),
//                   _buildButtonProfileLoading(
//                       '${Environment.iconAssets}icon_contact.png',
//                       Dictionary.contact,
//                       14,
//                       13),
//                   _buildButtonProfileLoading(
//                       '${Environment.iconAssets}icon_address.png',
//                       Dictionary.address,
//                       21,
//                       7),
//                   _buildButtonProfileLoading(
//                       '${Environment.iconAssets}icon_mission.png',
//                       Dictionary.mission,
//                       18,
//                       null),
//                   _buildButtonProfileLoading(
//                       '${Environment.iconAssets}icon_privacy_policy.png',
//                       Dictionary.privacyPolicy,
//                       18,
//                       null),
//                   _buildButtonProfileLoading(
//                       '${Environment.iconAssets}icon_app_version.png',
//                       'App Version',
//                       18,
//                       null),
//                   _buildButtonProfileLoading(
//                       '${Environment.iconAssets}icon_key_password.png',
//                       'Ubah Password',
//                       18,
//                       null),
//                   SizedBox(
//                     height: 20,
//                   ),
//                 ],
//               ))
//         ],
//       ),
//     );
//   }

//   _buildContent(AccountProfileLoaded state) {
//     stateLoadProfile = state;

//     PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
//       setState(() {
//         _versionText = packageInfo.version != null
//             ? packageInfo.version.contains('-staging')
//                 ? packageInfo.version.replaceFirst('-staging', '')
//                 : packageInfo.version.replaceFirst('-production', '')
//             : Dictionary.version;
//       });
//     });

//     return SmartRefresher(
//       controller: _mainRefreshController,
//       enablePullDown: true,
//       header: WaterDropMaterialHeader(),
//       onRefresh: () async {
//         _accountProfileBloc.add(AccountProfileChanged());
//         _mainRefreshController.refreshCompleted();
//       },
//       child: SingleChildScrollView(
//           child: Container(
//         color: Colors.white,
//         child: Column(
//           children: <Widget>[
//             _buildHeader(state),
//             _buildMyBadge(),
//             _buildListForm(state),
//           ],
//         ),
//       )),
//     );
//   }

//   _buildFailure(AccountProfileFailure state) {
//     return Container(child: Text(state.error));
//   }

//   _navigateResult(BuildContext context) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) =>
//             ProfileEditScreen(authUserInfo: stateLoadProfile.record),
//       ),
//     );
//     _accountProfileBloc.add(AccountProfileLoad());
//     if (result == Dictionary.successSaveProfile) {
//       await showDialog(
//         context: context,
//         builder: (BuildContext context) => DialogTextOnly(
//           title: Dictionary.congratulation,
//           description: Dictionary.successSaveProfile,
//           buttonText: Dictionary.understand,
//           onOkPressed: () {
//             Navigator.of(context).pop(); // To close the dialog
//           },
//         ),
//       );
//     }
//   }

//   Widget _buildHeader(AccountProfileLoaded state) {
//     return Container(
//       height: MediaQuery.of(context).size.height / 5.6,
//       child: Stack(
//         children: <Widget>[
//           Container(
//             height: MediaQuery.of(context).size.height * 0.11,
// //            decoration: BoxDecoration(
// //              image: DecorationImage(
// //                  image: AssetImage(
// //                      '${Environment.imageAssets}header-profile.png'),
// //                  fit: BoxFit.cover),
// //            ),
//           ),
//           Positioned(
//               top: Dimens.padding,
//               left: Dimens.padding,
//               child: Row(
//                 children: <Widget>[
//                   Stack(
//                     children: <Widget>[
//                       Container(
//                         width: 98,
//                         height: 98,
//                         child: CircleAvatar(
//                           minRadius: 90,
//                           maxRadius: 150,
//                           backgroundImage: state.record.photoUrl != null
//                               ? NetworkImage(state.record.photoUrl)
//                               : ExactAssetImage(
//                                   '${Environment.imageAssets}user.png'),
//                         ),
//                       ),
//                       Positioned(
//                           right: -24,
//                           bottom: 0,
//                           child: GestureDetector(
//                             child: Container(
//                               margin: EdgeInsets.only(right: 24.0),
//                               height: 24.0,
//                               width: 24.0,
//                               child: Image.asset(
//                                   '${Environment.iconAssets}icon_addImage.png'),
//                             ),
//                             onTap: () {
//                               _cameraBottomSheet(context);
//                             },
//                           ))
//                     ],
//                   ),
//                   Container(
//                     alignment: Alignment.topLeft,
//                     padding: EdgeInsets.only(left: 10, bottom: 40),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           state.record.name,
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 16.0,
//                               fontWeight: FontWeight.w600),
//                           textAlign: TextAlign.left,
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           "RW " +
//                               state.record.rw +
//                               ", " +
//                               state.record.kecamatan.name +
//                               " " +
//                               state.record.kelurahan.name,
//                           style: TextStyle(color: Colors.grey, fontSize: 14.0),
//                           textAlign: TextAlign.left,
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               )),
//           Positioned(
//             bottom: 2.0,
//             left: 130.0,
//             right: Dimens.padding,
//             child: Container(
//               width: MediaQuery.of(context).size.width,
//               // height: 35,
//               height: MediaQuery.of(context).size.height / 17.5,
//               // color: Colors.blue,
//               child: Row(
//                 children: <Widget>[
//                   GestureDetector(
//                     child: Container(
//                       margin: EdgeInsets.only(right: 24.0),
//                       height: 24.0,
//                       width: 24.0,
//                       child:
//                           Image.asset('${Environment.iconAssets}instagram.png'),
//                     ),
//                     onTap: () {
//                       state.record.instagram != null &&
//                               state.record.instagram.toString().isNotEmpty
//                           ? Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => BrowserScreen(
//                                         url: UrlThirdParty.urlPathInstagram +
//                                             state.record.instagram,
//                                       )),
//                             )
//                           : Scaffold.of(context).showSnackBar(SnackBar(
//                               content:
//                                   Text(Dictionary.loadInstagramUrlFailed)));
//                     },
//                   ),
//                   GestureDetector(
//                     child: Container(
//                       margin: EdgeInsets.only(right: 24.0),
//                       height: 24.0,
//                       width: 24.0,
//                       child:
//                           Image.asset('${Environment.iconAssets}facebook.png'),
//                     ),
//                     onTap: () {
//                       state.record.facebook != null &&
//                               state.record.facebook.toString().isNotEmpty
//                           ? Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => BrowserScreen(
//                                         url: UrlThirdParty.urlPathFacebook +
//                                             state.record.facebook,
//                                       )),
//                             )
//                           : Scaffold.of(context).showSnackBar(SnackBar(
//                               content: Text(Dictionary.loadFacebookUrlFailed)));
//                     },
//                   ),
//                   GestureDetector(
//                     child: Container(
//                       margin: EdgeInsets.only(right: 45.0),
//                       height: 24.0,
//                       width: 24.0,
//                       child:
//                           Image.asset('${Environment.iconAssets}twitter.png'),
//                     ),
//                     onTap: () {
//                       state.record.twitter != null &&
//                               state.record.twitter.toString().isNotEmpty
//                           ? Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => BrowserScreen(
//                                         url: UrlThirdParty.urlPathTwitter +
//                                             state.record.twitter,
//                                       )),
//                             )
//                           : Scaffold.of(context).showSnackBar(SnackBar(
//                               content: Text(Dictionary.loadTwitterUrlFailed)));
//                     },
//                   ),
// //                  GestureDetector(
// //                    child: Container(
// //                      height: 24.0,
// //                      width: 24.0,
// //                      child: Icon(
// //                        Icons.edit,
// //                        color: color.Colors.blue,
// //                      ),
// //                    ),
// //                    onTap: () {
// //                      _navigateResult(context);
// //                    },
// //                  ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildListForm(AccountProfileLoaded state) {
//     return Container(
//         padding: EdgeInsets.all(Dimens.padding),
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           children: <Widget>[
//             _buildButtonProfile(
//                 '${Environment.iconAssets}icon_profile.png',
//                 Dictionary.profile,
//                 18,
//                 NavigationConstrants.SubProfile,
//                 state.record,
//                 null,
//                 null),
//             _buildButtonProfile(
//                 '${Environment.iconAssets}icon_contact.png',
//                 Dictionary.contact,
//                 14,
//                 NavigationConstrants.SubContact,
//                 state.record,
//                 null,
//                 13),
//             _buildButtonProfile(
//                 '${Environment.iconAssets}icon_address.png',
//                 Dictionary.address,
//                 21,
//                 NavigationConstrants.SubAddress,
//                 state.record,
//                 null,
//                 7),
//             _buildButtonProfile(
//                 '${Environment.iconAssets}icon_mission.png',
//                 Dictionary.mission,
//                 18,
//                 NavigationConstrants.Mission,
//                 null,
//                 null,
//                 null),
//             _buildButtonProfile(
//                 '${Environment.iconAssets}icon_privacy_policy.png',
//                 Dictionary.privacyPolicy,
//                 18,
//                 NavigationConstrants.Browser,
//                 UrlThirdParty.privacyPolicy,
//                 null,
//                 null),
//             _buildButtonProfile('${Environment.iconAssets}icon_app_version.png',
//                 'App Version', 18, '', null, _versionText, null),
//             _buildButtonProfile(
//                 '${Environment.iconAssets}icon_key_password.png',
//                 'Ubah Password',
//                 18,
//                 NavigationConstrants.ChangePassword,
//                 ChangePasswordType.profile,
//                 null,
//                 null),
//             SizedBox(
//               height: 20,
//             ),
//             RoundedButton(
//               title: 'Keluar',
//               borderRadius: BorderRadius.circular(5.0),
//               color: color.Colors.darkRed,
//               textStyle: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold),
//               onPressed: () {
//                 showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text(Dictionary.confirmExitTitle),
//                         content: Text(Dictionary.confirmExit),
//                         actions: <Widget>[
//                           FlatButton(
//                             child: Text(Dictionary.yes),
//                             onPressed: () async {
//                               await AuthProfileRepository()
//                                   .deleteLocalUserInfo();
//                               await HumasJabarRepository().truncateLocal();
//                               _authenticationBloc.add(LoggedOut());
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                           FlatButton(
//                             child: Text(Dictionary.cancel),
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                           )
//                         ],
//                       );
//                     });
//               },
//             ),
//           ],
//         ));
//   }

//   Widget _buildButtonProfile(
//       String iconProfile,
//       String title,
//       double sizeWidthIcon,
//       String navigationName,
//       Object userInfoModel,
//       String versionName,
//       double leftPadding) {
//     return GestureDetector(
//       child: Container(
//         color: Colors.white,
//         child: Stack(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Container(
//                   padding: EdgeInsets.only(top: 18, bottom: 18),
//                   child: Row(
//                     children: <Widget>[
//                       Image.asset(
//                         iconProfile,
//                         fit: BoxFit.fitWidth,
//                         width: sizeWidthIcon,
//                       ),
//                       Container(
//                         padding: EdgeInsets.only(
//                             left: leftPadding != null ? leftPadding : 10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Container(
//                               padding: EdgeInsets.only(left: 8.0),
//                               width: 150.0,
//                               child: Text(
//                                 title,
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 versionName == null
//                     ? Image.asset(
//                         '${Environment.iconAssets}direct_page.png',
//                         fit: BoxFit.fitWidth,
//                         width: 8,
//                       )
//                     : Container(
//                         child: Text(
//                           versionName,
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 16.0,
//                           ),
//                         ),
//                       )
//               ],
//             ),
//             Positioned(
//               bottom: 0,
//               child: Container(
//                 margin: EdgeInsets.only(left: 30, top: 15),
//                 color: color.Colors.grey,
//                 height: 1,
//                 width: MediaQuery.of(context).size.width,
//               ),
//             )
//           ],
//         ),
//       ),
//       onTap: () async {
//         var result;
//         if (userInfoModel != null) {
//           result = await Navigator.of(context)
//               .pushNamed(navigationName, arguments: userInfoModel);
//         } else {
//           result = await Navigator.of(context).pushNamed(navigationName);
//         }

//         if (result != null) {
//           if (result == Dictionary.successSaveProfile) {
//             _accountProfileBloc.add(AccountProfileLoad());
//           }
//         }
//       },
//     );
//   }

//   Widget _buildButtonProfileLoading(String iconProfile, String title,
//       double sizeWidthIcon, double leftPadding) {
//     return Container(
//       child: Stack(
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Container(
//                 padding: EdgeInsets.only(top: 18, bottom: 18),
//                 child: Row(
//                   children: <Widget>[
//                     Skeleton(
//                         child: Container(
//                       height: 21,
//                       width: 21,
//                       decoration: BoxDecoration(
//                           color: Colors.grey[300],
//                           borderRadius: BorderRadius.circular(4)),
//                     )),
//                     Container(
//                       padding: EdgeInsets.only(
//                           left: leftPadding != null ? leftPadding : 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             padding: EdgeInsets.only(left: 8.0),
//                             width: 150.0,
//                             child: Skeleton(
//                               child: Text(
//                                 title,
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Skeleton(
//                   child: Icon(
//                 Icons.arrow_forward_ios,
//                 size: 17,
//               ))
//             ],
//           ),
//           Positioned(
//             bottom: 0,
//             child: Skeleton(
//               child: Container(
//                 margin: EdgeInsets.only(left: 30, top: 15),
//                 color: color.Colors.grey,
//                 height: 1,
//                 width: MediaQuery.of(context).size.width,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildForm(AccountProfileLoaded state) {
//     return Container(
//       padding: EdgeInsets.all(Dimens.padding),
//       width: MediaQuery.of(context).size.width,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           _buildFieldTitle(Dictionary.profile),
//           _buildFieldValue(Dictionary.name, state.record.name, FontWeight.w600),
//           _buildFieldValue(
//               Dictionary.birthDate,
//               state.record.birthDate != null
//                   ? DateFormat('dd - MM - yyyy', 'id')
//                       .format(state.record.birthDate)
//                   : null,
//               FontWeight.w600),
//           _buildFieldValue(
//               Dictionary.education,
//               state.record.educationLevel != null
//                   ? state.record.educationLevel.title
//                   : null,
//               FontWeight.w600),
//           _buildFieldValue(
//               Dictionary.job,
//               state.record.jobType != null ? state.record.jobType.title : null,
//               FontWeight.w600),
//           _buildFieldValue(
//               Dictionary.username, state.record.username, FontWeight.w600),
//           Divider(),
//           _buildFieldTitle(Dictionary.contact),
//           _buildFieldValue(Dictionary.email, state.record.email),
//           _buildFieldValue(Dictionary.telephone, state.record.phone),
//           Divider(),
//           _buildFieldTitle(Dictionary.address),
//           _buildFieldValue(Dictionary.fullAddress, state.record.address),
//           _buildFieldValue(Dictionary.kabkota,
//               StringUtils.capitalizeWord(state.record.kabkota.name)),
//           _buildFieldValue(Dictionary.kecamatan,
//               StringUtils.capitalizeWord(state.record.kecamatan.name)),
//           _buildFieldValue(Dictionary.kelurahan,
//               StringUtils.capitalizeWord(state.record.kelurahan.name)),
//           _buildFieldValue(Dictionary.rt, state.record.rt),
//           _buildFieldValue(Dictionary.rw, state.record.rw),
//         ],
//       ),
//     );
//   }

//   Widget _buildFieldTitle(String title) {
//     return Container(
//       width: MediaQuery.of(context).size.width / 2.7,
//       padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
//       child: Text(
//         title,
//         style: TextStyle(
//             color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
//         textAlign: TextAlign.left,
//       ),
//     );
//   }

//   Widget _buildFieldValue(String name, String value, [FontWeight fontWeight]) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
//           width: 150.0,
//           child: Text(
//             name,
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 16.0,
//             ),
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
//           width: MediaQuery.of(context).size.width / 2.8,
//           child: Text(
//             _checkedString(value),
//             textAlign: TextAlign.left,
//             maxLines: 2,
//             style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 16.0,
//                 fontWeight:
//                     fontWeight != null ? fontWeight : FontWeight.normal),
//           ),
//         )
//       ],
//     );
//   }

//   String _checkedString(String namePath) {
//     if (namePath != null) {
//       return namePath;
//     } else {
//       return "-";
//     }
//   }

//   void _onWidgetDidBuild(Function callback) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       callback();
//     });
//   }

//   void _cameraBottomSheet(context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return Container(
//             child: Wrap(
//               children: <Widget>[
//                 ListTile(
//                   leading: Icon(Icons.camera),
//                   title: Text(Dictionary.takePhoto),
//                   onTap: () {
//                     _permissionCamera();
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.image),
//                   title: Text(Dictionary.takePhotoFromGallery),
//                   onTap: () {
//                     _permissionGallery();
//                   },
//                 ),
//               ],
//             ),
//           );
//         });
//   }

//   void _permissionGallery() async {
//     PermissionStatus permission = await PermissionHandler()
//         .checkPermissionStatus(PermissionGroup.storage);

//     if (permission != PermissionStatus.granted) {
//       unawaited(showDialog(
//           context: context,
//           builder: (BuildContext context) => DialogRequestPermission(
//                 image: Image.asset(
//                   'assets/icons/folder.png',
//                   fit: BoxFit.contain,
//                   color: Colors.white,
//                 ),
//                 description: Dictionary.permissionGalery,
//                 onOkPressed: () {
//                   Navigator.of(context).pop();
//                   PermissionHandler().requestPermissions(
//                       [PermissionGroup.storage]).then(_onStatusRequested);
//                 },
//               )));
//     } else {
//       await openGallery();
//     }
//   }

//   void _onStatusRequested(
//       Map<PermissionGroup, PermissionStatus> statuses) async {
//     final statusStorage = statuses[PermissionGroup.storage];
//     if (statusStorage == PermissionStatus.granted) {
//       _permissionGallery();
//     }
//   }

//   Future openGallery() async {
//     File _image;
//     var image = await ImagePicker.pickImage(
//         source: ImageSource.gallery, maxHeight: 640, maxWidth: 640);

//     if (image != null && image.path != null) {
//       image = await FlutterExifRotation.rotateImage(path: image.path);
//       if (image != null) {
//         setState(() {
//           _image = image;
//           _blocProfile.add(AccountProfileEditPhotoSubmit(
//               image: _image, userInfoModel: stateLoadProfile.record));
//         });
//       }
//     }

//     isShowDialog = true;

//     Navigator.of(context, rootNavigator: true).pop('dialog');
//   }

//   void _permissionCamera() async {
//     PermissionStatus permission =
//         await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

//     if (permission != PermissionStatus.granted) {
//       unawaited(showDialog(
//           context: context,
//           builder: (BuildContext context) => DialogRequestPermission(
//                 image: Image.asset(
//                   'assets/icons/photo-camera.png',
//                   fit: BoxFit.contain,
//                   color: Colors.white,
//                 ),
//                 description: Dictionary.permissionCamera,
//                 onOkPressed: () {
//                   Navigator.of(context).pop();
//                   PermissionHandler().requestPermissions(
//                       [PermissionGroup.camera]).then(_onStatusRequestedCamera);
//                 },
//               )));
//     } else {
//       await openCamera();
//     }
//   }

//   Future openCamera() async {
//     var image = await ImagePicker.pickImage(
//         source: ImageSource.camera, maxHeight: 640, maxWidth: 640);
//     File _image;

//     if (image != null && image.path != null) {
//       image = await FlutterExifRotation.rotateImage(path: image.path);
//       if (image != null) {
//         setState(() {
//           _image = image;
//           _blocProfile.add(AccountProfileEditPhotoSubmit(
//               image: _image, userInfoModel: stateLoadProfile.record));
//         });
//       }
//     }

//     isShowDialog = true;

//     Navigator.of(context, rootNavigator: true).pop('dialog');
//   }

//   void hideLoading() {
//     loadingDialog.hide().then((isHidden) {});
//   }

//   void _onStatusRequestedCamera(
//       Map<PermissionGroup, PermissionStatus> statuses) {
//     final status = statuses[PermissionGroup.camera];
//     if (status == PermissionStatus.granted) {
//       _permissionCamera();
//     }
//   }

//   // TODO: harus dibuat component supaya bisa di reuse
//   void showLoading() {
//     loadingDialog = ProgressDialog(context);
//     loadingDialog.style(
//         message: 'Silahkan Tunggu...',
//         borderRadius: 10.0,
//         backgroundColor: Colors.white,
//         progressWidget: CircularProgressIndicator(),
//         elevation: 10.0,
//         insetAnimCurve: Curves.easeInOut,
//         progress: 0.0,
//         maxProgress: 100.0,
//         progressTextStyle: TextStyle(
//             color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
//         messageTextStyle: TextStyle(
//             color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
//     loadingDialog.show();
//   }

//   @override
//   void dispose() {
//     _accountProfileBloc.close();
//     _blocProfile.close();
//     _gamificationsMyBadgeBloc.close();
//     super.dispose();
//   }
// }
