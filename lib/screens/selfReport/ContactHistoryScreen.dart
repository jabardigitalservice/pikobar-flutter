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
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';

class ContactHistoryScreen extends StatefulWidget {
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
      appBar: CustomAppBar.defaultAppBar(
        title: Dictionary.contactHistory,
      ),
      backgroundColor: Colors.white,
      body: BlocProvider<ContactHistoryListBloc>(
        create: (BuildContext context) =>
            ContactHistoryListBloc()..add(ContactHistoryListLoad()),
        child: BlocBuilder<ContactHistoryListBloc, ContactHistoryListState>(
            builder: (context, state) {
          if (state is ContactHistoryListLoaded) {
            return buildContent(state);
          } else if (state is ContactHistoryListFailure) {
            return ErrorContent(error: state.error);
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        }),
      ),
    );
  }

  Widget buildContent(ContactHistoryListLoaded state) {
    return state.querySnapshot.documents.length == 0
        ? buildEmptyScreen()
        : buildContactHistoryList(state);
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
            padding: EdgeInsets.all(Dimens.contentPadding),
            child: Column(
              children: <Widget>[
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
                Text(
                  Dictionary.emptyContactTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsFamily.lato,
                      fontSize: 14),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  Dictionary.emptyContactDesc,
                  style: TextStyle(fontFamily: FontsFamily.lato, fontSize: 12),
                  textAlign: TextAlign.center,
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
              padding: EdgeInsets.all(Dimens.contentPadding),
              child: buildCreateButton()),
        ),
      ],
    );
  }

  /// Function to build contact history list screen
  Widget buildContactHistoryList(ContactHistoryListLoaded state) {
    return Padding(
      padding: EdgeInsets.all(Dimens.contentPadding),
      child: Column(
        children: <Widget>[
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
                    state.querySnapshot.documents.length.toString(),
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
                itemCount: state.querySnapshot.documents.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          // move to detail screen
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
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
                                      state.querySnapshot.documents[i]
                                                  .data['gender'] ==
                                              'M'
                                          ? Positioned(
                                              left: 15,
                                              top: 15,
                                              child: Image.asset(
                                                '${Environment.imageAssets}male_icon.png',
                                                height: 20,
                                              ),
                                            )
                                          : Positioned(
                                              left: 15,
                                              top: 15,
                                              child: Image.asset(
                                                '${Environment.imageAssets}female_icon.png',
                                                height: 20,
                                              ),
                                            ),
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
                                        state.querySnapshot.documents[i]
                                            .data['name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            fontFamily: FontsFamily.lato),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        state.querySnapshot.documents[i]
                                            .data['relation'],
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
                      i == state.querySnapshot.documents.length - 1
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
