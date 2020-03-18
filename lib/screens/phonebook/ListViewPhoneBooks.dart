import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pikobar_flutter/screens/phonebook/PhoneBookDetailScreen.dart';


class ListViewPhoneBooks extends StatelessWidget {
   AsyncSnapshot<QuerySnapshot> snapshot;
  final ScrollController scrollController;
  // final int maxDataLength;

  ListViewPhoneBooks({Key key, @required this.snapshot, this.scrollController, 
  // this.maxDataLength
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListTile _cardTile(DocumentSnapshot document) {
      return ListTile(
        leading: Icon(FontAwesomeIcons.building),
        title: Text(document['name']),
        onTap: () => _onTapItem(context, document),
      );
    }

    Widget _card(DocumentSnapshot document) {
      return Card(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: _cardTile(document),
      ));
    }

    return ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.all(6),
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

          return _card(document);
        });
  }

  void _onTapItem(BuildContext context, DocumentSnapshot document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhoneBookDetailScreen(document: document),
      ),
    );
  }
}
