import 'package:flutter/material.dart';
import 'package:pikobar_flutter/blocs/checkDIstribution/CheckdistributionBloc.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class CheckDistributionCardRadius extends StatelessWidget {
  final CheckDistributionLoaded state;

  CheckDistributionCardRadius({Key key, @required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: Dimens.padding, ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${Dictionary.locationRadiusTitle} ${state.record.detected.radius.kmRadius.toString()} km',
            style: TextStyle(
              fontFamily: FontsFamily.lato,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              height: 1.2,
            ),
          ),
          SizedBox(height: 5),
          Text(
            Dictionary.update24hourTitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontFamily: FontsFamily.lato,
              fontSize: 14.0,
              height: 1.2,
            ),
          ),
          SizedBox(height: Dimens.padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildCard(context,
                  image: '${Environment.iconAssets}virusRed.png',
                  title: Dictionary.confirmed,
                  total: state.record.detected.radius.positif,textColor: Color(0xffEB5757)),
              buildCard(context,
                  image: '${Environment.iconAssets}virus_3.png',
                  title: Dictionary.odp,
                  total: state.record.detected.radius.odpProses,textColor: Color(0xff2F80ED)),
              buildCard(context,
                  image: '${Environment.iconAssets}virusYellow.png',
                  title: Dictionary.pdp,
                  total: state.record.detected.radius.pdpProses,textColor: Color(0xffF2C94C)),
            ],
          )
        ],
      ),
    );
  }

  Expanded buildCard(BuildContext context,
      {String image, @required String title, @required int total, Color textColor}) {
    return Expanded(
      child: Container(
        width: (MediaQuery.of(context).size.width / 3),
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 15, bottom: 15),
        margin: EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
            color: Color(0xffFAFAFA), borderRadius: BorderRadius.circular(8.0)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(height: 15, child: Image.asset(image)),
            Container(
              margin: EdgeInsets.only(top: Dimens.padding, left: 5.0),
              child: Text(total.toString(),
                  style: TextStyle(
                      color: textColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsFamily.roboto)),
            ),
            Container(
              margin: EdgeInsets.only(left: 5.0,top:Dimens.padding),
              child: Text(title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsFamily.lato)),
            ),
          ],
        ),
      ),
    );
  }
}
