import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';

class DialogRequestPermission extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;
  final Icon icon;
  final GestureTapCallback onOkPressed;

  DialogRequestPermission(
      {this.title,
      @required this.description,
      this.buttonText,
      this.image,
      this.icon,
      @required this.onOkPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  _dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        //bottom card part,
        _bottomCard(context),

        //top circular image part,
        _circularImage(),
      ],
    );
  }

  _bottomCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: Dimens.avatarRadius + Dimens.padding,
        bottom: Dimens.padding,
        left: Dimens.padding,
        right: Dimens.padding,
      ),
      margin: EdgeInsets.only(top: Dimens.avatarRadius),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Dimens.padding),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Text(
            description,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(); // To close the dialog
                },
                child: Text(
                  Dictionary.later.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
              FlatButton(
                onPressed: onOkPressed,
                child: Text(
                  Dictionary.next.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _circularImage() {
    return Positioned(
      left: Dimens.padding,
      right: Dimens.padding,
      child: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          radius: Dimens.avatarRadius,
          child: Container(
              width: 50.0, height: 50.0, child: image != null ? image : icon)),
    );
  }
}
