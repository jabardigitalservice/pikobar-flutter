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
import 'package:pikobar_flutter/blocs/area/cityListBloc/Bloc.dart';
import 'package:pikobar_flutter/blocs/profile/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
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
import 'package:pikobar_flutter/utilities/FirestoreHelper.dart';
import 'package:pikobar_flutter/utilities/Validations.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:pikobar_flutter/components/custom_dropdown.dart' as custom;
import 'package:flutter_masked_text/flutter_masked_text.dart';

class Edit extends StatefulWidget {
  final DocumentSnapshot state;

  Edit({Key key, this.state}) : super(key: key);

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
  String _format = 'dd-MMMM-yyyy';
  String minDate = '1900-01-01';
  DateTimePickerLocale _locale = DateTimePickerLocale.id;
  bool otpEnabled;
  bool isCityFieldEmpty = false;
  bool isBirthdayEmpty = false;
  bool isGenderEmpty = false;
  LatLng latLng;
  List<dynamic> listCity;
  ScrollController _scrollController;

  @override
  void initState() {
    AnalyticsHelper.setLogEvent(Analytics.tappedEditProfile);
    _nameController.text = getField(widget.state, 'name');
    _emailController.text = getField(widget.state, 'email');
    _phoneNumberController.text = getField(widget.state, 'phone_number') != null
        ? '0' + widget.state['phone_number'].toString().substring(3)
        : null;
    _addressController.text = getField(widget.state, 'address');
    _birthDayController.text = getField(widget.state, 'birthdate') == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(
                widget.state['birthdate'].seconds * 1000)
            .toString();
    _genderController.text = getField(widget.state, 'gender');
    _cityController.text = getField(widget.state, 'city_id');
    _nikController.text = getField(widget.state, 'nik');
    latLng = getField(widget.state, 'location') == null
        ? null
        : new LatLng(widget.state['location'].latitude,
            widget.state['location'].longitude);
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    super.initState();
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.5);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldState,
          appBar: CustomAppBar.animatedAppBar(
              showTitle: _showTitle, title: Dictionary.edit),
          body: FutureBuilder<RemoteConfig>(
              future: setupRemoteConfig(),
              builder:
                  (BuildContext context, AsyncSnapshot<RemoteConfig> snapshot) {
                otpEnabled = snapshot.data != null &&
                        snapshot.data.getBool(FirebaseConfig.otpEnabled) != null
                    ? snapshot.data.getBool(FirebaseConfig.otpEnabled)
                    : false;
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<ProfileBloc>(
                        create: (BuildContext context) => _profileBloc =
                            ProfileBloc(profileRepository: _profileRepository)),
                    BlocProvider<CityListBloc>(
                        create: (context) =>
                            CityListBloc()..add(CityListLoad())),
                  ],
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
                                      _phoneNumberController.text.substring(1),
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
                                                    _phoneNumberController.text
                                                        .substring(1),
                                                uid: widget.state['id'],
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
                                  margin: const EdgeInsets.only(left: 15.0),
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
                      controller: _scrollController,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: Dimens.contentPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AnimatedOpacity(
                                opacity: _showTitle ? 0.0 : 1.0,
                                duration: const Duration(milliseconds: 250),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: Text(
                                    Dictionary.edit,
                                    style: TextStyle(
                                        fontFamily: FontsFamily.lato,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              buildTextField(
                                  title: Dictionary.name,
                                  hintText: Dictionary.placeholderYourName,
                                  controller: _nameController,
                                  validation: Validations.nameValidation,
                                  isEdit: true),
                              const SizedBox(
                                height: 20,
                              ),
                              buildTextField(
                                  title: Dictionary.email,
                                  controller: _emailController,
                                  isEdit: false),
                              const SizedBox(
                                height: 20,
                              ),
                              buildTextField(
                                  title: Dictionary.nik,
                                  controller: _nikController,
                                  textInputType: TextInputType.number,
                                  hintText: Dictionary.placeholderYourNIK,
                                  validation: Validations.nikValidation,
                                  isEdit: true),
                              const SizedBox(
                                height: 20,
                              ),
                              buildPhoneField(
                                  title: Dictionary.telephoneNumber,
                                  controller: _phoneNumberController,
                                  validation: Validations.telephoneValidation,
                                  isEdit: true,
                                  hintText: Dictionary.phoneNumberPlaceholder),
                              const SizedBox(
                                height: 20,
                              ),
                              buildRadioButton(
                                  title: Dictionary.gender,
                                  label: <String>[
                                    "Laki - Laki",
                                    "Perempuan",
                                  ],
                                  isEmpty: isGenderEmpty),
                              const SizedBox(
                                height: 20,
                              ),
                              buildDateField(
                                  title: Dictionary.birthday,
                                  placeholder: _birthDayController.text == ''
                                      ? Dictionary.chooseDatePlaceholder
                                      : DateFormat.yMMMMd('id').format(
                                          DateTime.parse(_birthDayController
                                              .text
                                              .substring(0, 10))),
                                  isEmpty: isBirthdayEmpty),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        Dictionary.locationAddress,
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            color: ColorBase.veryDarkGrey,
                                            fontFamily: FontsFamily.roboto,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ButtonTheme(
                                    minWidth: MediaQuery.of(context).size.width,
                                    height: 45.0,
                                    child: RaisedButton(
                                      elevation: 0,
                                      color: ColorBase.greyContainer,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            Dictionary.setLocation,
                                            style: TextStyle(
                                                color: ColorBase.netralGrey,
                                                fontSize: 14,
                                                fontFamily: FontsFamily.roboto),
                                          ),
                                          Image.asset(
                                            '${Environment.iconAssets}pin_location.png',
                                            width: 15.0,
                                            height: 15.0,
                                          ),
                                        ],
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: ColorBase.greyBorder,
                                            width: 1.5),
                                      ),
                                      onPressed: () async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        await _handleLocation();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              buildTextField(
                                  title: Dictionary.addressDomicile,
                                  controller: _addressController,
                                  maxLines: 2,
                                  hintText: Dictionary.addressPlaceholder,
                                  validation: Validations.addressValidation,
                                  isEdit: true),
                              const SizedBox(
                                height: 20,
                              ),
                              BlocBuilder<CityListBloc, CityListState>(builder:
                                  (BuildContext context, CityListState state) {
                                if (state is CityListLoaded) {
                                  listCity = state.cityList;
                                  return buildDropdownField(
                                      Dictionary.cityDomicile,
                                      Dictionary.cityPlaceholder,
                                      listCity,
                                      _cityController,
                                      isCityFieldEmpty);
                                }
                                return buildDropdownField(
                                    Dictionary.cityDomicile,
                                    Dictionary.loading,
                                    [],
                                    _cityController,
                                    false);
                              }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.contentPadding, vertical: 10),
                          child: RaisedButton(
                            color: isEmptyField()
                                ? ColorBase.disableText
                                : ColorBase.limeGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            onPressed: () {
                              checkEmptyField();
                              if (_formKey.currentState.validate()) {
                                FocusScope.of(context).unfocus();
                                if (!isGenderEmpty &&
                                    !isBirthdayEmpty &&
                                    !isCityFieldEmpty) {
                                  if (widget.state['phone_number']
                                          .toString()
                                          .substring(3) !=
                                      _phoneNumberController.text
                                          .substring(1)) {
                                    final Future<QuerySnapshot> data =
                                        FirebaseFirestore.instance
                                            .collection(kUsers)
                                            .where("phone_number",
                                                isEqualTo: Dictionary.inaCode +
                                                    _phoneNumberController.text
                                                        .substring(1))
                                            .get();

                                    data.then((docs) {
                                      if (docs.docs.isNotEmpty) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                DialogTextOnly(
                                                  description: Dictionary
                                                      .phoneNumberHasBeenUsed,
                                                  buttonText: Dictionary.ok,
                                                  onOkPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // To close the dialog
                                                  },
                                                ));
                                      } else {
                                        _onSaveProfileButtonPressed(otpEnabled);
                                      }
                                    });
                                  } else {
                                    _onSaveProfileButtonPressed(otpEnabled);
                                  }
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              child: Text(
                                Dictionary.save,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
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

  bool isEmptyField() {
    return _nameController.text.isEmpty ||
        _nikController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _birthDayController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _cityController.text.isEmpty;
  }

  checkEmptyField() {
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
  }

  // Function to process user input in edit profile
  _onSaveProfileButtonPressed(bool otpEnabled) async {
    if (widget.state['phone_number'] ==
        Dictionary.inaCode + _phoneNumberController.text.substring(1)) {
      // If phone number field not change by user it will be save to firebase and skip otp
      _profileBloc.add(Save(
          id: widget.state['id'],
          phoneNumber: _phoneNumberController.text.substring(1),
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
        final bool isConnected = await Connection().checkConnection(kUrlGoogle);
        if (isConnected) {
          // Process for auto verification
          verificationCompleted = (AuthCredential credential) async {
            await _profileRepository.linkCredential(
                widget.state['id'],
                _phoneNumberController.text.substring(1),
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
          verificationFailed = (FirebaseAuthException authException) {
            // Change state to verification failed
            _profileBloc.add(VerifyFailed());
          };
          // Process for sending otp code
          codeSent = (String verificationId, [int forceResendingToken]) async {
            // Change state to code successfully sent
            _profileBloc.add(CodeSend(verificationID: verificationId));
          };
          // Execute otp process
          _profileBloc.add(Verify(
              id: widget.state['id'],
              phoneNumber: _phoneNumberController.text.substring(1),
              verificationCompleted: verificationCompleted,
              verificationFailed: verificationFailed,
              codeSent: codeSent));
        }
      } else {
        // Otp is disable
        // Save change directly to firestore
        _profileBloc.add(Save(
            id: widget.state['id'],
            phoneNumber: _phoneNumberController.text.substring(1),
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

  // Function to build radio button
  Widget buildRadioButton({String title, List<String> label, bool isEmpty}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontSize: 12.0,
                  color: ColorBase.veryDarkGrey,
                  fontFamily: FontsFamily.roboto,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              Dictionary.requiredForm,
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.green,
                  fontFamily: FontsFamily.roboto,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        RadioButtonGroup(
          activeColor: ColorBase.limeGreen,
          labelStyle: TextStyle(fontSize: 14, fontFamily: FontsFamily.roboto),
          orientation: GroupedButtonsOrientation.VERTICAL,
          onSelected: (String selected) => setState(() {
            FocusScope.of(context).requestFocus(FocusNode());
            // Set value to M or F
            _genderController.text = selected.contains('Laki') ? 'M' : 'F';
          }),
          labels: label,
          picked: _genderController.text == 'M'
              ? 'Laki - Laki'
              : _genderController.text == 'F'
                  ? 'Perempuan'
                  : null,
          itemBuilder: (Radio rb, Text txt, int i) {
            return Row(
              children: <Widget>[
                rb,
                txt,
              ],
            );
          },
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

// Funtion to build date field
  Widget buildDateField({String title, placeholder, bool isEmpty}) {
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
                    fontFamily: FontsFamily.roboto,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                Dictionary.requiredForm,
                style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.green,
                    fontFamily: FontsFamily.roboto,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _showDatePickerBirthday();
            },
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: ColorBase.greyContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: isEmpty ? Colors.red : ColorBase.greyBorder,
                      width: 1.5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      placeholder,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: FontsFamily.roboto,
                          color: placeholder == Dictionary.chooseDatePlaceholder
                              ? ColorBase.netralGrey
                              : Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        height: 15,
                        child: Image.asset(
                            '${Environment.iconAssets}calendar.png')),
                  )
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
                    fontFamily: FontsFamily.roboto,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                Dictionary.requiredForm,
                style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.green,
                    fontFamily: FontsFamily.roboto,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLines: maxLines != null ? maxLines : 1,
            style: isEdit
                ? TextStyle(
                    color: Colors.black,
                    fontFamily: FontsFamily.roboto,
                    fontSize: 14)
                : TextStyle(
                    color: ColorBase.disableText,
                    fontFamily: FontsFamily.roboto,
                    fontSize: 14),
            enabled: isEdit,
            validator: validation,
            textCapitalization: TextCapitalization.words,
            controller: controller,
            decoration: InputDecoration(
                fillColor: ColorBase.greyContainer,
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(
                    color: ColorBase.netralGrey,
                    fontFamily: FontsFamily.roboto,
                    fontSize: 12),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.red, width: 1.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: ColorBase.greyBorder, width: 1.5)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: ColorBase.greyBorder, width: 1.5)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: ColorBase.greyBorder, width: 1.5))),
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
                    fontFamily: FontsFamily.roboto,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                Dictionary.requiredForm,
                style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.green,
                    fontFamily: FontsFamily.roboto,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ColorBase.greyContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isEmpty ? Colors.red : ColorBase.greyBorder,
                    width: 1.5)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: custom.DropdownButton<dynamic>(
                underline: SizedBox(),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: ColorBase.netralGrey,
                  size: 30,
                ),
                isExpanded: true,
                hint: Text(
                  hintText,
                  style: TextStyle(
                      color: ColorBase.netralGrey,
                      fontFamily: FontsFamily.roboto,
                      fontSize: 14),
                ),
                items: items.map((item) {
                  return custom.DropdownMenuItem(
                    child: Text(
                      item['name'],
                      style: TextStyle(
                        fontFamily: FontsFamily.roboto,
                        fontSize: 14,
                      ),
                    ),
                    value: item['code'].toString(),
                  );
                }).toList(),
                onChanged: (value) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    controller.text = value;
                  });
                },
                value: controller.text == '' ? null : controller.text,
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
                    fontFamily: FontsFamily.roboto,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                Dictionary.requiredForm,
                style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.green,
                    fontFamily: FontsFamily.roboto,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            style: isEdit
                ? TextStyle(
                    color: Colors.black,
                    fontFamily: FontsFamily.roboto,
                    fontSize: 14)
                : TextStyle(
                    color: ColorBase.disableText,
                    fontFamily: FontsFamily.roboto,
                    fontSize: 14),
            enabled: isEdit,
            validator: validation,
            controller: controller,
            decoration: InputDecoration(
                hintText: hintText,
                filled: true,
                fillColor: ColorBase.greyContainer,
                hintStyle: TextStyle(
                    color: ColorBase.netralGrey,
                    fontFamily: FontsFamily.roboto,
                    fontSize: 12),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.red, width: 1.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: ColorBase.greyBorder, width: 1.5)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: ColorBase.greyBorder, width: 1)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: ColorBase.greyBorder, width: 2))),
            keyboardType: TextInputType.number,
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
                  if (await permissionService.status.isPermanentlyDenied) {
                    Platform.isAndroid
                        ? await AppSettings.openAppSettings()
                        : await AppSettings.openLocationSettings();
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
      if (city.isNotEmpty &&
          listCity[i]['name'].toLowerCase().contains(city.toLowerCase())) {
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
