import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportActivationScreen.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportList.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportOtherScreen.dart';

class SelfReportOption extends StatefulWidget {
  final LatLng location;
  final String cityId;
  final bool isHealthStatusChanged;
  final bool isQuarantined;
  final Map<String, dynamic> nikMessage;

  SelfReportOption(
      {Key key,
      this.location,
      this.cityId,
      this.isHealthStatusChanged,
      this.isQuarantined,
      this.nikMessage})
      : super(key: key);

  @override
  _SelfReportOptionState createState() => _SelfReportOptionState();
}

class _SelfReportOptionState extends State<SelfReportOption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.animatedAppBar(
          showTitle: false,
          title: Dictionary.dailySelfReport,
        ),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  Dimens.padding, 10, Dimens.padding, 20),
              child: Text(
                Dictionary.dailySelfReport,
                style: TextStyle(
                    fontFamily: FontsFamily.lato,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  _buildContainer(
                      imageEnable:
                          '${Environment.iconAssets}self_report_icon.png',
                      title: Dictionary.reportForMySelf,
                      length: 2,
                      disabledTextColor: ColorBase.grey800,
                      onPressedEnable: () {
                        // move to self report list screen
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SelfReportList(
                                  location: widget.location,
                                  cityId: widget.cityId,
                                  analytics: Analytics.tappedDailyReport,
                                  isHealthStatusChanged:
                                      widget.isHealthStatusChanged,
                                )));
                      },
                      onPressedDisable: () {
                        // move to self report activation screen
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SelfReportActivationScreen(
                                  location: widget.location,
                                  cityId: widget.cityId,
                                )));
                      },
                      isEnabledMenu: widget.isQuarantined),
                  _buildContainer(
                      imageEnable:
                          '${Environment.iconAssets}self_report_other_icon.png',
                      title: Dictionary.reportForOther,
                      length: 2,
                      onPressedEnable: () {
                        // move to self report other screen
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SelfReportOtherScreen(
                                  cityId: widget.cityId,
                                  location: widget.location,
                                )));
                      },
                      isEnabledMenu: true)
                ],
              ),
            )
          ],
        ));
  }

  /// Function for build widget button self report
  _buildContainer(
      {String imageDisable,
      @required String imageEnable,
      @required String title,
      @required int length,
      @required GestureTapCallback onPressedEnable,
      GestureTapCallback onPressedDisable,
      @required bool isEnabledMenu,
      Color disabledTextColor}) {
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
                  child: Image.asset(isEnabledMenu
                      ? imageEnable
                      : imageDisable ?? imageEnable)),
              Container(
                margin: const EdgeInsets.only(top: 15, right: 10.0),
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: isEnabledMenu
                          ? ColorBase.grey800
                          : disabledTextColor ?? ColorBase.grey500,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsFamily.roboto,
                      height: 1.3),
                ),
              )
            ],
          ),
        ),
        onPressed: isEnabledMenu ? onPressedEnable : onPressedDisable ?? () {},
      ),
    ));
  }
}
