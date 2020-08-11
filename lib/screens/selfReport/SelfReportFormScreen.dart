import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/blocs/selfReport/dailyReport/DailyReportBloc.dart';
import 'package:pikobar_flutter/components/BlockCircleLoading.dart';
import 'package:pikobar_flutter/components/GroupedCheckBox.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/DailyReportModel.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/RegexInputFormatter.dart';

class SelfReportFormScreen extends StatefulWidget {
  final String dailyId;
  final LatLng location;
  final DailyReportModel dailyReportModel;

  SelfReportFormScreen(
      {@required this.dailyId, @required this.location, this.dailyReportModel})
      : assert(dailyId != null),
        assert(location != null);

  @override
  _SelfReportFormScreenState createState() => _SelfReportFormScreenState();
}

class _SelfReportFormScreenState extends State<SelfReportFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _otherIndicationsController = TextEditingController();
  final _bodyTempController = MaskedTextController(mask: '00.0');

  DailyReportBloc _dailyReportBloc;

  String _format = 'yyyy-MMMM-dd';
  String _minDate = '2019-01-01';
  bool _isDateEmpty = false;
  bool _isIndicationEmpty = false;
  bool _isOtherIndicationEmpty = false;
  bool _isOtherIndication = false;

  List<String> _allItemList = [
    'Batuk',
    'Demam',
    'Diare',
    'Lemah/Lemas',
    'Nyeri Perut',
    'Nyeri Otot',
    'Mual Atau Muntah',
    'Pilek',
    'Sakit Kepala',
    'Sakit Tenggorokan',
    'Sesak Nafas',
    'Tidak Ada Gejala',
    'Gejala Lainnya'
  ];

  List<String> _checkedItemList = [];

  @override
  void initState() {
    super.initState();

    /// If DailyReportModel not null fill data to form
    if (widget.dailyReportModel != null) {
      _dateController.text = widget.dailyReportModel.contactDate != null
          ? widget.dailyReportModel.contactDate.toString()
          : '';
      _bodyTempController.text = widget.dailyReportModel.bodyTemperature;
      _checkedItemList = widget.dailyReportModel.indications
          .substring(1, widget.dailyReportModel.indications.length - 1)
          .split(', ');
      if (_checkedItemList.contains(_allItemList[12])) {
        _otherIndicationsController.text =
            _checkedItemList[_checkedItemList.length - 1];
        _isOtherIndication = true;
        _checkedItemList.removeLast();
      }
    }

    AnalyticsHelper.setCurrentScreen(Analytics.selfReports);
    AnalyticsHelper.setLogEvent(Analytics.tappedDailyReportForm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: Dictionary.selfReportForm),
      body: BlocProvider<DailyReportBloc>(
        create: (BuildContext context) => _dailyReportBloc = DailyReportBloc(),
        child: BlocListener(
          bloc: _dailyReportBloc,
          listener: (context, state) {
            if (state is DailyReportSaved) {
              AnalyticsHelper.setLogEvent(Analytics.dailyReportSaved);
              Navigator.of(context).pop();
              _showSuccessBottomSheet();
            } else if (state is DailyReportFailed) {
              AnalyticsHelper.setLogEvent(Analytics.dailyReportFailed);
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
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: Dimens.padding),
                  widget.dailyId == '1'
                      ? Column(
                          children: <Widget>[
                            buildLabel(text: Dictionary.selfReportQuestion1),
                            SizedBox(height: Dimens.padding),
                            buildDateField(
                                title: Dictionary.contactDate,
                                placeholder: _dateController.text == ''
                                    ? Dictionary.contactDatePlaceholder
                                    : DateFormat.yMMMMd('id').format(
                                        DateTime.parse(_dateController.text)),
                                isEmpty: _isDateEmpty),
                            SizedBox(height: Dimens.padding),
                          ],
                        )
                      : Container(),
                  buildLabel(text: Dictionary.selfReportQuestion2),
                  SizedBox(height: Dimens.padding),
                  GroupedCheckBox(
                    itemHeight: 40.0,
                    indexAllDisabled: 11,
                    borderRadius: BorderRadius.circular(8.0),
                    color: ColorBase.menuBorderColor,
                    defaultSelectedList: _checkedItemList,
                    activeColor: ColorBase.green,
                    itemLabelList: _allItemList,
                    itemValueList: _allItemList,
                    orientation: CheckboxOrientation.WRAP,
                    itemWidth: MediaQuery.of(context).size.width / 2 - 21,
                    wrapDirection: Axis.horizontal,
                    wrapSpacing: 10.0,
                    wrapRunSpacing: 10.0,
                    onChanged: (itemList) {
                      setState(() {
                        _checkedItemList = itemList;
                        _isOtherIndication =
                            itemList.contains(_allItemList[12]);
                        _isIndicationEmpty = itemList.isEmpty;
                      });
                    },
                    textStyle:
                        TextStyle(fontFamily: FontsFamily.lato, fontSize: 12),
                  ),
                  SizedBox(height: Dimens.padding),
                  Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: _isOtherIndicationEmpty
                                ? Colors.red
                                : ColorBase.menuBorderColor),
                        borderRadius: BorderRadius.circular(8.0)),
                    padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
                    child: TextField(
                      controller: _otherIndicationsController,
                      enabled: _isOtherIndication,
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: Dictionary.tellOtherIndication),
                    ),
                  ),
                  _isIndicationEmpty
                      ? Padding(
                          padding: EdgeInsets.only(left: 15.0, top: 10.0),
                          child: Text(
                            Dictionary.indications +
                                Dictionary.pleaseCompleteAllField,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        )
                      : Container(),
                  _isOtherIndicationEmpty
                      ? Padding(
                          padding: EdgeInsets.only(left: 15.0, top: 10.0),
                          child: Text(
                            Dictionary.otherIndication +
                                Dictionary.pleaseCompleteAllField,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        )
                      : Container(),
                  SizedBox(height: Dimens.padding),
                  buildLabel(text: Dictionary.bodyTemperature, required: false),
                  SizedBox(height: Dimens.padding),
                  Stack(children: [
                    Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          border: Border.all(color: ColorBase.menuBorderColor),
                          borderRadius: BorderRadius.circular(8.0)),
                      padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
                      child: TextField(
                        controller: _bodyTempController,
                        inputFormatters: [
                          RegexInputFormatter.withRegex(
                              '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$')
                        ],
                        maxLines: 1,
                        maxLength: 4,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: Dictionary.inputBodyTemperature,
                          counterText: "",
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: Container(
                        height: 40.0,
                        width: 40.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: ColorBase.menuBorderColor),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          '°C',
                          style: TextStyle(
                              fontFamily: FontsFamily.lato,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ]),
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
                      onPressed: _saveSelfReport),
                  SizedBox(height: Dimens.padding),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  RichText buildLabel({@required String text, bool required = true}) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: text,
          style: TextStyle(
              fontFamily: FontsFamily.lato,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              height: 18.0 / 12.0,
              color: Colors.black)),
      required
          ? TextSpan(
              text: ' (*)',
              style: TextStyle(
                  fontFamily: FontsFamily.lato,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  height: 18.0 / 12.0,
                  color: Colors.red))
          : TextSpan()
    ]));
  }

  // Funtion to build date field
  Widget buildDateField({String title, placeholder, bool isEmpty}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            _showDatePicker();
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isEmpty ? Colors.red : ColorBase.menuBorderColor)),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      height: 20,
                      child:
                          Image.asset('${Environment.iconAssets}calendar.png')),
                ),
                Text(
                  placeholder,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: FontsFamily.lato,
                      color: placeholder == Dictionary.contactDatePlaceholder
                          ? ColorBase.darkGrey
                          : Colors.black),
                ),
              ],
            ),
          ),
        ),
        isEmpty
            ? SizedBox(
                height: 10,
              )
            : Container(),
        isEmpty
            ? Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  title + Dictionary.pleaseCompleteAllField,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              )
            : Container()
      ],
    );
  }

  // Function to build Date Picker
  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(Dictionary.save, style: TextStyle(color: Colors.red)),
        cancel: Text(Dictionary.cancel, style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime: DateTime.parse(_minDate),
      maxDateTime: DateTime.now(),
      initialDateTime: _dateController.text == ''
          ? DateTime.now()
          : DateTime.parse(_dateController.text),
      dateFormat: _format,
      locale: DateTimePickerLocale.id,
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateController.text = dateTime.toString();
          _isDateEmpty = _dateController.text.isEmpty;
        });
      },
    );
  }

  // Bottom sheet success message
  void _showSuccessBottomSheet() {
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
                    '${Environment.imageAssets}daily_success.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(height: 24.0),
                Text(
                  Dictionary.savedSuccessfully,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  Dictionary.dailySuccess,
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
                    onPressed: () async {
                      Navigator.of(context).pop(true);
                      Navigator.of(context).pop(true);
                    })
              ],
            ),
          );
        });
  }

  // Validate and Record data to firestore
  void _saveSelfReport() async {
    setState(() {
      _isIndicationEmpty = _checkedItemList.isEmpty;
      if (widget.dailyId == '1') {
        _isDateEmpty = _dateController.text.isEmpty;
      } else {
        _isDateEmpty = false;
      }
      if (_isOtherIndication) {
        _isOtherIndicationEmpty = _otherIndicationsController.text.isEmpty;
        _checkedItemList.add(_otherIndicationsController.text.trim());
      } else {
        _isOtherIndicationEmpty = false;
      }
    });

    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();

      if (!_isDateEmpty && !_isIndicationEmpty && !_isOtherIndicationEmpty) {
        final data = DailyReportModel(
            id: widget.dailyId,
            createdAt: DateTime.now(),
            contactDate: _dateController.text.isNotEmpty
                ? DateTime.parse(_dateController.text)
                : null,
            indications: _checkedItemList.toString(),
            bodyTemperature: _bodyTempController.text,
            location: widget.location);
        _dailyReportBloc.add(DailyReportSave(data));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _dailyReportBloc.close();
    _otherIndicationsController.dispose();
    _bodyTempController.dispose();
    _dateController.dispose();
  }
}
