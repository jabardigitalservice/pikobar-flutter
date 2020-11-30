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
import 'package:pikobar_flutter/screens/selfReport/SelfReportDoneScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/RegexInputFormatter.dart';

class SelfReportFormScreen extends StatefulWidget {
  final String dailyId;
  final LatLng location;
  final DailyReportModel dailyReportModel;
  final String otherUID;
  final String analytics;

  SelfReportFormScreen(
      {@required this.dailyId,
      @required this.location,
      this.dailyReportModel,
      this.otherUID,
      @required this.analytics})
      : assert(dailyId != null),
        assert(location != null);

  @override
  _SelfReportFormScreenState createState() => _SelfReportFormScreenState();
}

class _SelfReportFormScreenState extends State<SelfReportFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _quarantineDateController = TextEditingController();
  final _otherIndicationsController = TextEditingController();
  final _bodyTempController = MaskedTextController(mask: '00.0');
  ScrollController _scrollController;

  DailyReportBloc _dailyReportBloc;

  String _format = 'dd-MMMM-yyyy';
  String _minDate = '2019-01-01';
  bool _isDateEmpty = false;
  bool _isquarantineDateEmpty = false;
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
      _quarantineDateController.text =
          widget.dailyReportModel.quarantineDate != null
              ? widget.dailyReportModel.quarantineDate.toString()
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
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    AnalyticsHelper.setCurrentScreen(Analytics.selfReports);
    AnalyticsHelper.setLogEvent(Analytics.tappedDailyReportForm);
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
        title: Dictionary.selfReportForm,
      ),
      backgroundColor: Colors.white,
      body: BlocProvider<DailyReportBloc>(
        create: (BuildContext context) => _dailyReportBloc = DailyReportBloc(),
        child: BlocListener(
          cubit: _dailyReportBloc,
          listener: (context, state) {
            if (state is DailyReportSaved) {
              AnalyticsHelper.setLogEvent(Analytics.dailyReportSaved);
              Navigator.of(context).pop();
              // Bottom sheet success message
              _showBottomSheetForm(
                  '${Environment.imageAssets}daily_success.png',
                  Dictionary.savedSuccessfully,
                  Dictionary.dailySuccess, () async {
                if (widget.dailyId == '14') {
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelfReportDoneScreen(
                            widget.location,
                            widget.otherUID,
                            widget.analytics)),
                  );
                } else {
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                }
              });
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
                controller: _scrollController,
                children: <Widget>[
                  AnimatedOpacity(
                    opacity: _showTitle ? 0.0 : 1.0,
                    duration: Duration(milliseconds: 250),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        Dictionary.selfReportForm,
                        style: TextStyle(
                            fontFamily: FontsFamily.lato,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
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
                                isEmpty: _isDateEmpty,
                                controller: _dateController),
                            SizedBox(height: Dimens.padding),
                          ],
                        )
                      : Container(),
                  widget.dailyId == '1'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            buildLabel(text: Dictionary.quarantineQuestion),
                            SizedBox(height: Dimens.padding),
                            buildDateField(
                                title: Dictionary.quarantineDate,
                                placeholder: _quarantineDateController.text ==
                                        ''
                                    ? Dictionary.quarantineDatePlaceholder
                                    : DateFormat.yMMMMd('id').format(
                                        DateTime.parse(
                                            _quarantineDateController.text)),
                                isEmpty: _isquarantineDateEmpty,
                                controller: _quarantineDateController),
                            SizedBox(height: Dimens.padding),
                          ],
                        )
                      : Container(),
                  buildLabel(text: Dictionary.selfReportQuestion2),
                  SizedBox(height: Dimens.padding),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GroupedCheckBox(
                      itemHeight: 40.0,
                      indexAllDisabled: 11,
                      borderRadius: BorderRadius.circular(8.0),
                      color: ColorBase.netralGrey,
                      defaultSelectedList: _checkedItemList,
                      activeColor: ColorBase.primaryGreen,
                      itemLabelList: _allItemList,
                      itemValueList: _allItemList,
                      orientation: CheckboxOrientation.VERTICAL,
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
                      textStyle: TextStyle(
                          fontFamily: FontsFamily.roboto,
                          fontSize: 14,
                          color: ColorBase.grey800),
                    ),
                  ),
                  SizedBox(height: Dimens.padding),
                  Container(
                    height: 80.0,
                    decoration: BoxDecoration(
                        color: ColorBase.greyContainer,
                        border: Border.all(
                            color: _isOtherIndicationEmpty
                                ? Colors.red
                                : ColorBase.greyBorder),
                        borderRadius: BorderRadius.circular(8.0)),
                    padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
                    child: TextField(
                      controller: _otherIndicationsController,
                      enabled: _isOtherIndication,
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: ColorBase.netralGrey,
                              fontFamily: FontsFamily.roboto,
                              fontSize: 14),
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
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: ColorBase.greyContainer,
                          border: Border.all(color: ColorBase.greyBorder),
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
                          suffixIcon: Padding(
                            padding: EdgeInsets.symmetric(vertical: 13),
                            child: Image.asset(
                              '${Environment.iconAssets}celcius_icon.png',
                            ),
                          ),
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: ColorBase.netralGrey,
                              fontFamily: FontsFamily.roboto,
                              fontSize: 14),
                          hintText: Dictionary.inputBodyTemperature,
                          counterText: "",
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 32.0),
                  RoundedButton(
                      borderRadius: BorderRadius.circular(8.0),
                      title: Dictionary.save,
                      elevation: 0.0,
                      color: ColorBase.green,
                      textStyle: TextStyle(
                          fontFamily: FontsFamily.roboto,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                      onPressed: () {
                        if (_bodyTempController.text.isEmpty) {
                          // Bottom sheet temperature message
                          _showBottomSheetForm(
                              '${Environment.imageAssets}temperature_info.png',
                              Dictionary.additionalTemperatureInformation,
                              Dictionary.descTemperatureInformation, () {
                            Navigator.of(context).pop(true);
                            _saveSelfReport();
                          });
                        } else {
                          _saveSelfReport();
                        }
                      }),
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
              fontFamily: FontsFamily.roboto,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              height: 18.0 / 12.0,
              color: Colors.black)),
      required
          ? TextSpan(
              text: Dictionary.requiredForm,
              style: TextStyle(
                  fontFamily: FontsFamily.roboto,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  height: 18.0 / 12.0,
                  color: Colors.red))
          : TextSpan()
    ]));
  }

  // Funtion to build date field
  Widget buildDateField(
      {String title,
      placeholder,
      bool isEmpty,
      TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            _showDatePicker(controller, isEmpty);
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ColorBase.greyContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isEmpty ? Colors.red : ColorBase.greyBorder)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    placeholder,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: FontsFamily.roboto,
                        color:
                            placeholder == Dictionary.contactDatePlaceholder ||
                                    placeholder ==
                                        Dictionary.quarantineDatePlaceholder
                                ? ColorBase.netralGrey
                                : Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                  child: Container(
                      height: 20,
                      child:
                          Image.asset('${Environment.iconAssets}calendar.png')),
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
  void _showDatePicker(TextEditingController controller, bool isEmpty) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(Dictionary.save, style: TextStyle(color: Colors.red)),
        cancel: Text(Dictionary.cancel, style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime: DateTime.parse(_minDate),
      maxDateTime: DateTime.now(),
      initialDateTime: controller.text == ''
          ? DateTime.now()
          : DateTime.parse(controller.text),
      dateFormat: _format,
      locale: DateTimePickerLocale.id,
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          controller.text = dateTime.toString();
          isEmpty = controller.text.isEmpty;
        });
      },
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
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: Dimens.padding),
                    height: 4,
                    width: 80.0,
                    decoration: BoxDecoration(
                        color: ColorBase.menuBorderColor,
                        borderRadius: BorderRadius.circular(30.0)),
                  ),
                ),
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
                      fontFamily: FontsFamily.roboto,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  descDialog,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: FontsFamily.roboto,
                      fontSize: 12.0,
                      height: 1.8,
                      color: Colors.grey[600]),
                ),
                SizedBox(height: 24.0),
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

  // Validate and Record data to firestore
  void _saveSelfReport() async {
    setState(() {
      _isIndicationEmpty = _checkedItemList.isEmpty;
      if (widget.dailyId == '1') {
        _isDateEmpty = _dateController.text.isEmpty;
        _isquarantineDateEmpty = _quarantineDateController.text.isEmpty;
      } else {
        _isDateEmpty = false;
        _isquarantineDateEmpty = false;
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
            quarantineDate: _quarantineDateController.text.isNotEmpty
                ? DateTime.parse(_quarantineDateController.text)
                : null,
            indications: _checkedItemList.toString(),
            bodyTemperature: _bodyTempController.text,
            location: widget.location);
        _dailyReportBloc.add(DailyReportSave(data, otherUID: widget.otherUID));
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
    _quarantineDateController.dispose();
  }
}
