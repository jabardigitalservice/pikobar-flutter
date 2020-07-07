import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class SurveillanceDetailScreen extends StatefulWidget {
  @override
  _SurveillanceDetailScreenState createState() =>
      _SurveillanceDetailScreenState();
}

class _SurveillanceDetailScreenState extends State<SurveillanceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: 'Detail Pemantauan Harian'),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Image.asset('${Environment.iconAssets}calendar_1.png',
                          width: 39, height: 39),

                      SizedBox(width: 16.0),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Pemantauan Hari ke-1',
                            style: TextStyle(
                                fontFamily: FontsFamily.lato,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                height: 1.214),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Proses pemantauan sudah terisi',
                            style: TextStyle(
                                fontFamily: FontsFamily.lato,
                                fontSize: 12.0,
                                height: 1.1667),
                          )
                        ],
                      )
                    ],
                  ),
                ),

                SizedBox(height: 32.0,),

                /// Input date section
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Tanggal Pengisian',
                        style: TextStyle(
                            fontFamily: FontsFamily.lato,
                            fontSize: 12.0,
                            height: 1.1667),
                      ),
                      Text(
                        '2 Juli 2020',
                        style: TextStyle(
                            fontFamily: FontsFamily.lato,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            height: 1.1667),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          /// Divider
          Container(
            height: 8.0,
            color: ColorBase.grey,
          ),

          /// Temperature section
          Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.padding, vertical: 24.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Suhu Tubuh',
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontSize: 12.0,
                      height: 1.1667),
                ),
                Text(
                  '38° C',
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      height: 1.1667),
                )
              ],
            ),
          ),

          /// Divider
          Container(
            height: 8.0,
            color: ColorBase.grey,
          ),

          /// The symptoms section
          Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.padding, vertical: 24.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    'Gejala yang Dirasakan',
                    style: TextStyle(
                        fontFamily: FontsFamily.lato,
                        fontSize: 12.0,
                        height: 1.1667),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Demam, Batuk, Pilek, Sakit Tenggorokan, Sesak Nafas',
                    style: TextStyle(
                        fontFamily: FontsFamily.lato,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        height: 1.1667),
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
          ),

          /// Back button section
          Container(
            height: 38.0,
            margin: EdgeInsets.all(Dimens.padding),
            child: RaisedButton(
                splashColor: Colors.lightGreenAccent,
                color: ColorBase.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(Dictionary.back,
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      color: Colors.white),
                ),
                onPressed: () {
                }),
          )
        ],
      ),
    );
  }
}
