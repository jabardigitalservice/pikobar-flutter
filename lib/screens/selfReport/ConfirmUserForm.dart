import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/blocs/selfReport/addOtherSelfReport/AddOtherSelfReportBloc.dart';
import 'package:pikobar_flutter/components/Announcement.dart';
import 'package:pikobar_flutter/components/BlockCircleLoading.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/AddOtherSelfReportModel.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:uuid/uuid.dart';

class ConfirmUserForm extends StatefulWidget {
  final String nik, name, birthday, gender, relation;
  ConfirmUserForm(
      {@required this.nik,
      @required this.name,
      @required this.birthday,
      @required this.gender,
      @required this.relation});
  @override
  _ConfirmUserFormState createState() => _ConfirmUserFormState();
}

class _ConfirmUserFormState extends State<ConfirmUserForm> {
  AddOtherSelfReportBloc _addOtherSelfReportBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: Dictionary.previewData),
      body: BlocProvider<AddOtherSelfReportBloc>(
        create: (BuildContext context) =>
            _addOtherSelfReportBloc = AddOtherSelfReportBloc(),
        child: BlocListener(
          cubit: _addOtherSelfReportBloc,
          listener: (context, state) {
            if (state is AddOtherSelfReportSaved) {
              AnalyticsHelper.setLogEvent(Analytics.addOtherUserSaved);
              Navigator.of(context).pop();
              // Bottom sheet success message
              _showBottomSheetForm(
                  '${Environment.imageAssets}daily_success.png',
                  Dictionary.savedSuccessfully,
                  Dictionary.dailySuccess, () async {
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              });
            } else if (state is AddOtherSelfReportFailed) {
              AnalyticsHelper.setLogEvent(Analytics.addOtherUserFailed);
              Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (BuildContext context) => DialogTextOnly(
                        description: state.error.toString(),
                        buttonText: Dictionary.ok,
                        onOkPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                        },
                      ));
            } else {
              blockCircleLoading(context: context, dismissible: false);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
            child: ListView(
              children: <Widget>[
                SizedBox(height: Dimens.padding),
                buildAnnouncement(),
                SizedBox(height: Dimens.padding),
                buildPreviewText(Dictionary.nik, widget.nik),
                SizedBox(height: Dimens.padding),
                buildPreviewText(Dictionary.name, widget.name),
                SizedBox(height: Dimens.padding),
                buildPreviewText(
                    Dictionary.birthday,
                    DateFormat.yMMMMd('id')
                        .format(DateTime.parse(widget.birthday))),
                SizedBox(height: Dimens.padding),
                buildPreviewText(Dictionary.gender,
                    widget.gender == 'M' ? 'Laki-laki' : 'Perempuan'),
                SizedBox(height: Dimens.padding),
                buildPreviewText(Dictionary.relation, widget.relation),
                SizedBox(height: 32.0),
                RoundedButton(
                    title: Dictionary.save,
                    elevation: 0.0,
                    color: ColorBase.green,
                    textStyle: TextStyle(
                        fontFamily: FontsFamily.lato,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                    onPressed: () {
                      _saveSelfReport();
                    }),
                SizedBox(height: Dimens.padding),
                OutlineButton(
                  borderSide: BorderSide(color: ColorBase.limeGreen),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                            child: Text(
                          Dictionary.change,
                          style: TextStyle(
                              color: ColorBase.limeGreen,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsFamily.lato),
                        ))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Bottom sheet message form
  void _showBottomSheetForm(String image, String titleDialog, String descDialog,
      GestureTapCallback onPressed) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),
        isDismissible: false,
        builder: (context) {
          return Container(
            margin: EdgeInsets.all(Dimens.padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 44.0),
                  child: Image.asset(
                    image,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(height: 24.0),
                Text(
                  titleDialog,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  descDialog,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontSize: 12.0,
                      color: Colors.grey[600]),
                ),
                SizedBox(height: 24.0),
                RoundedButton(
                    title: Dictionary.ok.toUpperCase(),
                    textStyle: TextStyle(
                        fontFamily: FontsFamily.lato,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    color: ColorBase.green,
                    elevation: 0.0,
                    onPressed: onPressed)
              ],
            ),
          );
        });
  }

  Widget buildPreviewText(String label, value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontFamily: FontsFamily.lato,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                height: 18.0 / 12.0,
                color: ColorBase.netralGrey)),
        Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontFamily: FontsFamily.lato,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    height: 18.0 / 12.0,
                    color: Colors.black)))
      ],
    );
  }

  /// Set up for show announcement widget
  Widget buildAnnouncement() {
    return Announcement(
      title: Dictionary.titlePreviewDataAnnouncement,
      content: Dictionary.previewAnnouncement,
      context: context,
      onLinkTap: (url) {},
    );
  }

  // Validate and Record data to firestore
  void _saveSelfReport() async {
    String otherUID = Uuid().v4();
    final data = AddOtherSelfReportModel(
        userId: otherUID,
        createdAt: DateTime.now(),
        birthday:
            widget.birthday.isNotEmpty ? DateTime.parse(widget.birthday) : null,
        gender: widget.gender,
        name: widget.name,
        nik: widget.nik,
        relation: widget.relation);
    _addOtherSelfReportBloc.add(AddOtherSelfReportSave(data));
  }

  @override
  void dispose() {
    super.dispose();
    _addOtherSelfReportBloc.close();
  }
}
