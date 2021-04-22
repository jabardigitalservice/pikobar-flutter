import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/selfReport/contactHistoryList/ContactHistoryListBloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/selfReport/ContactHistoryFormScreen.dart';
import 'package:pikobar_flutter/screens/selfReport/ContactHistoryDetailScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';

class ContactHistoryScreen extends StatefulWidget {
  ContactHistoryScreen({Key key}) : super(key: key);

  @override
  _ContactHistoryScreenState createState() => _ContactHistoryScreenState();
}

class _ContactHistoryScreenState extends State<ContactHistoryScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsHelper.setCurrentScreen(Analytics.selfReports);
    AnalyticsHelper.setLogEvent(Analytics.tappedContactHistory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.animatedAppBar(
        showTitle: false,
        title: Dictionary.contactHistory,
      ),
      backgroundColor: Colors.white,
      body: BlocProvider<ContactHistoryListBloc>(
        create: (BuildContext context) =>
            ContactHistoryListBloc()..add(ContactHistoryListLoad()),
        child: BlocBuilder<ContactHistoryListBloc, ContactHistoryListState>(
            builder: (context, state) {
          if (state is ContactHistoryListLoaded) {
            return buildContent(state.querySnapshot.docs);
          } else if (state is ContactHistoryListFailure) {
            return ErrorContent(error: state.error);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }

  Widget buildContent(List<DocumentSnapshot> documents) {
    documents.sort((b, a) => a['created_at'].compareTo(b['created_at']));
    return documents.length == 0
        ? buildEmptyScreen()
        : buildContactHistoryList(documents);
  }

  /// Function to build create button
  Widget buildCreateButton() {
    return RoundedButton(
        title: Dictionary.reportNewContact,
        elevation: 0.0,
        color: ColorBase.green,
        borderRadius: BorderRadius.circular(8),
        textStyle: TextStyle(
            fontFamily: FontsFamily.lato,
            fontSize: 12.0,
            fontWeight: FontWeight.w900,
            color: Colors.white),
        onPressed: () {
          // move to form screen
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ContactHistoryFormScreen()));
        });
  }

  /// Function to build empty screen
  Widget buildEmptyScreen() {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0.0,
          right: 0.0,
          top: 0.0,
          child: Padding(
            padding: EdgeInsets.all(Dimens.cardContentMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  Dictionary.contactHistory,
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Image.asset(
                    '${Environment.imageAssets}contact_history_empty.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    Dictionary.emptyContactTitle,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.lato,
                        fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    Dictionary.emptyContactDesc,
                    style:
                        TextStyle(fontFamily: FontsFamily.lato, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 0.0,
          child: Padding(
              padding: EdgeInsets.all(Dimens.cardContentMargin),
              child: buildCreateButton()),
        ),
      ],
    );
  }

  /// Function to build contact history list screen
  Widget buildContactHistoryList(List<DocumentSnapshot> documents) {
    return Padding(
      padding: EdgeInsets.all(Dimens.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            Dictionary.contactHistory,
            style: TextStyle(
                fontFamily: FontsFamily.lato,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorBase.grey,
            ),
            child: Padding(
              padding: EdgeInsets.all(Dimens.cardContentMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    Dictionary.sumContactHistory,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.lato,
                        fontSize: 12),
                  ),
                  Text(
                    documents.length.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorBase.limeGreen,
                        fontFamily: FontsFamily.lato,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          // move to detail screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ContactHistoryDetailScreen(
                                        contactHistoryId: documents[i].id)),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical:10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color:
                                                    ColorBase.menuBorderColor),
                                          )),
                                      Positioned(
                                        left: 15,
                                        top: 15,
                                        child: Image.asset(
                                          '${Environment.imageAssets}${documents[i].get('gender') == 'M' ? 'male_icon' : 'female_icon'}.png',
                                          height: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        documents[i].get('name'),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            fontFamily: FontsFamily.lato),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        documents[i].get('relation'),
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: FontsFamily.lato),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      i == documents.length - 1
                          ? Container()
                          : Divider(
                              color: ColorBase.grey,
                              thickness: 10,
                            ),
                    ],
                  );
                }),
          ),
          buildCreateButton()
        ],
      ),
    );
  }
}
