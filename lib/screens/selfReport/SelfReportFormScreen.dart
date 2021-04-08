import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/blocs/selfReport/dailyReport/DailyReportBloc.dart';
import 'package:pikobar_flutter/components/BlockCircleLoading.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/components/GroupedCheckBox.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/DailyReportModel.dart';
import 'package:pikobar_flutter/screens/selfReport/SelfReportDoneScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/RegexInputFormatter.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';
import 'package:pikobar_flutter/utilities/ReplaceText.dart';

class SelfReportFormScreen extends StatefulWidget {
  final String dailyId;
  final LatLng location;
  final DailyReportModel dailyReportModel;
  final String otherUID;
  final String analytics;
  final String cityId;
  final String recurrenceReport;
  final int firstData;
  final int lastData;

  SelfReportFormScreen(
      {Key key,
      @required this.dailyId,
      @required this.location,
      this.dailyReportModel,
      this.otherUID,
      @required this.analytics,
      this.cityId,
      this.recurrenceReport,
      @required this.firstData,
      @required this.lastData})
      : assert(dailyId != null),
        assert(location != null),
        super(key: key);

  @override
  _SelfReportFormScreenState createState() => _SelfReportFormScreenState();
}

class _SelfReportFormScreenState extends State<SelfReportFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _quarantineDateController = TextEditingController();
  TextEditingController _otherIndicationsController = TextEditingController();
  MaskedTextController _bodyTempController = MaskedTextController(mask: '00.0');
  ScrollController _scrollController;

  DailyReportBloc _dailyReportBloc;
  RemoteConfigBloc _remoteConfigBloc;
  String _format = 'dd-MMMM-yyyy';
  String _minDate = '2019-01-01';
  bool _isDateEmpty = false;
  bool _isquarantineDateEmpty = false;
  bool _isIndicationEmpty = false;
  bool _isOtherIndication = false;
  dynamic getMessage;

  List<String> _allItemList = [
    'Batuk',
    'Demam',
    'Menggigil',
    'Diare',
    'Lemah (Malaise)',
    'Nyeri Otot',
    'Nyeri Abdomen',
    'Mual Atau Muntah',
    'Pilek',
    'Sakit Kepala',
    'Sakit Tenggorokan',
    'Sesak Napas',
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
      if (_checkedItemList.contains(_allItemList[13])) {
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
      body: MultiBlocProvider(
          providers: [
            BlocProvider<RemoteConfigBloc>(
                create: (context) => _remoteConfigBloc = RemoteConfigBloc()
                  ..add(RemoteConfigLoad())),
            BlocProvider<DailyReportBloc>(
              create: (context) => _dailyReportBloc = DailyReportBloc(),
            )
          ],
          child: BlocListener(
              cubit: _dailyReportBloc,
              listener: (BuildContext context, dynamic state) {
                if (state is DailyReportSaved) {
                  AnalyticsHelper.setLogEvent(Analytics.dailyReportSaved);
                  Navigator.of(context).pop();
                  if (_checkedItemList.contains('Tidak Ada Gejala')) {
                    getMessage = getDataBottomSheet(
                        state.successMessage['saved_message']);
                  } else {
                    getMessage = getDataBottomSheet(
                        state.successMessage['indications_message']);
                  }

                  // Bottom sheet success message
                  showSuccessBottomSheet(
                      context: context,
                      image: Image.network(getMessage['icon']),
                      title: autoReplaceForDailyReport(
                          otherUID: widget.otherUID,
                          text: getMessage['title'],
                          replaceTo: ['Pasien', 'pasien'],
                          replaceFrom: ['Anda', 'anda']),
                      message: autoReplaceForDailyReport(
                          otherUID: widget.otherUID,
                          text: getMessage['description'],
                          replaceTo: ['pasien', 'pasien'],
                          replaceFrom: ['Anda', 'anda']),
                      onPressed: () async {
                        if (widget.dailyId == widget.lastData.toString()) {
                          Navigator.of(context).pop(true);
                          Navigator.of(context).pop(true);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelfReportDoneScreen(
                                      location: widget.location,
                                      otherUID: widget.otherUID,
                                      analytics: widget.analytics,
                                      recurrenceReport: widget.recurrenceReport,
                                    )),
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
                      builder: (context) => DialogTextOnly(
                            description: state.error.toString(),
                            buttonText: Dictionary.ok,
                            onOkPressed: () {
                              Navigator.of(context)
                                  .pop(); // To close the dialog
                            },
                          ));
                } else {
                  blockCircleLoading(context: context, dismissible: false);
                }
              },
              child: BlocBuilder<RemoteConfigBloc, RemoteConfigState>(builder:
                  (BuildContext context, RemoteConfigState remoteState) {
                return remoteState is RemoteConfigLoaded
                    ? buildForm(remoteState.remoteConfig)
                    : Container();
              }))),
    );
  }

  Widget buildForm(RemoteConfig remoteState) {
    final Map<String, dynamic> successMessage = RemoteConfigHelper.decode(
        remoteConfig: remoteState,
        firebaseConfig: FirebaseConfig.successMessageSelfReport,
        defaultValue: FirebaseConfig.successMessageSelfReportDefaultValue);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.padding),
      child: Form(
        key: _formKey,
        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            AnimatedOpacity(
              opacity: _showTitle ? 0.0 : 1.0,
              duration: Duration(milliseconds: 250),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  Dictionary.selfReportForm,
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: Dimens.padding),
            widget.dailyId == (widget.firstData + 1).toString()
                ? Column(
                    children: <Widget>[
                      buildLabel(
                          text: autoReplaceForDailyReport(
                              otherUID: widget.otherUID,
                              text: Dictionary.selfReportQuestion1,
                              replaceTo: ['pasien', 'pasien'],
                              replaceFrom: ['Anda', 'anda'])),
                      const SizedBox(height: Dimens.padding),
                      buildDateField(
                          title: Dictionary.contactDate,
                          placeholder: _dateController.text == ''
                              ? Dictionary.contactDatePlaceholder
                              : DateFormat.yMMMMd('id')
                                  .format(DateTime.parse(_dateController.text)),
                          isEmpty: _isDateEmpty,
                          controller: _dateController),
                      const SizedBox(height: Dimens.padding),
                    ],
                  )
                : Container(),
            widget.dailyId == (widget.firstData + 1).toString()
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildLabel(
                          text: autoReplaceForDailyReport(
                              otherUID: widget.otherUID,
                              text: Dictionary.quarantineQuestion,
                              replaceTo: ['pasien', 'pasien'],
                              replaceFrom: ['Anda', 'anda'])),
                      const SizedBox(height: Dimens.padding),
                      buildDateField(
                          title: Dictionary.quarantineDate,
                          placeholder: _quarantineDateController.text == ''
                              ? Dictionary.quarantineDatePlaceholder
                              : DateFormat.yMMMMd('id').format(DateTime.parse(
                                  _quarantineDateController.text)),
                          isEmpty: _isquarantineDateEmpty,
                          controller: _quarantineDateController),
                      const SizedBox(height: Dimens.padding),
                    ],
                  )
                : Container(),
            buildLabel(text: Dictionary.selfReportQuestion2),
            const SizedBox(height: Dimens.padding),
            Align(
              alignment: Alignment.centerLeft,
              child: GroupedCheckBox(
                itemHeight: 40.0,
                indexAllDisabled: 12,
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
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
                    _isOtherIndication = itemList.contains(_allItemList[13]);
                    _isIndicationEmpty = itemList.isEmpty;
                  });
                },
                textStyle: TextStyle(
                    fontFamily: FontsFamily.roboto,
                    fontSize: 14,
                    color: ColorBase.grey800),
              ),
            ),
            const SizedBox(height: Dimens.padding),
            Container(
              height: 80.0,
              decoration: BoxDecoration(
                  color: ColorBase.greyContainer,
                  border: Border.all(
                      color: _isOtherIndicationEmpty()
                          ? Colors.red
                          : ColorBase.greyBorder),
                  borderRadius: BorderRadius.circular(Dimens.borderRadius)),
              padding: const EdgeInsets.symmetric(horizontal: Dimens.padding),
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
                    padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                    child: Text(
                      Dictionary.indications +
                          Dictionary.pleaseCompleteAllField,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : Container(),
            _isOtherIndicationEmpty()
                ? Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                    child: Text(
                      Dictionary.otherIndication +
                          Dictionary.pleaseCompleteAllField,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : Container(),
            const SizedBox(height: Dimens.padding),
            buildLabel(text: Dictionary.bodyTemperature, required: false),
            const SizedBox(height: Dimens.padding),
            Stack(children: [
              Container(
                height: 50.0,
                decoration: BoxDecoration(
                    color: ColorBase.greyContainer,
                    border: Border.all(color: ColorBase.greyBorder),
                    borderRadius: BorderRadius.circular(Dimens.borderRadius)),
                padding: const EdgeInsets.symmetric(horizontal: Dimens.padding),
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
                      padding: const EdgeInsets.symmetric(vertical: 13),
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
            const SizedBox(height: 32.0),
            RoundedButton(
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
                title: Dictionary.save,
                elevation: 0.0,
                color: isEmptyField() ? ColorBase.disableText : ColorBase.green,
                textStyle: TextStyle(
                    fontFamily: FontsFamily.roboto,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
                onPressed: () {
                  if (!isEmptyField()) {
                    if (_bodyTempController.text.isEmpty) {
                      getMessage = getDataBottomSheet(
                          successMessage['temperature_message']);
                      // Bottom sheet temperature message
                      showSuccessBottomSheet(
                          context: context,
                          image: Image.network(getMessage['icon']),
                          title: autoReplaceForDailyReport(
                              otherUID: widget.otherUID,
                              text: getMessage['title'],
                              replaceTo: ['Pasien', 'pasien'],
                              replaceFrom: ['Anda', 'anda']),
                          message: autoReplaceForDailyReport(
                              otherUID: widget.otherUID,
                              text: getMessage['description'],
                              replaceTo: ['pasien', 'pasien'],
                              replaceFrom: ['Anda', 'anda']),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            _saveSelfReport(successMessage);
                          });
                    } else {
                      _saveSelfReport(successMessage);
                    }
                  }
                }),
            const SizedBox(height: Dimens.padding),
          ],
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
                  color: Colors.green))
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
            if (placeholder == Dictionary.quarantineDatePlaceholder &&
                _dateController.text == '') {
              showDialog(
                  context: context,
                  builder: (context) => DialogTextOnly(
                        description: Dictionary.quarantineDateInformation,
                        buttonText: Dictionary.ok,
                        onOkPressed: () {
                          Navigator.of(context).pop(); // To close the dialog
                        },
                      ));
            } else {
              _showDatePicker(controller, isEmpty);
            }
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
                  padding: const EdgeInsets.only(left: 10),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
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
            ? const SizedBox(
                height: 10,
              )
            : Container(),
        isEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  title + Dictionary.pleaseCompleteAllField,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              )
            : Container()
      ],
    );
  }

  bool isEmptyField() {
    if (widget.dailyId == (widget.firstData + 1).toString()) {
      return _checkedItemList.isEmpty ||
          _dateController.text.isEmpty ||
          _quarantineDateController.text.isEmpty;
    } else {
      return _checkedItemList.isEmpty;
    }
  }

  bool _isOtherIndicationEmpty() =>
      _isOtherIndication && _otherIndicationsController.text.isEmpty;

  // Function to build Date Picker
  void _showDatePicker(TextEditingController controller, bool isEmpty) {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(Dictionary.save, style: TextStyle(color: Colors.red)),
        cancel: Text(Dictionary.cancel, style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime:
          controller == _quarantineDateController && _dateController.text != ''
              ? DateTime.parse(_dateController.text)
              : DateTime.parse(_minDate),
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

  // Validate and Record data to firestore
  void _saveSelfReport(dynamic successMessage) async {
    setState(() {
      _isIndicationEmpty = _checkedItemList.isEmpty;

      if (widget.dailyId == (widget.firstData + 1).toString()) {
        _isDateEmpty = _dateController.text.isEmpty;
        _isquarantineDateEmpty = _quarantineDateController.text.isEmpty;
      } else {
        _isDateEmpty = false;
        _isquarantineDateEmpty = false;
      }
      if (_isOtherIndication) {
        if (!_isOtherIndicationEmpty()) {
          _checkedItemList.add(_otherIndicationsController.text.trim());
        }
      }
    });

    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();

      if (!_isDateEmpty &&
          !_isIndicationEmpty &&
          !_isOtherIndicationEmpty()) {
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
            location: widget.location,
            recurrenceReport: widget.recurrenceReport);

        _dailyReportBloc.add(DailyReportSave(data,
            otherUID: widget.otherUID, successMessage: successMessage));
      }
    }
  }

  dynamic getDataBottomSheet(dynamic successMessage) {
    getMessage = successMessage;
    List<dynamic> listOfCityId = [];
    for (var i = 0; i < getMessage.length; i++) {
      listOfCityId.add(getMessage[i]['city_id']
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', ''));
    }

    if (listOfCityId.contains(widget.cityId)) {
      getMessage.removeWhere(
          (element) => !element['city_id'].contains(widget.cityId));
    }
    return getMessage[0];
  }

  @override
  void dispose() {
    super.dispose();
    _dailyReportBloc.close();
    _remoteConfigBloc.close();
    _otherIndicationsController.dispose();
    _bodyTempController.dispose();
    _dateController.dispose();
    _quarantineDateController.dispose();
  }
}
