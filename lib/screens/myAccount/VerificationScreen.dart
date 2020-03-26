import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/models/UserModel.dart';
import 'package:pinput/pin_put/pin_put.dart';

class Verification extends StatefulWidget {
  final String phoneNumber, uid;
  Verification({this.phoneNumber, this.uid});
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
      appBar: AppBar(
        title: Text(Dictionary.verification),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    top: 30.0, bottom: 15.0, left: 20.0, right: 20.0),
                child: Icon(
                  Icons.phone_android,
//                        child: Icon(Icons.phone_android,
                  size: 50.0,
//                          color: UIData.mainColor,
                  color: Colors.teal,
                ),
              ),
              Container(
                child: Text("Input verification code",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: 5.0, bottom: 2.0, left: 20.0, right: 20.0),
                child: Text("Verification code has been sent via SMS :",
                    style: TextStyle(
                      color: Colors.black,
                    )),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 30.0, left: 20.0, right: 20.0),
                child: Text(Dictionary.inaCode + widget.phoneNumber,
                    style: TextStyle(
                      color: Colors.black,
                    )),
              ),
              Container(
                width: 250.0,
                padding: EdgeInsets.only(top: 0.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    PinPut(
//                            SMS : smsListener,
//                            clearButtonIcon: Icon(Icons.clear),
                        inputDecoration: InputDecoration(
                            border: UnderlineInputBorder(), counterText: ''),
                        onClear: (value) {},
                        actionButtonsEnabled: true,
                        fieldsCount: 6,
                        keyboardAction: TextInputAction.go,
//                                 onSubmit: (String pin) => _showSnackBar(pin, context),
                        onSubmit: (String pin) {
                          setState(() {
                            smsCode = pin;
                          });
                          signInWithPhoneNumber(smsCode);
                        }),
                    SizedBox(height: 60.0),
                  ],
                ),
              ),
              SizedBox(height: 50.0),
              Container(
                padding: EdgeInsets.only(
                    top: 5.0, bottom: 2.0, left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Dont receive verification ?",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    SizedBox(width: 6.0),
                    InkWell(
                      onTap: () {
                        sendCodeToPhoneNumber();
                      },
                      child: Text('Send again',
                          style: TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> sendCodeToPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential user) {
      _scaffoldState.currentState.hideCurrentSnackBar();

      showDialog(
          context: context,
          builder: (BuildContext context) => DialogTextOnly(
                description: 'Nomor telepon telah tersimpan',
                buttonText: "OK",
                onOkPressed: () {
                  Navigator.of(context).pop(); // To close the dialog
                },
              ));
      setState(() {
        print(
            'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $user');
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      _scaffoldState.currentState.hideCurrentSnackBar();

      showDialog(
          context: context,
          builder: (BuildContext context) => DialogTextOnly(
                description: 'Nomor telepon salah silahkan cek kembali',
                buttonText: "OK",
                onOkPressed: () {
                  Navigator.of(context).pop(); // To close the dialog
                },
              ));
      setState(() {
        print(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationID = verificationId;
      _scaffoldState.currentState.hideCurrentSnackBar();

      showDialog(
          context: context,
          builder: (BuildContext context) => DialogTextOnly(
                description: "Kode terkirim ke nomor " + widget.phoneNumber,
                buttonText: "OK",
                onOkPressed: () async {
                  Navigator.of(context).pop(); // To close the dialog
                },
              ));
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationID = verificationId;
      _scaffoldState.currentState.hideCurrentSnackBar();

      showDialog(
          context: context,
          builder: (BuildContext context) => DialogTextOnly(
                description: "Waktu habis silahkan coba lagi",
                buttonText: "OK",
                onOkPressed: () {
                  Navigator.of(context).pop(); // To close the dialog
                },
              ));
      print("time out");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: Dictionary.inaCode + widget.phoneNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  Future<UserModel> signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationID,
      smsCode: smsCode,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();

    assert(user.uid == currentUser.uid);

    await Firestore.instance
        .collection('users')
        .document(widget.uid)
        .updateData({'phone_number': Dictionary.inaCode + widget.phoneNumber});
    return UserModel(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        photoUrlFull: currentUser.photoUrl,
        phoneNumber: currentUser.phoneNumber);
  }
}
