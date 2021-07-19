import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/CheckDistribution.dart';

class CheckDistributionCardFilter extends StatelessWidget {
  final String statusType;
  final List<DesaLainnya> listOtherVillage;

  const CheckDistributionCardFilter({
    Key key,
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
    } else {
      return dataOtherVillage.probable.toString();
    }
  }

  Widget _buildStatusContent(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: Dimens.padding, top: 10.0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: listOtherVillage.length,
        itemBuilder: (context, index) {
          final DesaLainnya dataOtherVillage = listOtherVillage[index];
          return dataOtherVillage.namaDesa == ''
              ? Container()
              : Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            '${Environment.iconAssets}pin_location_red.png',
                            scale: 2.5,
                          ),
                          const SizedBox(width: 14),
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
                      padding: const EdgeInsets.only(
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
                );
        });
  }
}
