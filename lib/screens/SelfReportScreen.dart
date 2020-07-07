import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class SelfReportScreen extends StatefulWidget {
  @override
  _SelfReportScreenState createState() => _SelfReportScreenState();
}

class _SelfReportScreenState extends State<SelfReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.defaultAppBar(
          title: Dictionary.titleSelfReport,
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              buildAnnouncement(),
              SizedBox(
                height: 10,
              ),
              location(),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildContainer(
                      '${Environment.iconAssets}calendar_disable.png',
                      'Pemantauan Harian',
                      2),
                  _buildContainer(
                      '${Environment.iconAssets}history_contact_disable.png',
                      'Riwayat Kontak',
                      2),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Konten Edukasi',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontsFamily.lato,
                      fontSize: 14.0),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Unduh file dibawah ini untuk mendapatkan Edukasi terkait isolasi mandiri',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: FontsFamily.lato,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 15,
              ),
             Container(
               padding: EdgeInsets.only(left: 10, right: 10),
               child:  OutlineButton(
                 splashColor: Colors.green,
                 highlightColor: Colors.white,
                 padding: EdgeInsets.all(0.0),
                 color: Colors.white,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(8.0),
                 ),
                 child: Row(
                   children: <Widget>[
                     Container(
                       margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                       child: CachedNetworkImage(
                           imageUrl: '',
                           imageBuilder: (context, imageProvider) =>
                               Image.network(''),
                           placeholder: (context, url) =>
                               Center(child: CupertinoActivityIndicator()),
                           errorWidget: (context, url, error) => Container(
                             child: Image.asset(
                               '${Environment.imageAssets}default_image_education.png',
                               height: 80,
                               width: 80,
                             ),
                           )),
                     ),
                     Expanded(
                         child: Container(
                           margin:
                           EdgeInsets.fromLTRB(Dimens.padding, 5.0, 5.0, 5.0),
                           child: Text(
                             'Klik disini untuk mengunduh file Edukasi isolasi Mandiri',
                             style: TextStyle(
                               color: Colors.black,
                               fontFamily: FontsFamily.lato,
                               fontSize: 12.0,
                               height: 1.2,
                             ),
                           ),
                         )),
                     InkWell(
                       child: Container(
                           margin: EdgeInsets.only(right: Dimens.padding),
                           child: Image.asset(
                             '${Environment.iconAssets}download_icon.png',
                             height: 20,
                             width: 20,
                           )),
                       onTap: (){

                       },
                     )
                   ],
                 ),
               ),
             )
            ],
          ),
        ));
  }

  Widget buildAnnouncement() {
    return Container(
      width: (MediaQuery.of(context).size.width),
      margin: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
          color: Color(0xffFFF3CC), borderRadius: BorderRadius.circular(8.0)),
      child: Stack(
        children: <Widget>[
          Image.asset('${Environment.imageAssets}intersect.png', width: 73),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Profil Anda Belum Lengkap',
                    style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.lato),
                  ),
                  SizedBox(height: 15),
                  Container(
                      child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text:
                            'Lengkapi data diri anda untuk mengisi Pemantauan Harian. ',
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                            fontFamily: FontsFamily.lato),
                      ),
                      TextSpan(
                          text: 'Klik di sini',
                          style: TextStyle(
                              fontSize: 12.0,
                              color: ColorBase.blue,
                              fontFamily: FontsFamily.lato,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()..onTap = () {}),
                      TextSpan(
                        text: ' untuk melengkapi.',
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                            fontFamily: FontsFamily.lato),
                      ),
                    ]),
                  ))
                ]),
          ),
        ],
      ),
    );
  }

  Widget location() {
    return Card(
      elevation: 0,
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${Dictionary.currentLocationTitle}',
              style: TextStyle(
                fontFamily: FontsFamily.lato,
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 12.0,
                height: 1.2,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Image.asset(
                  '${Environment.iconAssets}pin_location_red.png',
                  scale: 3,
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Jalan Sekelimus VIII, Kecamatan Bandung Kidul, Kota Bandung',
                    style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      height: 1.2,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildContainer(String image, String title, int length) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: OutlineButton(
        splashColor: Colors.green,
        highlightColor: Colors.white,
        padding: EdgeInsets.all(0.0),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          width: (MediaQuery.of(context).size.width / length),
          padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 30, bottom: 30),
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(height: 60, child: Image.asset(image)),
              Container(
                margin: EdgeInsets.only(top: 15, left: 5.0),
                child: Text(title,
                    style: TextStyle(
                        fontSize: 13.0,
                        color: Color(0xff333333),
                        fontFamily: FontsFamily.lato)),
              )
            ],
          ),
        ),
        onPressed: () {},
      ),
    ));
  }
}
