import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/phonebook/PhoneBookDetailScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:url_launcher/url_launcher.dart';

class ListViewPhoneBooks extends StatelessWidget {
  AsyncSnapshot<QuerySnapshot> snapshot;
  final ScrollController scrollController;
  String searchQuery;

  ListViewPhoneBooks(
      {Key key,
      @required this.snapshot,
      this.scrollController,
      this.searchQuery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListTile _cardTile(DocumentSnapshot document) {
      return ListTile(
        leading: Container(
            height: 25,
            child: Image.asset('${Environment.iconAssets}office.png')),
        title: Text(
          document['name'],
          style:
              TextStyle(color: Color(0xff4F4F4F), fontWeight: FontWeight.bold),
        ),
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

    List dataNomorDarurat;
    if (searchQuery != null) {
      dataNomorDarurat = snapshot.data.documents
          .where((test) =>
              test['name'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    } else {
      dataNomorDarurat = snapshot.data.documents;
    }
    final int emergencyPhoneCount = dataNomorDarurat.length;
    return emergencyPhoneCount == 0
        ? EmptyData(
            message: '${Dictionary.emptyData} ${Dictionary.phoneBookEmergency}')
        : ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.all(20),
            itemCount: emergencyPhoneCount,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: <Widget>[
                    index == 0 && searchQuery == null
                        ? _buildDaruratNumber(context)
                        : Container(),
                    _card(dataNomorDarurat[index])
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
                title: Text(Dictionary.callCenter,
                    style: TextStyle(
                        color: Color(0xff4F4F4F), fontWeight: FontWeight.bold)),
                onTap: () {
                  _launchURL(Dictionary.callCenterNumber, 'number');

                  AnalyticsHelper.setLogEvent(
                      Analytics.tappedphoneBookEmergencyTelp, <String, dynamic>{
                    'title': Dictionary.callCenter,
                    'telp': Dictionary.callCenterNumber
                  });
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
                    child:
                        Image.asset('${Environment.iconAssets}whatsapp.png')),
                title: Text(Dictionary.dinasKesehatan,
                    style: TextStyle(
                        color: Color(0xff4F4F4F), fontWeight: FontWeight.bold)),
                onTap: () {
                  _launchURL(Dictionary.waNumberDinasKesehatan, 'whatsapp');

                  AnalyticsHelper.setLogEvent(
                      Analytics.tappedphoneBookEmergencyWa, <String, dynamic>{
                    'title': Dictionary.dinasKesehatan,
                    'wa': Dictionary.waNumberDinasKesehatan
                  });
                }),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        _buildCardHeader(
            context,
            'hospital.png',
            Dictionary.daftarRumahSakitRujukan,
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

    AnalyticsHelper.setLogEvent(Analytics.tappedphoneBookEmergencyDetail,
        <String, dynamic>{'title': document['name']});
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
