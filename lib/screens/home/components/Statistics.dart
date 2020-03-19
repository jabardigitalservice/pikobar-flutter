import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection('statistics')
            .document('jabar-dan-nasional')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          } else {
            var userDocument = snapshot.data;
            return _buildContent(userDocument);
          }
        });
  }

  _buildLoading() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Skeleton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Dictionary.statistics,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontsFamily.productSans,
                  fontSize: 16.0),
            ),
            SizedBox(height: Dimens.padding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildContainer('${Environment.iconAssets}virus_2.png',
                    Dictionary.positif, Dictionary.positif, '-', 3, Dictionary.people),
                _buildContainer('${Environment.iconAssets}man.png',
                    Dictionary.recover, Dictionary.recover, '-', 3, Dictionary.people),
                _buildContainer('${Environment.iconAssets}tombstone.png',
                    Dictionary.die, Dictionary.die, '-', 3, Dictionary.people),
              ],
            ),
            SizedBox(height: Dimens.padding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildContainer('${Environment.iconAssets}doctor.png',
                    Dictionary.underSupervision, Dictionary.pdpDesc, '-', 2, Dictionary.process),
                _buildContainer('${Environment.iconAssets}stethoscope.png',
                    Dictionary.inMonitoring, Dictionary.opdDesc, '-', 2, Dictionary.process),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildContent(DocumentSnapshot data) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0.0, 1),
            blurRadius: 4.0),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                Dictionary.statistics,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: FontsFamily.productSans,
                    fontSize: 16.0),
              ),
              Text(
                unixTimeStampToDateTimeWithoutDay(data['updated_at'].seconds),
                style: TextStyle(
                    color: Colors.grey[650],
                    fontFamily: FontsFamily.productSans,
                    fontSize: 12.0),
              ),
            ],
          ),
          SizedBox(height: Dimens.padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildContainer(
                  '${Environment.iconAssets}virus_2.png',
                  Dictionary.positif,
                  Dictionary.positif,
                  '${data['aktif']['jabar']}',
                  3, Dictionary.people),
              _buildContainer(
                  '${Environment.iconAssets}man.png',
                  Dictionary.recover,
                  Dictionary.recover,
                  '${data['sembuh']['jabar']}',
                  3, Dictionary.people),
              _buildContainer(
                  '${Environment.iconAssets}tombstone.png',
                  Dictionary.die,
                  Dictionary.die,
                  '${data['meninggal']['jabar']}',
                  3, Dictionary.people),
            ],
          ),
          SizedBox(height: Dimens.padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildContainer(
                  '${Environment.iconAssets}doctor.png',
                  Dictionary.underSupervision,
                  Dictionary.pdpDesc,
                  '${data['pdp']['total']['jabar']}',
                  2, Dictionary.process),
              _buildContainer(
                  '${Environment.iconAssets}stethoscope.png',
                  Dictionary.inMonitoring,
                  Dictionary.opdDesc,
                  '${data['odp']['total']['jabar']}',
                  2, Dictionary.process),
            ],
          )
        ],
      ),
    );
  }

  Container _buildContainer(
      String icon, String title, String description, String count, int length, String label) {
    return Container(
      width: (MediaQuery.of(context).size.width / length) - 21.4,
      padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 10, bottom: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(icon, width: 16.0, height: 16.0),
              Container(
                margin: EdgeInsets.only(left: 5.0),
                child: Text(title,
                    style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.productSans)),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: Dimens.padding),
                child: Text(count,
                    style: TextStyle(
                        fontSize: 22.0,
                        color: ColorBase.green,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.productSans)),
              ),
              Container(
                margin: EdgeInsets.only(top: Dimens.padding, left: 4.0, bottom: 2.0),
                child: Text(label,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.productSans)),
              )
            ],
          )
        ],
      ),
    );
  }
}
