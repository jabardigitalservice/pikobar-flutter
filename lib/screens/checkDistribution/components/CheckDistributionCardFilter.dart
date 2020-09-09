import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/CheckDistribution.dart';

class CheckDistributionCardFilter extends StatelessWidget {
  final String region;
  final int countPositif;
  final int countOdp;
  final int countPdp;
  final String typeRegion;
  final Map<String, dynamic> getLabel;
  final String statusType;
  final List<DesaLainnya> listOtherVillage;

  const CheckDistributionCardFilter({
    Key key,
    @required this.region,
    @required this.countPositif,
    @required this.countOdp,
    @required this.countPdp,
    @required this.typeRegion,
    @required this.getLabel,
    @required this.listOtherVillage,
    @required this.statusType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildStatusContent(context);
  }

  // ignore: missing_return
  String statusCount(DesaLainnya dataOtherVillage) {
    if (statusType == Dictionary.confirmed) {
      return dataOtherVillage.confirmation.toString();
    } else if (statusType == Dictionary.closeContact) {
      return dataOtherVillage.closecontactDikarantina.toString();
    } else if (statusType == Dictionary.suspect) {
      return dataOtherVillage.suspectDiisolasi.toString();
    } else if (statusType == Dictionary.probable) {
      return dataOtherVillage.probable.toString();
    }
  }

  Widget _buildStatusContent(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: Dimens.padding, top: 10.0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: listOtherVillage.length,
        itemBuilder: (context, index) {
          final DesaLainnya dataOtherVillage = listOtherVillage[index];

          return Container(
              child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      '${Environment.iconAssets}pin_location_red.png',
                      scale: 2.5,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        "Kel. " + dataOtherVillage.namaDesa,
                        style: TextStyle(
                          fontFamily: FontsFamily.lato,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Text(
                      statusCount(dataOtherVillage),
                      style: TextStyle(
                        fontFamily: FontsFamily.lato,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: Dimens.padding,
                    bottom: Dimens.padding,
                    left: Dimens.padding,
                    right: Dimens.padding),
                child: SizedBox(
                  height: 1,
                  child: Container(
                    color: Colors.grey[200],
                  ),
                ),
              )
            ],
          ));
        });
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
