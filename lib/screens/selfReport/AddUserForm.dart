import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/blocs/selfReport/addOtherSelfReport/AddOtherSelfReportBloc.dart';
import 'package:pikobar_flutter/components/Announcement.dart';
import 'package:pikobar_flutter/components/BlockCircleLoading.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/GroupedRadioButton.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/AddOtherSelfReportModel.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/Validations.dart';
import 'package:uuid/uuid.dart';

class AddUserFormScreen extends StatefulWidget {
  @override
  _AddUserFormScreenState createState() => _AddUserFormScreenState();
}

class _AddUserFormScreenState extends State<AddUserFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _relationController = TextEditingController();
  final _nikController = MaskedTextController(mask: '0000000000000000');

  bool isBirthdayEmpty = false;
  bool isGenderEmpty = false;
  bool isRelationEmpty = false;

  AddOtherSelfReportBloc _addOtherSelfReportBloc;

  String _format = 'dd-MMMM-yyyy';
  String minDate = '1900-01-01';

  @override
  void initState() {
    super.initState();

    // AnalyticsHelper.setCurrentScreen(Analytics.selfReports);
    // AnalyticsHelper.setLogEvent(Analytics.tappedDailyReportForm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: Dictionary.addUserForm),
      body: BlocProvider<AddOtherSelfReportBloc>(
        create: (BuildContext context) =>
            _addOtherSelfReportBloc = AddOtherSelfReportBloc(),
        child: BlocListener(
          cubit: _addOtherSelfReportBloc,
          listener: (context, state) {
            if (state is AddOtherSelfReportSaved) {
              AnalyticsHelper.setLogEvent(Analytics.dailyReportSaved);
              Navigator.of(context).pop();
              // Bottom sheet success message
              _showBottomSheetForm(
                  '${Environment.imageAssets}daily_success.png',
                  Dictionary.savedSuccessfully,
                  Dictionary.dailySuccess, () async {
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              });
            } else if (state is AddOtherSelfReportFailed) {
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
                  buildAnnouncement(),
                  SizedBox(height: Dimens.padding),
                  buildTextField(
                      controller: _nikController,
                      hintText: Dictionary.placeholderYourNIK,
                      isRequired: false,
                      isEdit: true,
                      title: Dictionary.nik,
                      textInputType: TextInputType.number),
                  SizedBox(height: Dimens.padding),
                  buildTextField(
                      controller: _nameController,
                      hintText: Dictionary.placeholderYourName,
                      isEdit: true,
                      title: Dictionary.name,
                      validation: Validations.nameValidation,
                      textInputType: TextInputType.text),
                  SizedBox(height: Dimens.padding),
                  buildLabel(text: Dictionary.birthday, required: true),
                  SizedBox(height: Dimens.padding),
                  buildDateField(
                      title: Dictionary.birthday,
                      placeholder: _dateController.text == ''
                          ? Dictionary.birthdayPlaceholder
                          : DateFormat.yMMMMd('id')
                              .format(DateTime.parse(_dateController.text)),
                      isEmpty: isBirthdayEmpty),
                  SizedBox(height: Dimens.padding),
                  buildLabel(text: Dictionary.gender),
                  _buildRadioButton(
                      title: Dictionary.gender,
                      itemList: <String>[
                        "Laki - Laki",
                        "Perempuan",
                      ],
                      onChanged: (label, index) {
                        setState(() {
                          _genderController.text = index == 0 ? 'M' : 'F';
                          isGenderEmpty = _genderController.text.isEmpty;
                        });
                      },
                      validator: (value) {
                        return isGenderEmpty
                            ? '${Dictionary.gender + Dictionary.pleaseCompleteAllField}'
                            : null;
                      }),
                  buildLabel(text: Dictionary.relation),
                  _buildRadioButton(
                      title: Dictionary.relationOtherSelfReport,
                      itemList: <String>[
                        "Orangtua",
                        "Suami/Istri",
                        "Anak",
                        "Kerabat Lainnya",
                      ],
                      onChanged: (label, index) {
                        setState(() {
                          _relationController.text = label;
                          isRelationEmpty = _relationController.text.isEmpty;
                        });
                      },
                      validator: (value) {
                        return isRelationEmpty
                            ? '${Dictionary.relation + Dictionary.pleaseCompleteAllField}'
                            : null;
                      }),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Funtion to build text field
  Widget buildTextField(
      {String title,
      TextEditingController controller,
      String hintText,
      validation,
      TextInputType textInputType,
      TextStyle textStyle,
      bool isEdit,
      int maxLines,
      bool isRequired = true}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 12.0,
                    color: ColorBase.veryDarkGrey,
                    fontFamily: FontsFamily.lato,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                isRequired ? ' (*)' : '',
                style: TextStyle(fontSize: 15.0, color: Colors.red),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLines: maxLines != null ? maxLines : 1,
            style: isEdit
                ? TextStyle(
                    color: Colors.black,
                    fontFamily: FontsFamily.lato,
                    fontSize: 12)
                : TextStyle(
                    color: ColorBase.disableText,
                    fontFamily: FontsFamily.lato,
                    fontSize: 12),
            enabled: isEdit,
            validator: validation,
            textCapitalization: TextCapitalization.words,
            controller: controller,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                    color: ColorBase.darkGrey,
                    fontFamily: FontsFamily.lato,
                    fontSize: 12),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.red, width: 1.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: ColorBase.menuBorderColor, width: 1.5)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: ColorBase.menuBorderColor, width: 1.5)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: ColorBase.menuBorderColor, width: 1.5))),
            keyboardType:
                textInputType != null ? textInputType : TextInputType.text,
          )
        ],
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
                      color: placeholder == Dictionary.birthdayPlaceholder
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
      minDateTime: DateTime.parse(minDate),
      maxDateTime: DateTime.now(),
      initialDateTime: _dateController.text == ''
          ? DateTime.now()
          : DateTime.parse(_dateController.text),
      dateFormat: _format,
      locale: DateTimePickerLocale.id,
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateController.text = dateTime.toString();
          isBirthdayEmpty = _dateController.text.isEmpty;
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

  // Build each radio button on the form
  _buildRadioButton(
      {@required title,
      @required List<String> itemList,
      @required void Function(String label, int index) onChanged,
      FormFieldValidator<String> validator}) {
    return Container(
      margin: EdgeInsets.only(
          top: Dimens.fieldMarginTop, bottom: Dimens.fieldMarginBottom),
      child: GroupedRadioButton(
        itemWidth: MediaQuery.of(context).size.width / 2 - 21,
        itemHeight: 40.0,
        borderRadius: BorderRadius.circular(8.0),
        color: ColorBase.menuBorderColor,
        activeColor: ColorBase.green,
        itemLabelList: itemList,
        orientation: RadioButtonOrientation.WRAP,
        wrapDirection: Axis.horizontal,
        wrapSpacing: 10.0,
        wrapRunSpacing: 10.0,
        onChanged: (label, index) {
          setState(() {
            onChanged(label, index);
            FocusScope.of(context).unfocus();
          });
        },
        textStyle: TextStyle(fontFamily: FontsFamily.lato, fontSize: 12),
        validator: validator,
      ),
    );
  }

  /// Set up for show announcement widget
  Widget buildAnnouncement() {
    return Announcement(
      title: Dictionary.titleInfoTextAnnouncement,
      content: Dictionary.otherReportAnnouncement,
      context: context,
      onLinkTap: (url) {},
    );
  }

  // Validate and Record data to firestore
  void _saveSelfReport() async {
    print(isBirthdayEmpty);
    isBirthdayEmpty = _dateController.text.isEmpty;
    isRelationEmpty = _relationController.text.isEmpty;
    isGenderEmpty = _genderController.text.isEmpty;
    setState(() {
      if (_formKey.currentState.validate()) {
        FocusScope.of(context).unfocus();
        if (!isBirthdayEmpty && !isRelationEmpty && !isGenderEmpty) {
          String otherUID = Uuid().v4();
          final data = AddOtherSelfReportModel(
              userId: otherUID,
              createdAt: DateTime.now(),
              birthday: _dateController.text.isNotEmpty
                  ? DateTime.parse(_dateController.text)
                  : null,
              gender: _genderController.text,
              name: _nameController.text,
              nik: _nikController.text,
              relation: _relationController.text);
          _addOtherSelfReportBloc.add(AddOtherSelfReportSave(data));
        }
      }
    });

    @override
    void dispose() {
      super.dispose();
      _addOtherSelfReportBloc.close();
      _nikController.dispose();
      _nameController.dispose();
      _dateController.dispose();
    }
  }
}
