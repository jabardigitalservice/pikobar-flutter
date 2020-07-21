import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/selfReport/contactHistoryDetail/ContactHistoryDetailBloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';

class ContactHistoryDetailScreen extends StatefulWidget {
  final String contactHistoryId;

  ContactHistoryDetailScreen(this.contactHistoryId);

  @override
  _ContactHistoryDetailScreenState createState() =>
      _ContactHistoryDetailScreenState();
}

class _ContactHistoryDetailScreenState
    extends State<ContactHistoryDetailScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsHelper.setCurrentScreen(Analytics.selfReports);
    AnalyticsHelper.setLogEvent(Analytics.tappedContactHistoryDetail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: Dictionary.selfReportDetail),
      backgroundColor: Colors.white,
      body: BlocProvider<ContactHistoryDetailBloc>(
        create: (context) => ContactHistoryDetailBloc()
          ..add(ContactHistoryDetailLoad(
              contactHistoryId: widget.contactHistoryId)),
        child: BlocBuilder<ContactHistoryDetailBloc, ContactHistoryDetailState>(
            builder: (context, state) {
          return state is ContactHistoryDetailLoaded
              ? _buildContent(state)
              : state is ContactHistoryDetailFailure
                  ? ErrorContent(error: state.error)
                  : Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }

  Widget _buildContent(ContactHistoryDetailLoaded state) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.padding, vertical: Dimens.verticalPadding),
          child: Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: ColorBase.menuBorderColor),
                            )),
                        Positioned(
                          left: 16,
                          top: 14,
                          child: Image.asset(
                            '${Environment.imageAssets}${state.documentSnapshot.data['gender'] == 'M' ? 'male_icon' : 'female_icon'}.png',
                            height: 39,
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${state.documentSnapshot.data['name']}',
                          style: TextStyle(
                              fontFamily: FontsFamily.lato,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              height: 1.214),
                        ),
                        SizedBox(height: 8.0),
                        _buildText(
                            text: state.documentSnapshot.data['relation'],
                            isLabel: true),
                      ],
                    )
                  ],
                ),
              ),

              SizedBox(
                height: 32.0,
              ),

              /// Phone number section
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildText(
                        text: Dictionary.mobilePhoneNumber, isLabel: true),
                    _buildText(text: state.documentSnapshot['phone_number'])
                  ],
                ),
              )
            ],
          ),
        ),

        /// Divider
        Container(
          height: 8.0,
          color: ColorBase.grey,
        ),

        /// Gender section
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.padding, vertical: Dimens.verticalPadding),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildText(text: Dictionary.gender, isLabel: true),
              _buildText(
                  text:
                      '${state.documentSnapshot['gender'] == 'M' ? 'Laki-laki' : 'Perempuan'}')
            ],
          ),
        ),

        /// Divider
        Container(
          height: 8.0,
          color: ColorBase.grey,
        ),

        /// Last contact date section
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.padding, vertical: Dimens.verticalPadding),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildText(text: Dictionary.lastContactDate, isLabel: true),
              _buildText(
                  text: unixTimeStampToDate(
                      state.documentSnapshot['last_contact_date'].seconds),
                  textAlign: TextAlign.end),
            ],
          ),
        ),

        /// Back button section
        Container(
          height: 38.0,
          margin: EdgeInsets.all(Dimens.padding),
          child: RaisedButton(
              splashColor: Colors.lightGreenAccent,
              color: ColorBase.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                Dictionary.back,
                style: TextStyle(
                    fontFamily: FontsFamily.lato,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                    color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        )
      ],
    );
  }

  /// Creates a text widget.
  ///
  /// If the [isLabel] parameter is true, it will make the text bold.
  /// The [text] parameter must not be null.
  Text _buildText(
      {@required String text, bool isLabel = false, TextAlign textAlign}) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: FontsFamily.lato,
          fontWeight: isLabel ? FontWeight.normal : FontWeight.bold,
          fontSize: 12.0,
          height: 1.1667),
      textAlign: textAlign,
    );
  }
}
