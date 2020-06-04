import 'package:flutter/material.dart';
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
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.dialogRadius)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  _dialogContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Dimens.dialogRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              'QR Code',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontsFamily.lato),
            ),
            SizedBox(height: 10),
            Text(
              'Pindai QR Code di bawah untuk melakukan validasi',
              style: TextStyle(
                  fontSize: 12.0,
                  color: Color(0xff333333),
                  fontFamily: FontsFamily.lato),
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
            SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xff333333),
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
