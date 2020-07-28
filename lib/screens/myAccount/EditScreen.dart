import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/profile/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/GeocoderRepository.dart';
import 'package:pikobar_flutter/repositories/ProfileRepository.dart';
import 'package:pikobar_flutter/screens/checkDistribution/components/LocationPicker.dart';
import 'package:pikobar_flutter/screens/myAccount/VerificationScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/Connection.dart';
import 'package:pikobar_flutter/utilities/Validations.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:pikobar_flutter/components/custom_dropdown.dart' as custom;
import 'package:flutter_masked_text/flutter_masked_text.dart';

class Edit extends StatefulWidget {
  final AsyncSnapshot<DocumentSnapshot> state;
  Edit({this.state});
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthDayController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  var _nikController = new MaskedTextController(mask: '0000000000000000');

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  String verificationID, smsCode;
  final ProfileRepository _profileRepository = ProfileRepository();
  ProfileBloc _profileBloc;
  PhoneVerificationCompleted verificationCompleted;
  PhoneVerificationFailed verificationFailed;
  PhoneCodeSent codeSent;
  String _format = 'yyyy-MMMM-dd';
  String minDate = '1900-01-01';
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  bool otpEnabled;
  bool isCityFieldEmpty = false;
  bool isBirthdayEmpty = false;
  bool isGenderEmpty = false;
  LatLng latLng;
  List<dynamic> listCity;

  @override
  void initState() {
    _nameController.text = widget.state.data['name'];
    _emailController.text = widget.state.data['email'];
    _phoneNumberController.text = widget.state.data['phone_number'] != null
        ? widget.state.data['phone_number'].toString().substring(3)
        : null;
    _addressController.text = widget.state.data['address'];
    _birthDayController.text = widget.state.data['birthdate'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
                widget.state.data['birthdate'].seconds * 1000)
            .toString();
    _genderController.text = widget.state.data['gender'];
    _cityController.text = widget.state.data['city_id'];
    _nikController.text = widget.state.data['nik'];
    latLng = widget.state.data['location'] == null
        ? null
        : new LatLng(widget.state.data['location'].latitude,
            widget.state.data['location'].longitude);
    print(latLng);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldState,
        appBar: CustomAppBar.defaultAppBar(
          title: Dictionary.edit,
        ),
        body: FutureBuilder<RemoteConfig>(
            future: setupRemoteConfig(),
            builder:
                (BuildContext context, AsyncSnapshot<RemoteConfig> snapshot) {
              otpEnabled = snapshot.data != null &&
                      snapshot.data.getBool(FirebaseConfig.otpEnabled) != null
                  ? snapshot.data.getBool(FirebaseConfig.otpEnabled)
                  : false;
              return BlocProvider<ProfileBloc>(
                  create: (BuildContext context) => _profileBloc =
                      ProfileBloc(profileRepository: _profileRepository),
                  child: BlocListener<ProfileBloc, ProfileState>(
                    listener: (context, state) {
                      if (state is ProfileFailure) {
                        // Show dialog error message otp
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => DialogTextOnly(
                                  description: state.error.toString(),
                                  buttonText: Dictionary.ok,
                                  onOkPressed: () {
                                    Navigator.of(context)
                                        .pop(); // To close the dialog
                                  },
                                ));
                        Scaffold.of(context).hideCurrentSnackBar();
                      } else if (state is ProfileWaiting) {
                      } else if (state is ProfileVerified) {
                        // Show dialog when otp is confirmed and back to profile menu
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => DialogTextOnly(
                                  description: Dictionary.codeVerified,
                                  buttonText: Dictionary.ok,
                                  onOkPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ));
                        Scaffold.of(context).hideCurrentSnackBar();
                      } else if (state is ProfileSaved) {
                        // Show dialog when profile succesfully change without change phone number or otp disable
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => DialogTextOnly(
                                  description: Dictionary.profileSaved,
                                  buttonText: Dictionary.ok,
                                  onOkPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context)
                                        .pop(); // To close the dialog
                                  },
                                ));
                        Scaffold.of(context).hideCurrentSnackBar();
                      } else if (state is ProfileOTPSent) {
                        // Show dialog when otp succesfully send to phone number and move page to Verification Screen
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => DialogTextOnly(
                                  description: Dictionary.codeSend +
                                      Dictionary.inaCode +
                                      _phoneNumberController.text,
                                  buttonText: Dictionary.ok,
                                  onOkPressed: () {
                                    // Close dialog
                                    Navigator.of(context).pop();
                                    // Move page to Verification Screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Verification(
                                                phoneNumber:
                                                    _phoneNumberController.text,
                                                uid: widget.state.data['id'],
                                                verificationID:
                                                    state.verificationID,
                                                gender: _genderController.text,
                                                address:
                                                    _addressController.text,
                                                cityId: _cityController.text,
                                                provinceId:
                                                    Dictionary.provinceId,
                                                name: _nameController.text,
                                                nik: _nikController.text,
                                                latLng: latLng,
                                                birthdate: DateTime.parse(
                                                    _birthDayController.text),
                                              )),
                                    );
                                  },
                                ));
                        Scaffold.of(context).hideCurrentSnackBar();
                      } else if (state is ProfileVerifiedFailed) {
                        // Show dialog when otp failed send to phone number
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => DialogTextOnly(
                                  description: Dictionary.codeSendFailed,
                                  buttonText: Dictionary.ok,
                                  onOkPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ));
                        Scaffold.of(context).hideCurrentSnackBar();
                      } else if (state is ProfileLoading) {
                        // Show dialog when loading
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Theme.of(context).primaryColor,
                            content: Row(
                              children: <Widget>[
                                CircularProgressIndicator(),
                                Container(
                                  margin: EdgeInsets.only(left: 15.0),
                                  child: Text(Dictionary.loading),
                                )
                              ],
                            ),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      } else {
                        Scaffold.of(context).hideCurrentSnackBar();
                      }
                    },
                    child: ListView(
                      padding: EdgeInsets.all(10),
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              buildTextField(
                                  title: Dictionary.name,
                                  hintText: Dictionary.placeholderYourName,
                                  controller: _nameController,
                                  validation: Validations.nameValidation,
                                  isEdit: true),
                              SizedBox(
                                height: 20,
                              ),
                              buildTextField(
                                  title: Dictionary.email,
                                  controller: _emailController,
                                  isEdit: false),
                              SizedBox(
                                height: 20,
                              ),
                              buildTextField(
                                  title: Dictionary.nik,
                                  controller: _nikController,
                                  textInputType: TextInputType.number,
                                  hintText: Dictionary.placeholderYourNIK,
                                  validation: Validations.nikValidation,
                                  isEdit: true),
                              SizedBox(
                                height: 20,
                              ),
                              buildPhoneField(
                                  title: Dictionary.telephoneNumber,
                                  controller: _phoneNumberController,
                                  validation: Validations.telephoneValidation,
                                  isEdit: true,
                                  hintText: Dictionary.phoneNumberPlaceholder),
                              SizedBox(
                                height: 20,
                              ),
                              buildRadioButton(
                                  title: Dictionary.gender,
                                  label: <String>[
                                    "Laki - Laki",
                                    "Perempuan",
                                  ],
                                  isEmpty: isGenderEmpty),
                              SizedBox(
                                height: 20,
                              ),
                              buildDateField(
                                  title: Dictionary.birthday,
                                  placeholder: _birthDayController.text == ''
                                      ? Dictionary.birthdayPlaceholder
  
       
                                      : DateFormat.yMMMMd('id').format(
                                          DateTime.parse(_birthDayController
                                              .text
                                              .substring(0, 10))),
                                  isEmpty: isBirthdayEmpty),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(left: 16.0, right: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          Dictionary.locationAddress,
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: ColorBase.veryDarkGrey,
                                              fontFamily: FontsFamily.lato,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      height: 45.0,
                                      child: OutlineButton(
                                        child: Row(
                                          children: <Widget>[
                                            Image.asset(
                                              '${Environment.iconAssets}pin_location.png',
                                              width: 15.0,
                                              height: 15.0,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10.0),
                                              child: Text(
                                                Dictionary.setLocation,
                                                style: TextStyle(
                                                    color: ColorBase.darkGrey,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        FontsFamily.lato),
                                              ),
                                            ),
                                          ],
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        borderSide: BorderSide(
                                            color: ColorBase.menuBorderColor,
                                            width: 1.5),
                                        onPressed: () async {
                                          await _handleLocation();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              buildTextField(
                                  title: Dictionary.addressDomicile,
                                  controller: _addressController,
                                  maxLines: 2,
                                  hintText: Dictionary.addressPlaceholder,
                                  validation: Validations.addressValidation,
                                  isEdit: true),
                              SizedBox(
                                height: 20,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection(kAreas)
                                      .orderBy('name')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError)
                                      return buildDropdownField(
                                          Dictionary.cityDomicile,
                                          snapshot.error,
                                          [],
                                          _cityController,
                                          false);
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return buildDropdownField(
                                            Dictionary.cityDomicile,
                                            Dictionary.loading,
                                            [],
                                            _cityController,
                                            false);
                                      default:
                                        listCity =
                                            snapshot.data.documents.toList();
                                        return buildDropdownField(
                                            Dictionary.cityDomicile,
                                            Dictionary.cityPlaceholder,
                                            snapshot.data.documents.toList(),
                                            _cityController,
                                            isCityFieldEmpty);
                                    }
                                  }),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          color: ColorBase.limeGreen,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onPressed: () {
                            _onSaveProfileButtonPressed(otpEnabled);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 13),
                            child: Text(
                              Dictionary.save,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
            }),
      ),
    );
  }

  // Function to build Date Picker
  void _showDatePickerBirthday() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(Dictionary.save, style: TextStyle(color: Colors.red)),
        cancel: Text(Dictionary.cancel, style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime: DateTime.parse(minDate),
      maxDateTime: DateTime.now(),
      initialDateTime: _birthDayController.text == ''
          ? DateTime.now()
          : DateTime.parse(_birthDayController.text),
      dateFormat: _format,
      locale: _locale,
      onClose: () {
        setState(() {
          _birthDayController.text = _birthDayController.text;
        });
      },
      onCancel: () {
        setState(() {
          _birthDayController.text = _birthDayController.text;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _birthDayController.text = dateTime.toString();
        });
      },
    );
  }

  // Function to process user input in edit profile
  _onSaveProfileButtonPressed(bool otpEnabled) async {
    // Check empty field
    if (_cityController.text == '') {
      setState(() {
        isCityFieldEmpty = true;
      });
    } else {
      setState(() {
        isCityFieldEmpty = false;
      });
    }
    if (_genderController.text == '') {
      setState(() {
        isGenderEmpty = true;
      });
    } else {
      setState(() {
        isGenderEmpty = false;
      });
    }
    if (_birthDayController.text == '') {
      setState(() {
        isBirthdayEmpty = true;
      });
    } else {
      setState(() {
        isBirthdayEmpty = false;
      });
    }
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      if (isGenderEmpty || isBirthdayEmpty || isCityFieldEmpty) {
        // If the field is empty doing nothing and validator will be shown

      } else if (widget.state.data['phone_number'] ==
          Dictionary.inaCode + _phoneNumberController.text) {
        // If phone number field not change by user it will be save to firebase and skip otp
        _profileBloc.add(Save(
            id: widget.state.data['id'],
            phoneNumber: _phoneNumberController.text,
            gender: _genderController.text,
            address: _addressController.text,
            cityId: _cityController.text,
            provinceId: Dictionary.provinceId,
            name: _nameController.text,
            nik: _nikController.text,
            latLng: latLng,
            birthdate: DateTime.parse(_birthDayController.text)));
      } else {
        // If phone number field changed, check otp enable or disable
        if (otpEnabled) {
          // Otp is enable
          // Check connection
          bool isConnected = await Connection().checkConnection(kUrlGoogle);
          if (isConnected) {
            // Process for auto verification
            verificationCompleted = (AuthCredential credential) async {
              await _profileRepository.linkCredential(
                  widget.state.data['id'],
                  _phoneNumberController.text,
                  _genderController.text,
                  _addressController.text,
                  _cityController.text,
                  Dictionary.provinceId,
                  _nameController.text,
                  _nikController.text,
                  DateTime.parse(_birthDayController.text),
                  credential,
                  latLng);
              // Change state to verified
              _profileBloc.add(VerifyConfirm());
            };
            verificationFailed = (AuthException authException) {
              // Change state to verification failed
              _profileBloc.add(VerifyFailed());
            };
            // Process for sending otp code
            codeSent =
                (String verificationId, [int forceResendingToken]) async {
              // Change state to code successfully sent
              _profileBloc.add(CodeSend(verificationID: verificationId));
            };
            // Execute otp process
            _profileBloc.add(Verify(
                id: widget.state.data['id'],
                phoneNumber: _phoneNumberController.text,
                verificationCompleted: verificationCompleted,
                verificationFailed: verificationFailed,
                codeSent: codeSent));
          }
        } else {
          // Otp is disable
          // Save change directly to firestore
          _profileBloc.add(Save(
              id: widget.state.data['id'],
              phoneNumber: _phoneNumberController.text,
              name: _nameController.text,
              nik: _nikController.text,
              gender: _genderController.text,
              address: _addressController.text,
              cityId: _cityController.text,
              provinceId: Dictionary.provinceId,
              latLng: latLng,
              birthdate: DateTime.parse(_birthDayController.text)));
        }
      }
    }
  }

  // Function to build radio button
  Widget buildRadioButton({String title, List<String> label, bool isEmpty}) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16),
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
                ' (*)',
                style: TextStyle(fontSize: 15.0, color: Colors.red),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          RadioButtonGroup(
            activeColor: ColorBase.limeGreen,
            labelStyle: TextStyle(fontSize: 12, fontFamily: FontsFamily.lato),
            orientation: GroupedButtonsOrientation.HORIZONTAL,
            onSelected: (String selected) => setState(() {
              // Set value to M or F
              _genderController.text = selected.contains('Laki') ? 'M' : 'F';
            }),
            labels: label,
            picked: _genderController.text == 'M'
                ? 'Laki - Laki'
                : _genderController.text == 'F' ? 'Perempuan' : null,
            itemBuilder: (Radio rb, Text txt, int i) {
              return Padding(
                padding: EdgeInsets.only(right: 10),
                child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: ColorBase.menuBorderColor, width: 1.5)),
                    child: Row(
                      children: <Widget>[
                        rb,
                        txt,
                      ],
                    )),
              );
            },
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
      ),
    );
  }

// Funtion to build date field
  Widget buildDateField({String title, placeholder, bool isEmpty}) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
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
                ' (*)',
                style: TextStyle(fontSize: 15.0, color: Colors.red),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              _showDatePickerBirthday();
            },
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: isEmpty ? Colors.red : ColorBase.menuBorderColor,
                      width: 1.5)),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        height: 20,
                        child: Image.asset(
                            '${Environment.iconAssets}calendar.png')),
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
      int maxLines}) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
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
                ' (*)',
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

// Funtion to build dropdown field
  Widget buildDropdownField(String title, String hintText, List items,
      TextEditingController controller, bool isEmpty,
      [validation]) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
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
                ' (*)',
                style: TextStyle(fontSize: 15.0, color: Colors.red),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isEmpty ? Colors.red : ColorBase.menuBorderColor,
                    width: 1.5)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: custom.DropdownButton<dynamic>(
                underline: SizedBox(),
                isExpanded: true,
                hint: Text(
                  hintText,
                  style: TextStyle(
                      color: ColorBase.darkGrey,
                      fontFamily: FontsFamily.lato,
                      fontSize: 12),
                ),
                items: items.map((item) {
                  return custom.DropdownMenuItem(
                    child: Text(
                      item['name'],
                      style:
                          TextStyle(fontFamily: FontsFamily.lato, fontSize: 12),
                    ),
                    value: item['code'].toString(),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    controller.text = value;
                  });
                },
                value: controller.text == '' ? null : controller.text,
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
      ),
    );
  }

// Function to build phone field
  Widget buildPhoneField(
      {String title,
      TextEditingController controller,
      String hintText,
      validation,
      TextInputType textInputType,
      TextStyle textStyle,
      bool isEdit}) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
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
                ' (*)',
                style: TextStyle(fontSize: 15.0, color: Colors.red),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 55,
                width: MediaQuery.of(context).size.width / 7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: ColorBase.menuBorderColor, width: 1.5)),
                child: Center(
                    child: Text(
                  Dictionary.inaCode,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: FontsFamily.lato,
                      color: ColorBase.darkGrey),
                )),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextFormField(
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
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                          color: ColorBase.darkGrey,
                          fontFamily: FontsFamily.lato,
                          fontSize: 12),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.red, width: 1.5)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: ColorBase.menuBorderColor, width: 1.5)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: ColorBase.menuBorderColor, width: 1)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: ColorBase.menuBorderColor, width: 2))),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Function to call remote config
  Future<RemoteConfig> setupRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    remoteConfig.setDefaults(<String, dynamic>{
      FirebaseConfig.otpEnabled: false,
    });

    try {
      await remoteConfig.fetch(expiration: Duration(minutes: 5));
      await remoteConfig.activateFetched();
    } catch (exception) {}

    return remoteConfig;
  }

  // Function to get location user
  Future<void> _handleLocation() async {
    //Checking permission status
    var permissionService =
        Platform.isIOS ? Permission.locationWhenInUse : Permission.location;

    if (await permissionService.status.isGranted) {
      // Permission allowed
      await _openLocationPicker();
    } else {
      // Permission disallowed
      // Show dialog to ask permission
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogRequestPermission(
                image: Image.asset(
                  '${Environment.iconAssets}map_pin.png',
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                description: Dictionary.permissionLocationSpread,
                onOkPressed: () async {
                  Navigator.of(context).pop();
                  if (await permissionService.status.isDenied) {
                    await AppSettings.openLocationSettings();
                  } else {
                    permissionService.request().then((status) {
                      _onStatusRequested(context, status);
                    });
                  }
                },
                onCancelPressed: () {
                  AnalyticsHelper.setLogEvent(
                      Analytics.permissionDismissLocation);
                  Navigator.of(context).pop();
                },
              ));
    }
  }

  // Function to get lat long user, auto complete address field and auto complete city field
  Future<void> _openLocationPicker() async {
    latLng = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LocationPicker()));
    final String address = await GeocoderRepository().getAddress(latLng);
    String city = await GeocoderRepository().getCity(latLng);
    var tempCity;

    /// Checking city contains kab
    if (city.toLowerCase().contains('kab')) {
      /// Replace Kabupaten or Kabupatén to kab.
      setState(() {
        city = city.replaceAll('Kabupaten', 'kab.');
        city = city.replaceAll('Kabupatén', 'kab.');
      });
    }

    /// Checking city contains regency
    if (city.toLowerCase().contains('regency')) {
      /// Add kab. and delete Regency string.
      setState(() {
        city = city.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
        city = 'kab. ' + city.replaceAll('Regency', '');
      });
    }
    for (var i = 0; i < listCity.length; i++) {
      /// Checking same name of [city] in [listCity]
      if (listCity[i]['name'].toLowerCase().contains(city.toLowerCase())) {
        setState(() {
          tempCity = listCity[i];
        });
      }
    }
    if (address != null) {
      setState(() {
        _addressController.text = address;
      });
      if (tempCity != null) {
        setState(() {
          _cityController.text = tempCity['code'];
        });
      } else {
        _cityController.text = '';
      }
    }
  }

  // Function to get status for access location
  void _onStatusRequested(
      BuildContext context, PermissionStatus statuses) async {
    if (statuses.isGranted) {
      _openLocationPicker();
      AnalyticsHelper.setLogEvent(Analytics.permissionGrantedLocation);
    } else {
      AnalyticsHelper.setLogEvent(Analytics.permissionDeniedLocation);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _genderController.dispose();
    _birthDayController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _nikController.dispose();

    _profileBloc.close();

    super.dispose();
  }
}


