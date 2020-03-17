import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:pikobar_flutter/components/Expandable.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("faqs").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final int messageCount = snapshot.data.documents.length;
            return ListView.builder(
              itemCount: messageCount,
              padding: EdgeInsets.only(bottom: 30.0),
              itemBuilder: (_, int index) {
                return _cardContent(snapshot.data.documents[index]);
              },
            );
          } else {
            return _buildLoading();
          }
        },
      ),
    );
  }
}

Widget _buildLoading() {
  return ListView.builder(
    itemCount: 5,
    itemBuilder: (context, index) => Card(
      margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: ListTile(
        title: Skeleton(
          width: MediaQuery.of(context).size.width - 140,
          height: 20.0,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Skeleton(
            width: MediaQuery.of(context).size.width - 190,
            height: 20.0,
          ),
        ),
        trailing: Skeleton(
          width: 20.0,
          height: 20.0,
        ),
      ),
    ),
  );
}

Widget _cardContent(dataHelp) {
  return ExpandableNotifier(
    child: ScrollOnExpand(
      scrollOnExpand: false,
      scrollOnCollapse: true,
      child: Card(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        clipBehavior: Clip.antiAlias,
        child: ScrollOnExpand(
          scrollOnExpand: true,
          scrollOnCollapse: false,
          child: ExpandablePanel(
            tapHeaderToExpand: true,
            tapBodyToCollapse: true,
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            header: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                dataHelp['title'],
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),
            expanded: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Html(
                  data: dataHelp['content'].replaceAll('\n', '</br>'),
                  defaultTextStyle:
                      TextStyle(color: Colors.black, fontSize: 14.0),
                  customTextAlign: (dom.Node node) {
                    return TextAlign.justify;
                  }),
            ),
            builder: (_, collapsed, expanded) {
              return Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Expandable(
                  collapsed: collapsed,
                  expanded: expanded,
                  crossFadePoint: 0,
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}
