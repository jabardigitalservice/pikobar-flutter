import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class CallCenterDetailScreen extends StatelessWidget {
  DocumentSnapshot document;

  CallCenterDetailScreen({Key key, @required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CallCenterDetail(
      document: document,
    );
  }
}

// ignore: must_be_immutable
class CallCenterDetail extends StatefulWidget {
  DocumentSnapshot document;

  CallCenterDetail({Key key, @required this.document}) : super(key: key);

  @override
  _CallCenterDetailState createState() => _CallCenterDetailState();
}

class _CallCenterDetailState extends State<CallCenterDetail> {
  bool statConnect;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.defaultAppBar(title: Dictionary.nomorDarurat),
        body: ListView(children: [
          coverImageSection(context, widget.document),
          mainSection(context, widget.document),
        ]));
  }
}

Widget coverImageSection(BuildContext context, DocumentSnapshot document) {
  Widget _loader = Container(
      height: 240,
      child: Center(
        child: CircularProgressIndicator(),
      ));

  return document['image_url'] != null
      ? CachedNetworkImage(
          imageUrl: document['image_url'],
          placeholder: (context, url) => _loader,
          errorWidget: (context, url, error) => Icon(Icons.error),
        )
      : Container(
          padding: EdgeInsets.only(left: 60.0, right: 60.0, top: 30.0),
          child: Image.asset('assets/logo/logo.png'));
}

Widget mainSection(BuildContext context, DocumentSnapshot document) {
  return Container(
    padding: EdgeInsets.all(20),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(document['nama_kotkab'] ?? '',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
//                  _record.latitude != null && _record.longitude != null ?  GestureDetector(
//                      child: Icon(Icons.map),
//                      onTap: (){
//                        _openMaps();
//                      },
//                    ):Container()
          ],
        ),
        document['call_center'] != null && document['call_center'].isNotEmpty
            ? ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: document['call_center'].length,
                itemBuilder: (context, position) {
                  return ListTile(
                      contentPadding: EdgeInsets.all(0),
                      trailing: Icon(Icons.call),
                      title: Text(
                        document['call_center'][position],
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onTap: () {
                        _launchURL(document['call_center'][position], 'number');

                        AnalyticsHelper.setLogEvent(
                            Analytics.tappedphoneBookEmergencyTelp,
                            <String, dynamic>{
                              'title': document['nama_kotkab'],
                              'telp': document['call_center'][position]
                            });
                      });
                })
            : Container(),
        document['call_center'] != null && document['call_center'].isNotEmpty
            ? Divider()
            : Container(),
        document['hotline'] != null && document['hotline'].isNotEmpty
            ? ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: document['hotline'].length,
                itemBuilder: (context, position) {
                  return ListTile(
                      contentPadding: EdgeInsets.all(0),
                      trailing: Icon(Icons.call),
                      title: Text(
                        document['hotline'][position],
                        style: TextStyle(fontSize: 16.0),
                      ),
                      onTap: () {
                        _launchURL(document['hotline'][position], 'number');

                        AnalyticsHelper.setLogEvent(
                            Analytics.tappedphoneBookEmergencyTelp,
                            <String, dynamic>{
                              'title': document['nama_kotkab'],
                              'telp': document['hotline'][position]
                            });
                      });
                })
            : Container()
      ],
    ),
  );
}



_launchURL(String launchUrl, tipeURL) async {
  String url;
  if (tipeURL == 'number') {
    url = 'tel:$launchUrl';
  } else {
    url = launchUrl;
  }

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

// ignore: missing_return
Future<bool> checkConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
}

// void _openMaps() async {
//   PermissionStatus permission = await PermissionHandler()
//       .checkPermissionStatus(PermissionGroup.location);
//   if (permission == PermissionStatus.granted) {
//     unawaited(Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ShowLocationsScreen(_record),
//       ),
//     ));
//   } else {
//     unawaited(showDialog(
//         context: context,
//         builder: (BuildContext context) => DialogRequestPermission(
//           image: Image.asset(
//             'assets/icons/map_pin.png',
//             fit: BoxFit.contain,
//             color: Colors.white,
//           ),
//           description: Dictionary.permissionPhoneBookMap,
//           onOkPressed: () {
//             Navigator.of(context).pop();
//             PermissionHandler().requestPermissions(
//                 [PermissionGroup.location]).then(_onStatusRequested);
//           },
//         )));
//   }
// }

// void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses) {
//   final status = statuses[PermissionGroup.location];
//   if (status == PermissionStatus.granted) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ShowLocationsScreen(_record),
//       ),
//     );
//   }
// }
