import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr/qr.dart';

class DialogQrCode extends StatefulWidget {
  final String idUser;

  const DialogQrCode({Key key, @required this.idUser}) : super(key: key);

  @override
  _DialogQrCodeState createState() => _DialogQrCodeState();
}

class _DialogQrCodeState extends State<DialogQrCode> {
  @override
  Widget build(BuildContext context) {
    return _dialogContent(context);
  }

  _dialogContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // To make the card compact
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
          Text(
            Dictionary.qrCode,
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: ColorBase.grey800,
                fontFamily: FontsFamily.lato),
          ),
          SizedBox(height: 10),
          Text(
            Dictionary.qrCodeDesc,
            style: TextStyle(
                fontSize: 12.0,
                color: ColorBase.grey800,
                fontFamily: FontsFamily.roboto),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 25),
          Center(
            child: PrettyQr(
              image: AssetImage('${Environment.iconAssets}pikobar.png'),
              typeNumber: 3,
              size: 200,
              data: widget.idUser,
              errorCorrectLevel: QrErrorCorrectLevel.M,
              roundEdges: true,
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: ColorBase.limeGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 13),
                  child: Text(
                    Dictionary.done,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
