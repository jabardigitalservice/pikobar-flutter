import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
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
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              'QR Code',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25),
            PrettyQr(
              image: AssetImage('${Environment.iconAssets}pikobar.png'),
              typeNumber: 3,
              size: 200,
              data: widget.idUser,
              errorCorrectLevel: QrErrorCorrectLevel.M,
              roundEdges: true,
            ),
            SizedBox(height: 25),
            Text(
              'Pindai QR Code diatas untuk melakukan validasi',
              style: TextStyle(fontSize: 15.0, color: Color(0xFF828282)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
