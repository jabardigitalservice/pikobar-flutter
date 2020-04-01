import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pinput/pin_put/pin_put.dart';

class Verification extends StatefulWidget {
  final String phoneNumber, uid, verificationID;
  Verification({this.phoneNumber, this.uid, this.verificationID});
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  String verificationID, smsCode;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    print(widget.phoneNumber);
    print(widget.uid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: CustomAppBar.defaultAppBar(title: Dictionary.verification),
      body: Padding(
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
                              top: 30.0, bottom: 15.0, left: 20.0, right: 20.0),
                          child: Image.asset(
                              '${Environment.iconAssets}phone_otp.png')),
                      Container(
                        padding: EdgeInsets.only(
                            top: 5.0, bottom: 2.0, left: 20.0, right: 20.0),
                        child: Text(Dictionary.otpHasBeenSent,
                            style: TextStyle(
                              color: Color(0xff828282),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Text(Dictionary.inaCode + widget.phoneNumber,
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
                            top: 5.0, bottom: 2.0, left: 20.0, right: 20.0),
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
                                    borderSide:
                                        BorderSide(color: Color(0xffF2F2F2)),
                                    borderRadius: BorderRadius.circular(8)),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xffF2F2F2)),
                                    borderRadius: BorderRadius.circular(8)),
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
                            top: 5.0, bottom: 2.0, left: 20.0, right: 20.0),
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
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onVerifyButtonPressed() {
    _scaffoldState.currentState.showSnackBar(
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
    signInWithPhoneNumber(smsCode).then((FirebaseUser user) async {
      await Firestore.instance
          .collection(Collections.users)
          .document(widget.uid)
          .updateData(
              {'phone_number': Dictionary.inaCode + widget.phoneNumber});
      _scaffoldState.currentState.hideCurrentSnackBar();

      showDialog(
          context: context,
          builder: (BuildContext context) => DialogTextOnly(
                description: Dictionary.codeVerified,
                buttonText: Dictionary.ok,
                onOkPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // To close the dialog
                },
              ));
    }).catchError((e) => showDialog(
        context: context,
        builder: (BuildContext context) => DialogTextOnly(
              description: e.toString().contains('is invalid')
                  ? Dictionary.codeWrong
                  : e.toString(),
              buttonText: Dictionary.ok,
              onOkPressed: () {
                _scaffoldState.currentState.hideCurrentSnackBar();

                Navigator.of(context).pop(); // To close the dialog
              },
            )));
  }

  Future<void> sendCodeToPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential credential) {
      _scaffoldState.currentState.hideCurrentSnackBar();
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogTextOnly(
                description: Dictionary.codeVerified,
                buttonText: Dictionary.ok,
                onOkPressed: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  final FirebaseUser user =
                      await FirebaseAuth.instance.currentUser();
                  List<UserInfo> providerList = user.providerData;
                  if (providerList.length > 2) {
                    await user.unlinkFromProvider(credential.providerId);
                  }
                  await user.linkWithCredential(credential);
                  await Firestore.instance
                      .collection('users')
                      .document(widget.uid)
                      .updateData({
                    'phone_number': Dictionary.inaCode + widget.phoneNumber,
                  });
                },
              ));
      
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      _scaffoldState.currentState.hideCurrentSnackBar();

      showDialog(
          context: context,
          builder: (BuildContext context) => DialogTextOnly(
                description: Dictionary.codeSendFailed,
                buttonText: Dictionary.ok,
                onOkPressed: () {
                  Navigator.of(context).pop(); // To close the dialog
                },
              ));
      
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationID = verificationId;
      _scaffoldState.currentState.hideCurrentSnackBar();

      showDialog(
          context: context,
          builder: (BuildContext context) => DialogTextOnly(
                description: Dictionary.codeSend + widget.phoneNumber,
                buttonText: Dictionary.ok,
                onOkPressed: () async {
                  Navigator.of(context).pop(); // To close the dialog
                },
              ));
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationID = verificationId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: Dictionary.inaCode + widget.phoneNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<FirebaseUser> signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId:
          verificationID == null ? widget.verificationID : verificationID,
      smsCode: smsCode,
    );
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    List<UserInfo> providerList = user.providerData;

    if (providerList.length > 2) {
      await user.unlinkFromProvider(credential.providerId);
    }
    await user.linkWithCredential(credential);

    return user;
  }
}
