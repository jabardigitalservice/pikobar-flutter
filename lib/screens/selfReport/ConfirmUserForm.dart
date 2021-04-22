import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/blocs/selfReport/addOtherSelfReport/AddOtherSelfReportBloc.dart';
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
      {Key key,
      @required this.nik,
      @required this.name,
      @required this.birthday,
      @required this.gender,
      @required this.relation})
      : super(key: key);

  @override
  _ConfirmUserFormState createState() => _ConfirmUserFormState();
}

class _ConfirmUserFormState extends State<ConfirmUserForm> {
  AddOtherSelfReportBloc _addOtherSelfReportBloc;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.animatedAppBar(
        showTitle: _showTitle,
        title: Dictionary.previewData,
      ),
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RoundedButton(
                title: Dictionary.save,
                borderRadius: BorderRadius.circular(8),
                elevation: 0.0,
                color: ColorBase.green,
                textStyle: TextStyle(
                    fontFamily: FontsFamily.roboto,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
                onPressed: () {
                  _saveSelfReport();
                }),
            const SizedBox(height: Dimens.padding),
            OutlineButton(
              borderSide: BorderSide(color: Colors.grey[400]),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                        child: Text(
                      Dictionary.change,
                      style: TextStyle(
                          color: ColorBase.netralGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: FontsFamily.roboto),
                    ))),
              ),
            ),
          ],
        ),
      ),
      body: BlocProvider<AddOtherSelfReportBloc>(
        create: (context) => _addOtherSelfReportBloc = AddOtherSelfReportBloc(),
        child: BlocListener(
          cubit: _addOtherSelfReportBloc,
          listener: (BuildContext context, dynamic state) {
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
                  builder: (context) => DialogTextOnly(
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
            padding: const EdgeInsets.symmetric(horizontal: Dimens.contentPadding),
            child: ListView(
              controller: _scrollController,
              children: <Widget>[
                AnimatedOpacity(
                  opacity: _showTitle ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 250),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      Dictionary.previewData,
                      style: TextStyle(
                          fontFamily: FontsFamily.lato,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: Dimens.padding),
                widget.nik.isEmpty
                    ? Container()
                    : buildPreviewText(Dictionary.nik, widget.nik),
                const SizedBox(height: Dimens.padding),
                buildPreviewText(Dictionary.name, widget.name),
                const SizedBox(height: Dimens.padding),
                buildPreviewText(
                    Dictionary.birthday,
                    DateFormat.yMMMMd('id')
                        .format(DateTime.parse(widget.birthday))),
                const SizedBox(height: Dimens.padding),
                buildPreviewText(Dictionary.gender,
                    widget.gender == 'M' ? 'Laki-laki' : 'Perempuan'),
                const SizedBox(height: Dimens.padding),
                buildPreviewText(Dictionary.relation, widget.relation,
                    withDivider: false),
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
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
            margin: const EdgeInsets.all(Dimens.padding),
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
                const SizedBox(height: 24.0),
                Text(
                  titleDialog,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: FontsFamily.roboto,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  descDialog,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: FontsFamily.roboto,
                      fontSize: 12.0,
                      color: Colors.grey[600]),
                ),
                const SizedBox(height: 24.0),
                RoundedButton(
                    title: Dictionary.ok.toUpperCase(),
                    textStyle: TextStyle(
                        fontFamily: FontsFamily.roboto,
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

  Widget buildPreviewText(String label, value, {bool withDivider = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontFamily: FontsFamily.roboto,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                height: 18.0 / 12.0,
                color: ColorBase.grey800)),
        const SizedBox(
          height: 10.0,
        ),
        Text(value,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: FontsFamily.roboto,
                fontSize: 14.0,
                height: 18.0 / 12.0,
                color: ColorBase.grey800)),
        const SizedBox(
          height: Dimens.padding,
        ),

        /// Divider
        withDivider
            ? Container(
                height: 1.0,
                color: ColorBase.greyBorder,
              )
            : Container(),
      ],
    );
  }

  // Validate and Record data to firestore
  void _saveSelfReport() async {
    String otherUID = Uuid().v4();
    final AddOtherSelfReportModel data = AddOtherSelfReportModel(
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
