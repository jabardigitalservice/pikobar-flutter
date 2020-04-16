import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/profile/Bloc.dart';
import 'package:pikobar_flutter/blocs/profile/ProfileState.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/repositories/ProfileRepository.dart';
import 'package:pinput/pin_put/pin_put.dart';

class Verification extends StatefulWidget {
  final String phoneNumber,
      uid,
      verificationID,
      gender,
      address,
      cityId,
      provinceId,
      name,
      nik;
  final DateTime birthdate;
  Verification(
      {this.phoneNumber,
      this.uid,
      this.verificationID,
      this.gender,
      this.address,
      this.cityId,
      this.provinceId,
      this.name,
      this.nik,
      this.birthdate});
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  String verificationID, smsCode;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProfileRepository _profileRepository = ProfileRepository();
  ProfileBloc _profileBloc;
  PhoneVerificationCompleted verificationCompleted;
  PhoneVerificationFailed verificationFailed;
  PhoneCodeSent codeSent;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldState,
        appBar: CustomAppBar.defaultAppBar(title: Dictionary.verification),
        body: BlocProvider<ProfileBloc>(
            create: (BuildContext context) => _profileBloc =
                ProfileBloc(profileRepository: _profileRepository),
            child: BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileFailure) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => DialogTextOnly(
                            description: state.error
                                    .toString()
                                    .contains('ERROR_INVALID_VERIFICATION_CODE')
                                ? Dictionary.codeWrong
                                : state.error.toString(),
                            buttonText: Dictionary.ok,
                            onOkPressed: () {
                              Navigator.of(context)
                                  .pop(); // To close the dialog
                            },
                          ));
                  Scaffold.of(context).hideCurrentSnackBar();
                } else if (state is ProfileWaiting) {
                } else if (state is ProfileVerified) {
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
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => DialogTextOnly(
                            description: Dictionary.codeSend +
                                Dictionary.inaCode +
                                widget.phoneNumber,
                            buttonText: Dictionary.ok,
                            onOkPressed: () {
                              Navigator.of(context).pop();
                            },
                          ));
                  Scaffold.of(context).hideCurrentSnackBar();
                } else if (state is ProfileVerifiedFailed) {
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
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(
                                      top: 30.0,
                                      bottom: 15.0,
                                      left: 20.0,
                                      right: 20.0),
                                  child: Image.asset(
                                      '${Environment.iconAssets}phone_otp.png')),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5.0,
                                    bottom: 2.0,
                                    left: 20.0,
                                    right: 20.0),
                                child: Text(Dictionary.otpHasBeenSent,
                                    style: TextStyle(
                                      color: Color(0xff828282),
                                    )),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Text(
                                    Dictionary.inaCode + widget.phoneNumber,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xff4F4F4F),
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5.0,
                                    bottom: 2.0,
                                    left: 20.0,
                                    right: 20.0),
                                child: Text(Dictionary.inputOTP,
                                    style: TextStyle(
                                      color: Color(0xff828282),
                                    )),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Container(
                                height: 70,
                                child: PinPut(
                                    textStyle: TextStyle(fontSize: 20),
                                    clearButtonIcon: Icon(Icons.backspace),
                                    inputDecoration: InputDecoration(
                                        hintText: '-',
                                        fillColor: Color(0xffF2F2F2),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffF2F2F2)),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffF2F2F2)),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        counterText: ''),
                                    onClear: (value) {},
                                    actionButtonsEnabled: true,
                                    fieldsCount: 6,
                                    keyboardAction: TextInputAction.go,
                                    onSubmit: (String pin) {
                                      setState(() {
                                        smsCode = pin;
                                      });
                                    }),
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5.0,
                                    bottom: 2.0,
                                    left: 20.0,
                                    right: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(Dictionary.otpNotSent,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        )),
                                    SizedBox(height: 10.0),
                                    InkWell(
                                      onTap: () {
                                        sendCodeToPhoneNumber();
                                      },
                                      child: Text(Dictionary.sendAgainOTP,
                                          style: TextStyle(
                                            color: Color(0xff2D9CDB),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: RaisedButton(
                        color: Color(0xff27AE60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        onPressed: onVerifyButtonPressed,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 13),
                          child: Text(
                            Dictionary.verification,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  onVerifyButtonPressed() {
    _profileBloc.add(ConfirmOTP(
      smsCode: smsCode,
      verificationID:
          verificationID == null ? widget.verificationID : verificationID,
      id: widget.uid,
      phoneNumber: widget.phoneNumber,
      address: widget.address,
      birthdate: widget.birthdate,
      cityId: widget.cityId,
      gender: widget.gender,
      provinceId: widget.provinceId,
    ));
  }

  Future<void> sendCodeToPhoneNumber() async {
    verificationCompleted = (AuthCredential credential) async {
      await _profileRepository.linkCredential(
          widget.uid,
          widget.phoneNumber,
          widget.gender,
          widget.address,
          widget.cityId,
          widget.provinceId,
          widget.name,
          widget.nik,
          widget.birthdate,
          credential);
      _profileBloc.add(VerifyConfirm());
    };
    verificationFailed = (AuthException authException) {
      _profileBloc.add(VerifyFailed());
    };

    codeSent = (String verificationId, [int forceResendingToken]) async {
      setState(() {
        verificationID = verificationId;
      });
      _profileBloc.add(CodeSend(verificationID: verificationId));
    };
    _profileBloc.add(Verify(
        id: widget.uid,
        phoneNumber: widget.phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent));
  }
}
