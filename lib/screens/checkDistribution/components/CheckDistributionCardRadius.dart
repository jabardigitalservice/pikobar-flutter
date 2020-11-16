import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/blocs/checkDIstribution/CheckdistributionBloc.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';

class CheckDistributionCardRadius extends StatelessWidget {
  final CheckDistributionLoaded state;
  final Map<String, dynamic> getLabel;
  final RemoteConfig remoteConfig;
  final formatter = new NumberFormat("#,###");

  CheckDistributionCardRadius(
      {Key key, @required this.state, this.getLabel, this.remoteConfig})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get label from the remote config
    Map<String, dynamic> labelUpdateTerkini =
    RemoteConfigHelper.decode(remoteConfig: remoteConfig, firebaseConfig: FirebaseConfig.labels, defaultValue: FirebaseConfig.labelsDefaultValue);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(
        top: Dimens.padding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              StringUtils.capitalizeWord(
                  '${Dictionary.location} ${state.record.currentLocation.namaKel} , kec. ${state.record.currentLocation.namaKec}'),
              style: TextStyle(
                fontFamily: FontsFamily.lato,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
                height: 1.2,
              ),
            ),
            SizedBox(height: 5),
            Text(
              Dictionary.update24hourTitle,
              style: TextStyle(
                color: Colors.black,
                fontFamily: FontsFamily.lato,
                fontSize: 10.0,
                height: 1.2,
              ),
            ),
            SizedBox(height: Dimens.padding),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: ColorBase.gradientBlueStatistics),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Stack(
                children: [
                  Positioned(
                      width: 60.0,
                      height: 60.0,
                      right: 0.0,
                      top: 0.0,
                      child: Image.asset(
                        '${Environment.iconAssets}virus_purple.png',
                        width: 60.0,
                        height: 60.0,
                      )),
                  Container(
                    margin: EdgeInsets.all(Dimens.padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labelUpdateTerkini['statistics']['confirmed'],
                          style: TextStyle(
                              fontFamily: FontsFamily.lato,
                              fontSize: 12.0,
                              color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            formattedStringNumber(state
                                .record.detected.desa.confirmation
                                .toString()),
                            style: TextStyle(
                                fontFamily: FontsFamily.lato,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: Dimens.padding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildCard(context,
                    image: '',
                    title: getLabel['check_distribution']['by_radius']
                        ['close_contact'],
                    total: state.record.detected.desa.closecontactDikarantina,
                    textColor: Colors.black),
                buildCard(context,
                    image: '',
                    title: getLabel['check_distribution']['by_radius']
                        ['suspect'],
                    total: state.record.detected.desa.suspectDiisolasi,
                    textColor: Colors.black),
                buildCard(context,
                    image: '',
                    title: getLabel['check_distribution']['by_radius']
                        ['probable'],
                    total: state.record.detected.desa.probable,
                    textColor: Colors.black),
              ],
            )
          ],
        ),
      ),
    );
  }

  Expanded buildCard(BuildContext context,
      {String image,
      @required String title,
      @required int total,
      Color textColor}) {
    return Expanded(
      child: Container(
        width: (MediaQuery.of(context).size.width / 3),
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 15, bottom: 15),
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            color: Color(0xffFAFAFA), borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            image.isNotEmpty
                ? Container(height: 15, child: Image.asset(image))
                : Container(),
            Container(
              margin: EdgeInsets.only(left: 5.0, top: Dimens.padding),
              child: Text(title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                      fontFamily: FontsFamily.lato)),
            ),
            Container(
              margin: EdgeInsets.only(top: Dimens.padding, left: 5.0),
              child: Text(total.toString(),
                  style: TextStyle(
                      color: textColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsFamily.roboto)),
            ),
          ],
        ),
      ),
    );
  }

  String formattedStringNumber(String number) {
    String num = '';
    if (number != null && number.isNotEmpty && number != '-') {
      try {
        num = formatter.format(int.parse(number)).replaceAll(',', '.');
      } catch (e) {
        print(e.toString());
      }
    }
    return num;
  }
}
