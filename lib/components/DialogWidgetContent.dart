import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';

class DialogWidgetContent extends StatelessWidget {
  final String title, buttonText;
  final Widget child;
  final GestureTapCallback onOkPressed;
  final bool flatButton;

  DialogWidgetContent(
      {Key key,
      this.title,
      @required this.child,
      @required this.buttonText,
      this.flatButton = true,
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
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          title != null
              ? Text(
                  title,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                )
              : Container(),
          SizedBox(height: 16.0),
          child,
          SizedBox(height: 24.0),
          flatButton
              ? FlatButton(
                  onPressed: onOkPressed,
                  child: Text(
                    buttonText,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                      onPressed: onOkPressed,
                      color: ColorBase.blue,
                      child: Text(
                        buttonText,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                ),
        ],
      ),
    );
  }
}
