import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class DialogInformation extends StatelessWidget {
  final String imageUrl, description, buttonText;
  final GestureTapCallback onOkPressed;
  final GestureTapCallback onClosePressed;
  final bool imageOnly;

  DialogInformation(
      {this.description,
      this.imageOnly = false,
      @required this.buttonText,
      @required this.onOkPressed,
      this.onClosePressed,
      @required this.imageUrl})
      : assert(imageUrl != null);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.dialogRadius),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: imageOnly ? _dialogImageOnly(context) : _dialogContent(context),
    );
  }

  _dialogContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: Dimens.padding),
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
              AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                    placeholder: (context, url) => Center(
                        heightFactor: 10.2,
                        child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0)),
                        ),
                        child: Image.asset(
                            '${Environment.imageAssets}pikobar.png',
                            fit: BoxFit.fitWidth))),
              ),
              Positioned(
                right: 0.0,
                child: GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius:
                            BorderRadius.circular(Dimens.dialogRadius),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.blue,
                        size: 24.0,
                      )),
                  onTap: onClosePressed != null
                      ? onClosePressed
                      : () {
                          Navigator.of(context).pop();
                        },
                ),
              )
            ],
          ),
          description != null
              ? Container(
                  margin: EdgeInsets.symmetric(horizontal: Dimens.padding),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 16.0),
                      Text(
                        description,
                        textAlign: TextAlign.left,
                        maxLines: 4,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : Container(),
          SizedBox(height: 24.0),
          Container(
            child: RaisedButton(
              onPressed: onOkPressed,
              color: Colors.blue,
              child: Text(
                buttonText,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _dialogImageOnly(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
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
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 9 / 16,
            child: GestureDetector(
              onTap: onOkPressed,
              child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                  placeholder: (context, url) => Center(
                      heightFactor: 10.2, child: CupertinoActivityIndicator()),
                  errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0)),
                      ),
                      child: Image.asset(
                          '${Environment.imageAssets}pikobar.png',
                          fit: BoxFit.fitWidth))),
            ),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(Dimens.dialogRadius),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.blue,
                    size: 24.0,
                  )),
              onTap: onClosePressed != null
                  ? onClosePressed
                  : () {
                      Navigator.of(context).pop();
                    },
            ),
          )
        ],
      ),
    );
  }
}
