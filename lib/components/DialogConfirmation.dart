import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';

class DialogConfirmation extends StatelessWidget {
  final String title, body, buttonOkText, buttonCancelText;
  final GestureTapCallback onOkPressed;

  DialogConfirmation(
      {Key key,
      this.title,
      @required this.body,
      this.buttonOkText,
      this.buttonCancelText,
      @required this.onOkPressed})
      : super(key: key);

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
    return Container(
      padding: EdgeInsets.all(Dimens.padding),
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            CrossAxisAlignment.start, // To make the card compact
        children: <Widget>[
          title != null
              ? Text(
                  title,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              : Container(),
          SizedBox(height: 10.0),
          body != null
              ? Text(
                  body,
                  style: TextStyle(fontSize: 14.0, color: Colors.black),
                )
              : Container(),
          SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                elevation: 0.0,
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Colors.blue)),
                onPressed: onOkPressed,
                child: Text(
                  buttonOkText != null ? buttonOkText : Dictionary.ok,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              RaisedButton(
                elevation: 0.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Colors.grey[700])),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  buttonCancelText != null
                      ? buttonCancelText
                      : Dictionary.cancel,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
