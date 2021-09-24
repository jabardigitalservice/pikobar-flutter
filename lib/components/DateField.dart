import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

const String _DATE_FORMAT = 'dd-MMMM-yyyy';
const String _MIN_DATE = '1900-01-01';

class DateField extends StatefulWidget {
  DateField({
    Key key,
    this.controller,
    this.title,
    this.placeholder,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String title;
  final String placeholder;
  final FormFieldValidator<String> validator;

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
            height: 10,
          ),
          TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: Image.asset(
                '${Environment.iconAssets}calendar.png',
                scale: 1.5,
              ),
              hintText: Dictionary.chooseDatePlaceholder,
            ),
            readOnly: true,
            validator: widget.validator,
            onTap: _showDatePicker,
          )
        ],
      ),
    );
  }

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(Dictionary.save, style: TextStyle(color: Colors.red)),
        cancel: Text(Dictionary.cancel, style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime: DateTime.parse(_MIN_DATE),
      maxDateTime: DateTime.now(),
      initialDateTime: widget.controller.text == ''
          ? DateTime.now()
          : DateTime.parse(widget.controller.text),
      dateFormat: _DATE_FORMAT,
      locale: DateTimePickerLocale.id,
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          widget.controller.text = dateTime.toString();
          _controller.text = DateFormat.yMMMMd('id').format(dateTime);
        });
      },
    );
  }
}
