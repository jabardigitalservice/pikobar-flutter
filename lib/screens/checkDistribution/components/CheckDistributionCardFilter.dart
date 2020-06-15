import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class CheckDistributionCardFilter extends StatelessWidget {
  final String region;
  final int countPositif;
  final int countOdp;
  final int countPdp;
  final String typeRegion;

  const CheckDistributionCardFilter(
      {Key key,
      @required this.region,
      @required this.countPositif,
      @required this.countOdp,
      @required this.countPdp,
      @required this.typeRegion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: Dimens.padding, ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Text.rich(
              //   TextSpan(
              //     children: <TextSpan>[
              //       TextSpan(
              //         text: '${Dictionary.regionInfo} $typeRegion ',
              //         style: TextStyle(
              //           color: Colors.grey[600],
              //           fontFamily: FontsFamily.productSans,
              //           fontSize: 14.0,
              //           height: 1.5,
              //         ),
              //       ),
              //       TextSpan(
              //         text: region,
              //         style: TextStyle(
              //           color: Colors.grey[600],
              //           fontFamily: FontsFamily.productSans,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 14.0,
              //           height: 1.5,
              //         ),
              //       )
              //     ],
              //   ),
              // ),

              // build location by sub city
              _buildContent(context, countPositif, Dictionary.confirmed,
                  '${Environment.iconAssets}virusRed.png', Color(0xffEB5757)),

              // build ODP
              _buildContent(context, countOdp, Dictionary.odp,
                  '${Environment.iconAssets}virus_3.png', Color(0xff2F80ED)),

              // build PDP
              _buildContent(context, countPdp, Dictionary.pdp,
                  '${Environment.iconAssets}virusYellow.png', Color(0xffF2C94C)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, int count, String title, image, Color textColor) {
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
            Container(height: 15, child: Image.asset(image)),
            Container(
              margin: EdgeInsets.only(top: Dimens.padding, left: 5.0),
              child: Text(count.toString(),
                  style: TextStyle(
                      color: textColor,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsFamily.roboto)),
            ),
            Container(
              margin: EdgeInsets.only(left: 5.0, top: Dimens.padding),
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
