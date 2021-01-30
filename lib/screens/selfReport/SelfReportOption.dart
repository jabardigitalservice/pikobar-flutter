import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportList.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportOtherScreen.dart';

class SelfReportOption extends StatefulWidget {
  final LatLng location;

  SelfReportOption({Key key, this.location}) : super(key: key);

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
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Text(
                Dictionary.dailySelfReport,
                style: TextStyle(
                    fontFamily: FontsFamily.lato,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                _buildContainer('${Environment.iconAssets}self_report_icon.png',
                    Dictionary.reportForMySelf, 2, () {
                  // move to self report list screen
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SelfReportList(
                          location: widget.location,
                          analytics: Analytics.tappedDailyReport)));
                }, true),
                _buildContainer(
                    '${Environment.iconAssets}self_report_other_icon.png',
                    Dictionary.reportForOther,
                    2, () {
                  // move to self report other screen
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SelfReportOtherScreen(
                            location: widget.location,
                          )));
                }, true)
              ],
            )
          ],
        ));
  }

  /// Function for build widget button self report
  _buildContainer(String image, String title, int length,
      GestureTapCallback onPressed, bool isShowMenu) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: RaisedButton(
        elevation: 0,
        padding: EdgeInsets.all(0.0),
        color: ColorBase.greyContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          width: (MediaQuery.of(context).size.width / length),
          padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 15, bottom: 15),
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(height: 30, child: Image.asset(image)),
              Container(
                margin: EdgeInsets.only(top: 15, left: 5.0, right: 10.0),
                child: Text(title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: ColorBase.grey800,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.roboto)),
              )
            ],
          ),
        ),
        onPressed: isShowMenu ? onPressed : null,
      ),
    ));
  }
}
