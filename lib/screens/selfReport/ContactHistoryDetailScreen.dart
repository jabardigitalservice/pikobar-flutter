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

  ContactHistoryDetailScreen({Key key, this.contactHistoryId})
      : super(key: key);

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
      appBar: CustomAppBar.animatedAppBar(
        showTitle: false,
        title: Dictionary.selfReportDetail,
      ),
      backgroundColor: Colors.white,
      body: BlocProvider<ContactHistoryDetailBloc>(
        create: (context) => ContactHistoryDetailBloc()
          ..add(ContactHistoryDetailLoad(
              contactHistoryId: widget.contactHistoryId)),
        child: BlocBuilder<ContactHistoryDetailBloc, ContactHistoryDetailState>(
            builder: (context, state) {
          return state is ContactHistoryDetailLoaded
              ? _buildContent(state.documentSnapshot.data())
              : state is ContactHistoryDetailFailure
                  ? ErrorContent(error: state.error)
                  : Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> data) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.padding, vertical: Dimens.verticalPadding),
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
                height: 30,
              ),
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
                            '${Environment.imageAssets}${data['gender'] == 'M' ? 'male_icon' : 'female_icon'}.png',
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
                          '${data['name']}',
                          style: TextStyle(
                              fontFamily: FontsFamily.lato,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              height: 1.214),
                        ),
                        SizedBox(height: 8.0),
                        _buildText(text: data['relation'], isLabel: true),
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
                    _buildText(text: Dictionary.phoneNumber, isLabel: true),
                    _buildText(text: data['phone_number'])
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
                  text: '${data['gender'] == 'M' ? 'Laki-laki' : 'Perempuan'}')
            ],
          ),
        ),

        /// Last contact date section
        data['last_contact_date'] != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    /// Divider
                    Container(
                      height: 8.0,
                      color: ColorBase.grey,
                    ),

                    /// Last contact date
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimens.padding,
                          vertical: Dimens.verticalPadding),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildText(
                              text: Dictionary.lastContactDate, isLabel: true),
                          _buildText(
                              text: unixTimeStampToDate(
                                  data['last_contact_date'].seconds),
                              textAlign: TextAlign.end),
                        ],
                      ),
                    ),
                  ])
            : Container(),

        /// Back button section
        Container(
          height: 38.0,
          margin: EdgeInsets.all(Dimens.padding),
          child: RaisedButton(
              splashColor: Colors.lightGreenAccent,
              color: ColorBase.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
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
