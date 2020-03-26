import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';

class InfoGraphicsScreen extends StatefulWidget {
  @override
  _InfoGraphicsScreenState createState() => _InfoGraphicsScreenState();
}

class _InfoGraphicsScreenState extends State<InfoGraphicsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Dictionary.infoGraphics),
      ),
    );
    //   body:
    //   StreamBuilder<QuerySnapshot>(
    //     stream: Firestore.instance
    //         .collection(Collections.faq)
    //         .orderBy('sequence_number')
    //         .snapshots(),
    //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //       if (snapshot.hasData) {
    //         List dataFaq;

    //         // if search ative
    //         if (searchQuery.isNotEmpty) {
    //           dataFaq = snapshot.data.documents
    //               .where((test) => test['title']
    //                   .toLowerCase()
    //                   .contains(searchQuery.toLowerCase()))
    //               .toList();
    //         } else {
    //           dataFaq = snapshot.data.documents;
    //         }

    //         final int messageCount = dataFaq.length;

    //         // check if data is empty
    //         if (dataFaq.length == 0) {
    //           return EmptyData(
    //               message: '${Dictionary.emptyData} ${Dictionary.faq}');
    //         }

    //         return ListView.builder(
    //           itemCount: messageCount,
    //           padding: EdgeInsets.only(bottom: 30.0),
    //           itemBuilder: (_, int index) {
    //             return _cardContent(dataFaq[index]);
    //           },
    //         );
    //       } else {
    //         return _buildLoading();
    //       }
    //     },
    //   ),
    // );
  }
}
