import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/checkDIstribution/CheckdistributionBloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/Announcement.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/checkDistribution/components/CheckDistributionCardFilter.dart';
import 'package:pikobar_flutter/screens/checkDistribution/components/CheckDistributionCardRadius.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/GetLabelRemoteConfig.dart';

// ignore: must_be_immutable
class CheckDistributionDetail extends StatefulWidget {
  CheckDistributionLoaded state;
  String address;

  CheckDistributionDetail(this.state, this.address);

  @override
  _CheckDistributionDetailState createState() =>
      _CheckDistributionDetailState();
}

class _CheckDistributionDetailState extends State<CheckDistributionDetail> {
  String typeLocation = Dictionary.village;
  Map<String, dynamic> getLabel;
  RemoteConfigBloc _remoteConfigBloc;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: Dictionary.back),
      backgroundColor: Colors.white,
      body:  BlocProvider<RemoteConfigBloc>(
            create: (BuildContext context) => _remoteConfigBloc =
                RemoteConfigBloc()..add(RemoteConfigLoad()),
              child: BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
          builder: (context, remoteState) {
            return remoteState is RemoteConfigLoaded
                ? _buildContent(remoteState.remoteConfig)
                : Container();
          },
        ),
      ),
    );
  }

  Widget _buildContent(RemoteConfig remoteConfig) {
    // Get label from the remote config
    getLabel = GetLabelRemoteConfig.getLabel(remoteConfig);
    return ListView(
      padding: EdgeInsets.all(Dimens.padding),
      children: <Widget>[
        widget.state.record.detected == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ErrorContent(error: Dictionary.unreachableLocation),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 30.0),
                    child: Text(
                      Dictionary.cantFindLocation,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: FontsFamily.lato,
                        fontSize: 14.0,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Current location section
                  Card(
                    elevation: 0,
                    color: Color(0xff27AE60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${Dictionary.currentLocationTitle}',
                            style: TextStyle(
                              fontFamily: FontsFamily.lato,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 12.0,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Image.asset(
                                '${Environment.iconAssets}pin_location_white.png',
                                scale: 2.5,
                              ),
                              SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  widget.address,
                                  style: TextStyle(
                                    fontFamily: FontsFamily.lato,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
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
                  // build Section Location by radius
                  CheckDistributionCardRadius(
                    state: widget.state,
                    getLabel: getLabel,
                  ),
                  SizedBox(height: 30),
                  Text(
                    '${Dictionary.locationKecamatanTitle}',
                    style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    Dictionary.locationKecamatanDesc,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: FontsFamily.lato,
                      fontSize: 10.0,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 10),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TabBar(
                          isScrollable: true,
                          onTap: (index) {
                            if (index == 0) {
                              setState(() {
                                typeLocation = Dictionary.village;
                              });
                              AnalyticsHelper.setLogEvent(
                                  Analytics.tappedFindByVillage);
                            } else if (index == 1) {
                              setState(() {
                                typeLocation = Dictionary.districts;
                              });

                              AnalyticsHelper.setLogEvent(
                                  Analytics.tappedFindByDistricts);
                            }
                          },
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.grey,
                          indicator: BubbleTabIndicator(
                            indicatorHeight: 37.0,
                            indicatorColor: ColorBase.green,
                            tabBarIndicatorSize: TabBarIndicatorSize.tab,
                          ),
                          indicatorColor: ColorBase.green,
                          indicatorWeight: 0.1,
                          labelPadding: EdgeInsets.all(10),
                          tabs: <Widget>[
                            Tab(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color:
                                            typeLocation == Dictionary.village
                                                ? ColorBase.green
                                                : Color(0xffE0E0E0),
                                        width: 1)),
                                child: Text(
                                  Dictionary.village +
                                      ' ' +
                                      widget
                                          .state.record.currentLocation.namaKel,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: FontsFamily.lato,
                                      fontSize: 10.0),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        color:
                                            typeLocation == Dictionary.districts
                                                ? ColorBase.green
                                                : Color(0xffE0E0E0),
                                        width: 1)),
                                child: Text(
                                  Dictionary.districts +
                                      ' ' +
                                      widget
                                          .state.record.currentLocation.namaKec,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: FontsFamily.lato,
                                      fontSize: 10.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.22,
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              // show kelurahan / desa
                              CheckDistributionCardFilter(
                                region:
                                    widget.state.record.currentLocation.namaKel,
                                countPositif:
                                    widget.state.record.detected.desa.positif,
                                countOdp:
                                    widget.state.record.detected.desa.odpProses,
                                countPdp:
                                    widget.state.record.detected.desa.pdpProses,
                                typeRegion: Dictionary.village,
                                getLabel: getLabel,
                              ),

                              // show kecamatan
                              CheckDistributionCardFilter(
                                  region: widget
                                      .state.record.currentLocation.namaKec,
                                  countPositif:
                                      widget.state.record.detected.kec.positif,
                                  countOdp: widget
                                      .state.record.detected.kec.odpProses,
                                  countPdp: widget
                                      .state.record.detected.kec.pdpProses,
                                  typeRegion: Dictionary.districts,
                                  getLabel: getLabel),
                            ],
                          ),
                        ),

                        /// Set up for show announcement widget
                        Announcement(
                          title: Dictionary.disclaimer,
                          content: Dictionary.informationLocation,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 10),
                          child: RichText(
                            textAlign: TextAlign.center,
                            softWrap: true,
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: Dictionary.checkDistributionInfo,
                                  style: TextStyle(
                                    fontFamily: FontsFamily.lato,
                                    color: Colors.grey[600],
                                    fontSize: 12.0,
                                    height: 1.3,
                                  ),
                                ),
                                TextSpan(
                                    text: Dictionary.here,
                                    style: TextStyle(
                                      fontFamily: FontsFamily.lato,
                                      color: Colors.blue,
                                      fontSize: 12.0,
                                      height: 1.3,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushNamed(
                                            context, NavigationConstrants.Faq);
                                      })
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 22),
                      ],
                    ),
                  ),
                ],
              )
      ],
    );
  }

  Widget boxContainer(Widget child) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 20.0, // soften the shadow
            spreadRadius: 10.0, //extend the shadow
            offset: Offset(
              1.0, // Move to right 1  horizontally
              1.0, // Move to bottom 1 Vertically
            ),
          )
        ],
      ),
      child: child,
    );
  }
}
