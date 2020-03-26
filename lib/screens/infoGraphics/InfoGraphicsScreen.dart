import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
import 'package:pikobar_flutter/components/PikobarPlaceholder.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/collections.dart';

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
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection(Collections.infographics)
              .orderBy('published_date', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              final List data = snapshot.data.documents;
              final int dataCount = data.length;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: dataCount,
                padding: EdgeInsets.only(bottom: 30.0, top: 10.0),
                itemBuilder: (_, int index) {
                  return _cardContent(data[index]);
                },
              );
            } else {
              return Container();
            }
          },
        ));
    //   body:
  }

  Widget _cardContent(data) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.3,
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
                imageUrl: data['images'][0] ?? '',
                imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0)),
                        image: DecorationImage(
                          alignment: Alignment.topCenter,
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                placeholder: (context, url) => Center(
                    heightFactor: 10.2, child: CupertinoActivityIndicator()),
                errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
                    ),
                    child: PikobarPlaceholder())),
          ),
        ),
        // SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                data['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              IconButton(
                  icon: Icon(
                    FontAwesomeIcons.ellipsisH,
                    size: 17,
                  ),
                  onPressed: null)
            ],
          ),
        ),
        // SizedBox(height: 16),
      ],
    );
  }
}
