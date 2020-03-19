import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/utilities/launchExternal.dart';

class DialogUpdateApp extends StatefulWidget {
  final linkUpdate;

  DialogUpdateApp({this.linkUpdate});

  @override
  _DialogUpdateAppState createState() => _DialogUpdateAppState();
}

class _DialogUpdateAppState extends State<DialogUpdateApp> {
  @override
  void initState() {
    super.initState();
  }

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
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 170.0,
                decoration: BoxDecoration(
                    color: ColorBase.green,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Dimens.dialogRadius))),
              ),
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 30.0),
                  child: Image.asset(
                    '${Environment.imageAssets}update-app.png',
                    height: 250.0,
                  )),
            ],
          ),
          Text(
            Dictionary.updateAppAvailable,
            style: TextStyle(fontSize: 15.0, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: RaisedButton(
              color: ColorBase.green,
              textColor: Colors.white,
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                child: Text(
                  Dictionary.update,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () {
                launchExternal(widget.linkUpdate);
              },
            ),
          ),
        ],
      ),
    );
  }
}
