import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class SelfReportFormScreen extends StatefulWidget {
  @override
  _SelfReportFormScreenState createState() => _SelfReportFormScreenState();
}

class _SelfReportFormScreenState extends State<SelfReportFormScreen> {

  final _dateController = TextEditingController();

  DateTimePickerLocale _locale = DateTimePickerLocale.id;
  String _format = 'yyyy-MMMM-dd';
  String minDate = '1900-01-01';

  bool isDateEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: 'Form Lapor Kesehatan Harian'),
      body: Container(
        padding: EdgeInsets.all(Dimens.padding),
        child: ListView(
          children: <Widget>[
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text:
                      'Kapan terakhir kali Anda bertemu dengan terduga/ kasus terkonfirmasi COVID-19?',
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      height: 18.0 / 12.0,
                      color: Colors.black)),

              TextSpan(
                  text: ' (*)',
                  style: TextStyle(
                      fontFamily: FontsFamily.lato,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      height: 18.0 / 12.0,
                      color: Colors.red))
            ])),

            buildDateField(
                title: '',
                placeholder: _dateController.text == ''
                    ? Dictionary.birthdayPlaceholder
                    : DateFormat.yMMMMd().format(
                    DateTime.parse(_dateController
                        .text
                        .substring(0, 10))),
                isEmpty: isDateEmpty),
          ],
        ),
      ),
    );
  }

  // Funtion to build date field
  Widget buildDateField({String title, placeholder, bool isEmpty}) {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 12.0,
                    color: ColorBase.veryDarkGrey,
                    fontFamily: FontsFamily.lato,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                ' (*)',
                style: TextStyle(fontSize: 15.0, color: Colors.red),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              _showDatePicker();
            },
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: isEmpty ? Colors.red : ColorBase.menuBorderColor,
                      width: 1.5)),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        height: 20,
                        child: Image.asset(
                            '${Environment.iconAssets}calendar.png')),
                  ),
                  Text(
                    placeholder,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: FontsFamily.lato,
                        color: placeholder == Dictionary.birthdayPlaceholder
                            ? ColorBase.darkGrey
                            : Colors.black),
                  ),
                ],
              ),
            ),
          ),
          isEmpty
              ? SizedBox(
            height: 10,
          )
              : Container(),
          isEmpty
              ? Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              title + Dictionary.pleaseCompleteAllField,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          )
              : Container()
        ],
      ),
    );
  }

  // Function to build Date Picker
  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(Dictionary.save, style: TextStyle(color: Colors.red)),
        cancel: Text(Dictionary.cancel, style: TextStyle(color: Colors.cyan)),
      ),
      minDateTime: DateTime.parse(minDate),
      maxDateTime: DateTime.now(),
      initialDateTime: _dateController.text == ''
          ? DateTime.now()
          : DateTime.parse(_dateController.text),
      dateFormat: _format,
      locale: _locale,
      onClose: () {
        setState(() {
          _dateController.text = _dateController.text;
        });
      },
      onCancel: () {
        setState(() {
          _dateController.text = _dateController.text;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateController.text = dateTime.toString();
        });
      },
    );
  }
}
