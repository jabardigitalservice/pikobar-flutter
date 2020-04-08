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
      margin: const EdgeInsets.only(top: Dimens.padding, left: 5, right: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${Dictionary.locationRadiusTitle} ${state.record.detected.radius.kmRadius.toString()} km',
              style: TextStyle(
                fontFamily: FontsFamily.productSans,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                height: 1.2,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Update Terakhir 6 April 2020',
              style: TextStyle(
                color: Colors.grey[600],
                fontFamily: FontsFamily.productSans,
                fontSize: 14.0,
                height: 1.2,
              ),
            ),
            SizedBox(height: Dimens.padding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                buildCard(context,
                    image: '${Environment.imageAssets}bg-positif.png',
                    title: Dictionary.positifTitle,
                    total: state.record.detected.radius.positif),
                buildCard(context,
                    image: '${Environment.imageAssets}bg-meninggal.png',
                    title: Dictionary.odp,
                    total: state.record.detected.radius.odpProses),
                buildCard(context,
                    image: '${Environment.imageAssets}bg-pdp.png',
                    title: Dictionary.pdp,
                    total: state.record.detected.radius.pdpProses),
              ],
            )
          ],
        ),
      ),
    );
  }

  Expanded buildCard(BuildContext context,
      {String image, @required String title, @required int total}) {
    return Expanded(
      child: Container(
        width: (MediaQuery.of(context).size.width / 3),
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 15, bottom: 15),
        margin: EdgeInsets.symmetric(horizontal: 2.5),
        decoration: BoxDecoration(
            color: Colors.white,
            image: total > 0
                ? DecorationImage(fit: BoxFit.fill, image: AssetImage(image))
                : null,
            boxShadow: total == 0
                ? <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 0.0,
                      offset: Offset(0.0, 0.0),
                    ),
                  ]
                : null,
            borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13.0,
                            color: total > 0 ? Colors.white : Colors.grey[400],
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.productSans)),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: Dimens.padding, left: 5.0),
                  child: Text(total.toString(),
                      style: TextStyle(
                          color: total > 0 ? Colors.white : Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsFamily.productSans)),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: Dimens.padding, left: 4.0, bottom: 2.0),
                    child: Text('Orang',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: total > 0 ? Colors.white : Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.productSans)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
