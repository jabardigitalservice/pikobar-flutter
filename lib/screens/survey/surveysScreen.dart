import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/launchExternal.dart';
import 'package:shimmer/shimmer.dart';

class SurveysScreen extends StatefulWidget {
  @override
  _SurveysScreenState createState() => _SurveysScreenState();
}

class _SurveysScreenState extends State<SurveysScreen> {
  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.survey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Dictionary.survey),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection(Collections.surveys).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.isNotEmpty) {
              return _buildContent(snapshot);
            } else {
              return EmptyData(message: 'Tidak ada data survei');
            }
          } else {
            return _buildLoading();
          }
        },
      ),
    );
  }

  _buildLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: Container(
            margin: EdgeInsets.all(15.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width - 175,
                          height: 20.0,
                          color: Colors.grey[300]),
                      SizedBox(height: 5.0),
                      Container(
                          width: MediaQuery.of(context).size.width - 175,
                          height: 20.0,
                          color: Colors.grey[300]),
                      SizedBox(height: 5.0),
                      Container(
                          width: 100.0, height: 20.0, color: Colors.grey[300]),
                    ],
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.white,
                  child: Container(
                    width: 100.0,
                    height: 40.0,
                    color: Colors.grey[300],
                  ),
                )
              ],
            )),
      ),
    );
  }

  _buildContent(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Container(
      child: ListView.builder(
          itemCount: snapshot.data.documents.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final DocumentSnapshot document = snapshot.data.documents[index];

            return Card(
              margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Container(
                  margin: EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width - 175,
                        child: Text(document['title'],
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black)),
                      ),
                      Container(
                        width: 100.0,
                        child: RaisedButton(
                          color: ColorBase.green,
                          textColor: Colors.white,
                          child: Text(Dictionary.fieldSurvey),
                          onPressed: () {
                            Navigator.of(context).pushNamed(NavigationConstrants.Browser, arguments: document['url']);
                          },
                        ),
                      )
                    ],
                  )),
            );
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
