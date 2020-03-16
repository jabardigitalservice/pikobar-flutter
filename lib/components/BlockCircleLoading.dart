import 'package:flutter/material.dart';

Future blockCircleLoading({@required BuildContext context, bool dismissible}) {
  return showDialog(
      context: context,
      barrierDismissible: dismissible != null ? dismissible : false,
      builder: (context) => Center(
            child: Container(
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: CircularProgressIndicator()),
          ));
}
