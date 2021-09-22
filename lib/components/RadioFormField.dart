import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

class RadioFormField extends StatefulWidget {
  RadioFormField({
    Key key,
    this.title,
    this.controller,
    this.items,
    this.errorText,
    this.showError = false,
  }) : super(key: key);

  final String title;

  final TextEditingController controller;

  final List<String> items;

  final String errorText;

  final bool showError;

  @override
  _RadioFormFieldState createState() => _RadioFormFieldState();
}

class _RadioFormFieldState extends State<RadioFormField> {
  String _errorText;

  @override
  void initState() {
    _errorText =
        widget.errorText ?? widget.title + Dictionary.pleaseCompleteAllField;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(
                  fontSize: 12.0,
                  color: ColorBase.veryDarkGrey,
                  fontFamily: FontsFamily.roboto,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              Dictionary.requiredForm,
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.green,
                  fontFamily: FontsFamily.roboto,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        RadioButtonGroup(
          activeColor: ColorBase.limeGreen,
          labelStyle: TextStyle(fontSize: 14, fontFamily: FontsFamily.roboto),
          orientation: GroupedButtonsOrientation.VERTICAL,
          onSelected: (String selected) => setState(() {
            widget.controller.text = selected;
          }),
          labels: widget.items,
          picked: widget.controller.text,
          itemBuilder: (Radio rb, Text txt, int i) {
            return Row(
              children: <Widget>[
                rb,
                txt,
              ],
            );
          },
        ),
        widget.showError
            ? Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  _errorText,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              )
            : Container()
      ],
    );
  }
}
