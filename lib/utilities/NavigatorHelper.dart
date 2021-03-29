import 'package:flutter/material.dart';

void popUntil(BuildContext context, {@required int multiplication}) {
  for (var i = 0; i < multiplication; i++) {
    Navigator.of(context).pop();
  }
}
