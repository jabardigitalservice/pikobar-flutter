import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class CheckDistributionScreen extends StatefulWidget {
  @override
  _CheckDistributionScreenState createState() =>
      _CheckDistributionScreenState();
}

class _CheckDistributionScreenState extends State<CheckDistributionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Dictionary.checkDistribution)),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(Dimens.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // box section banner
                  Container(
                    height: 100.0,
                    child: Card(
                      color: Color(0xFFF2C94C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 16.0, 16.0, 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    Dictionary.checkDistributionTitle,
                                    style: TextStyle(
                                        fontFamily: FontsFamily.productSans,
                                        fontSize: 16.0,
                                        height: 1.2,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // SizedBox(height: 8),
                                Expanded(
                                  child: Text(
                                    Dictionary.checkDistributionSubTitle,
                                    style: TextStyle(
                                      fontFamily: FontsFamily.productSans,
                                      fontSize: 12.0,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Image.asset(
                              '${Environment.imageAssets}people_corona2.png',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  boxContainer(
                    Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(
                          top: Dimens.padding, left: 5, right: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          // box section address
                          Container(
                            padding: const EdgeInsets.all(Dimens.padding),
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  '${Environment.iconAssets}pin.png',
                                  scale: 1.5,
                                ),
                                SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        Dictionary.currentLocationTitle,
                                        style: TextStyle(
                                          fontFamily: FontsFamily.productSans,
                                          color: Colors.grey[600],
                                          fontSize: 12.0,
                                          height: 1.2,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Batununggal, Bandung Kidul, Kota Bandung',
                                        style: TextStyle(
                                          fontFamily: FontsFamily.productSans,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                          // Box section button
                          Container(
                            padding: const EdgeInsets.fromLTRB(Dimens.padding,
                                8.0, Dimens.padding, Dimens.padding),
                            child: Column(
                              children: <Widget>[
                                RoundedButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    title: Dictionary.checkCurrentLocation,
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: ColorBase.green,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .subhead
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                    onPressed: () {}),
                                SizedBox(height: 10),
                                RoundedButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    title: Dictionary.checkOtherLocation,
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.white,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .subhead
                                        .copyWith(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                    onPressed: () {}),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Box Results
                  // CircularProgressIndicator(
                  //     valueColor: AlwaysStoppedAnimation<Color>(ColorBase.green))
                  boxContainer(
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Positif: 0',
                              style: TextStyle(
                                fontFamily: FontsFamily.productSans,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              Dictionary.positifString,
                              style: TextStyle(
                                fontFamily: FontsFamily.productSans,
                                color: Colors.grey[600],
                                fontSize: 12.0,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Box
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Tetap tenang dan kenali lebih dekat apa itu COVID-19. \n Klik selengkapnya disini',
                          style: TextStyle(
                            fontFamily: FontsFamily.productSans,
                            color: Colors.grey[600],
                            fontSize: 12.0,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget boxContainer(Widget child) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 20.0, // soften the shadow
            spreadRadius: 10.0, //extend the shadow
            offset: Offset(
              1.0, // Move to right 1  horizontally
              1.0, // Move to bottom 1 Vertically
            ),
          )
        ],
      ),
      child: child,
    );
  }
}
