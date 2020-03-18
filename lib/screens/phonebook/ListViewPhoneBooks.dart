import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/phonebook/PhoneBookDetailScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class ListViewPhoneBooks extends StatelessWidget {
  AsyncSnapshot<QuerySnapshot> snapshot;
  final ScrollController scrollController;
  // final int maxDataLength;

  ListViewPhoneBooks({
    Key key,
    @required this.snapshot,
    this.scrollController,
    // this.maxDataLength
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListTile _cardTile(DocumentSnapshot document) {
      return ListTile(
        leading: Container(
            height: 25,
            child: Image.asset('${Environment.iconAssets}office.png')),
        title: Text(document['name']),
        onTap: () => _onTapItem(context, document),
      );
    }

    Widget _card(DocumentSnapshot document) {
      return Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: _cardTile(document),
          ));
    }

    return ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.all(20),
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index) {
          // if (position == records.length) {
          //   if (records.length > 15 && maxDataLength != records.length) {
          //     return Padding(
          //       padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          //       child: Column(
          //         children: <Widget>[
          //           CupertinoActivityIndicator(),
          //           SizedBox(
          //             height: 5.0,
          //           ),
          //           Text(Dictionary.loadingData),
          //         ],
          //       ),
          //     );
          //   } else {
          //     return Container();
          //   }
          // }
          final DocumentSnapshot document = snapshot.data.documents[index];

          return Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              children: <Widget>[
                index == 0 ? _buildDaruratNumber(context) : Container(),
                _card(document)
              ],
            ),
          );
        });
  }

  Widget _buildDaruratNumber(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildCardHeader(
            context,
            'emergency_phone.png',
            Dictionary.phoneBookEmergencyInformation,
            Dictionary.phoneBookEmergencyInformationCaption),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
                leading: Container(
                    height: 25,
                    child: Image.asset('${Environment.iconAssets}office.png')),
                title: Text(Dictionary.callCenter),
                onTap: () {
                  _launchURL(Dictionary.callCenterNumber, 'number');
                }),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
                leading: Container(
                    height: 25,
                    child: Image.asset(
                        '${Environment.iconAssets}conversations.png')),
                title: Text(Dictionary.dinasKesehatan),
                onTap: () {
                  _launchURL(Dictionary.waNumberDinasKesehatan, 'whatsapp');
                }),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        _buildCardHeader(context, 'hospital.png', Dictionary.daftarRumahSakitRujukan,
            Dictionary.daftarRumahSakitRujukanCaption),
      ],
    );
  }

  Widget _buildCardHeader(
      BuildContext context, String iconPath, title, content) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Color(0xffF2C94C),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Text(
                            title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )),
                      Text(content, style: TextStyle(fontSize: 12))
                    ],
                  ),
                ),
                Container(
                    height: 80,
                    child: Image.asset('${Environment.iconAssets}$iconPath'))
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  void _onTapItem(BuildContext context, DocumentSnapshot document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhoneBookDetailScreen(document: document),
      ),
    );
  }

  _launchURL(String launchUrl, tipeURL) async {
    String url;
    if (tipeURL == 'number') {
      url = 'tel:$launchUrl';
    } else {
      url = 'whatsapp://send?phone=$launchUrl';
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
