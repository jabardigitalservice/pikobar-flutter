import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/blocs/selfReport/contactHistorySave/ContactHistorySaveBloc.dart';
import 'package:pikobar_flutter/components/BlockCircleLoading.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/GroupedRadioButton.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/ContactHistoryModel.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';

class ContactHistoryFormScreen extends StatefulWidget {
  @override
  _ContactHistoryFormScreenState createState() =>
      _ContactHistoryFormScreenState();
}

class _ContactHistoryFormScreenState extends State<ContactHistoryFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameFieldController = TextEditingController();
  final _phoneFieldController = TextEditingController();
  final _dateController = TextEditingController();

  RemoteConfigBloc _remoteConfigBloc;
  ContactHistorySaveBloc _contactHistorySaveBloc;

  String _format = 'yyyy-MMMM-dd';
  String _minDate = '2019-01-01';
  String _gender = '';
  String _relation = '';

  bool _isNameEmpty = false;
  bool _isPhoneEmpty = false;
  bool _isGenderEmpty = false;
  bool _isRelationEmpty = false;
  bool _isDateEmpty = false;

  @override
  void initState() {
    super.initState();

    AnalyticsHelper.setLogEvent(Analytics.tappedContactHistoryForm);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteConfigBloc>(
            create: (context) => _remoteConfigBloc = RemoteConfigBloc()
              ..add(RemoteConfigLoad())),
        BlocProvider(
            create: (context) =>
                _contactHistorySaveBloc = ContactHistorySaveBloc())
      ],
      child: BlocListener(
        bloc: _contactHistorySaveBloc,
        listener: (context, state) {
          if (state is ContactHistorySaved) {

            // Show success bottom sheet dialog
            // when contact history data is successfully saved
            //
            // Record log success to analytics
            AnalyticsHelper.setLogEvent(Analytics.contactHistorySaved);
            Navigator.of(context).pop();
            showSuccessBottomSheet(
                context: context,
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                });
          } else if (state is ContactHistorySaveFailure) {

            // Show error dialog
            // when contact history data fails to be saved
            //
            // Record log failure to analytics
            AnalyticsHelper.setLogEvent(Analytics.contactHistoryFailed);
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

            // Show loading
            // while processing of saving data
            blockCircleLoading(context: context, dismissible: false);
          }
        },
        child: Scaffold(
          appBar:
              CustomAppBar.defaultAppBar(title: Dictionary.contactHistoryForm),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
            child: BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
                builder: (context, state) {
              if (state is RemoteConfigLoaded) {
                return _buildForm(state.remoteConfig);
              }

              return Center(child: CircularProgressIndicator());
            }),
          ),
        ),
      ),
    );
  }

  // Build the contact history form
  Form _buildForm(RemoteConfig remoteConfig) {

    // Get the contact history form data from the remote config
    Map<String, dynamic> remoteContactHistoryForm = remoteConfig != null &&
            remoteConfig.getString(FirebaseConfig.contactHistoryForm) != null
        ? json.decode(remoteConfig.getString(FirebaseConfig.contactHistoryForm))
        : json.decode(FirebaseConfig.contactHistoryFormDefaultValue);

    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          SizedBox(height: Dimens.padding),
          _buildLabel(text: Dictionary.contactName),
          _buildTextField(
              title: Dictionary.contactName,
              controller: _nameFieldController,
              hint: Dictionary.placeholderName,
              isEmpty: _isNameEmpty),
          _buildLabel(text: Dictionary.phoneNumber),
          _buildTextField(
              title: Dictionary.phoneNumber,
              controller: _phoneFieldController,
              hint: Dictionary.placeholderPhone,
              isEmpty: _isPhoneEmpty,
              textInputType: TextInputType.phone),
          _buildLabel(text: Dictionary.gender),
          _buildRadioButton(
              title: Dictionary.gender,
              itemList: <String>[
                "Laki - Laki",
                "Perempuan",
              ],
              onChanged: (label, index) {
                setState(() {
                  _gender = index == 0 ? 'M' : 'F';
                  _isGenderEmpty = _gender.isEmpty;
                });
              },
              validator: (value) {
                return _isGenderEmpty
                    ? '${Dictionary.gender + Dictionary.pleaseCompleteAllField}'
                    : null;
              }),
          _buildLabel(text: Dictionary.relation),
          _buildRadioButton(
              title: Dictionary.relation,
              itemList: remoteContactHistoryForm['relation_list'].cast<String>(),
              onChanged: (label, index) {
                setState(() {
                  _relation = label;
                  _isRelationEmpty = _relation.isEmpty;
                });
              },
              validator: (value) {
                return _isRelationEmpty
                    ? '${Dictionary.relation + Dictionary.pleaseCompleteAllField}'
                    : null;
              }),
          _buildLabel(text: Dictionary.lastDateInTouch, required: false),
          Container(
            margin: EdgeInsets.only(
                top: Dimens.fieldMarginTop, bottom: Dimens.fieldMarginBottom),
            child: _buildDateField(
                title: Dictionary.contactDate,
                placeholder: _dateController.text == ''
                    ? Dictionary.contactDatePlaceholder
                    : DateFormat.yMMMMd('id')
                        .format(DateTime.parse(_dateController.text)),
                isEmpty: false),
          ),
          Container(
            margin: EdgeInsets.only(
                top: Dimens.buttonTopMargin, bottom: Dimens.fieldMarginBottom),
            child: RoundedButton(
                title: Dictionary.save,
                elevation: 0.0,
                color: ColorBase.green,
                textStyle: TextStyle(
                    fontFamily: FontsFamily.lato,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
                onPressed: _saveContactHistory),
          ),
        ],
      ),
    );
  }

  // Build each label on the form
  _buildLabel({@required String text, bool required = true}) {
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

  // Build each text field on the form
  _buildTextField(
      {@required TextEditingController controller,
      @required title,
      @required String hint,
      bool isEmpty,
      TextInputType textInputType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: Dimens.fieldSize,
          margin: EdgeInsets.only(
              top: Dimens.fieldMarginTop,
              bottom: isEmpty ? Dimens.sbHeight : Dimens.fieldMarginBottom),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: isEmpty ? Colors.red : ColorBase.menuBorderColor)),
          padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
          child: TextFormField(
            controller: controller,
            maxLines: 1,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(
                    color: ColorBase.darkGrey,
                    fontFamily: FontsFamily.lato,
                    fontSize: 12),
                contentPadding: EdgeInsets.only(top: -Dimens.fieldMarginTop)),
            keyboardType:
                textInputType != null ? textInputType : TextInputType.text,
          ),
        ),
        isEmpty
            ? Padding(
                padding: EdgeInsets.only(
                    left: Dimens.contentPadding,
                    bottom: Dimens.fieldMarginBottom),
                child: Text(
                  title + Dictionary.pleaseCompleteAllField,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              )
            : Container()
      ],
    );
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

  // Build date field on the form
  _buildDateField({String title, placeholder, bool isEmpty}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            _showDatePicker();
          },
          child: Container(
            height: Dimens.fieldSize,
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
            ? Padding(
                padding: EdgeInsets.only(
                    left: Dimens.contentPadding, top: Dimens.sbHeight),
                child: Text(
                  title + Dictionary.pleaseCompleteAllField,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              )
            : Container()
      ],
    );
  }

  // Show date picker when date field is tapped
  _showDatePicker() {
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

  // Validate and record data to firestore
  _saveContactHistory() async {
    setState(() {
      _isNameEmpty = _nameFieldController.text.isEmpty;
      _isPhoneEmpty = _phoneFieldController.text.isEmpty;
      _isGenderEmpty = _gender.isEmpty;
      _isRelationEmpty = _relation.isEmpty;
      _isDateEmpty = _dateController.text.isEmpty;
    });

    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();

      if (!_isNameEmpty &&
          !_isPhoneEmpty &&
          !_isGenderEmpty &&
          !_isRelationEmpty) {
        final data = ContactHistoryModel(
            createdAt: DateTime.now(),
            lastContactDate:
                _isDateEmpty ? null : DateTime.parse(_dateController.text),
            name: _nameFieldController.text.trim(),
            phoneNumber: _phoneFieldController.text,
            gender: _gender,
            relation: _relation);

        _contactHistorySaveBloc.add(ContactHistorySave(data: data));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _contactHistorySaveBloc.close();
    if (_remoteConfigBloc != null) {
      _remoteConfigBloc.close();
    }
    _nameFieldController.dispose();
    _phoneFieldController.dispose();
    _dateController.dispose();
  }
}
