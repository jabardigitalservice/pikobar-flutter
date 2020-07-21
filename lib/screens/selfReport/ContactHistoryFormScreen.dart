import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/GroupedCheckBox.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class ContactHistoryFormScreen extends StatefulWidget {
  @override
  _ContactHistoryFormScreenState createState() =>
      _ContactHistoryFormScreenState();
}

class _ContactHistoryFormScreenState extends State<ContactHistoryFormScreen> {
  final _nameFieldController = TextEditingController();
  final _phoneFieldController = TextEditingController();
  final _genderFieldController = TextEditingController();
  final _dateController = TextEditingController();

  String _format = 'yyyy-MMMM-dd';
  String _minDate = '2019-01-01';
  bool _isDateEmpty = false;

  List<String> _allItemList = [
    'Kontak Serumah',
    'Kerabat Kerja',
    'Teman',
    'Tetangga',
    'Keluarga Tidak Serumah',
    'Lainnya'
  ];

  List<String> _checkedItemList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: 'Form Riwayat Kontak'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
        child: Form(
          child: ListView(
            children: <Widget>[
              SizedBox(height: Dimens.padding),
              _buildLabel(text: 'Nama Kontak'),
              _buildTextField(
                  controller: _nameFieldController, hint: 'Masukkan Nama'),
              _buildLabel(text: 'Nomor HP'),
              _buildTextField(
                  controller: _phoneFieldController, hint: 'Masukkan Nomor HP'),
              _buildLabel(text: 'Jenis Kelamin'),
              _buildGenderOption(
                  controller: _genderFieldController,
                  title: 'Jenis Kelamin',
                  label: <String>[
                    "Laki - Laki",
                    "Perempuan",
                  ],
                  isEmpty: false),
              _buildLabel(text: 'Hubungan'),
              Container(
                margin: EdgeInsets.only(
                    top: Dimens.fieldMarginTop,
                    bottom: Dimens.fieldMarginBottom),
                child: GroupedCheckBox(
                  itemHeight: 40.0,
                  borderRadius: BorderRadius.circular(8.0),
                  color: ColorBase.menuBorderColor,
                  activeColor: ColorBase.green,
                  itemLabelList: _allItemList,
                  itemValueList: _allItemList,
                  orientation: CheckboxOrientation.WRAP,
                  itemWidth: MediaQuery.of(context).size.width / 2 - 21,
                  wrapDirection: Axis.horizontal,
                  wrapSpacing: 10.0,
                  wrapRunSpacing: 10.0,
                  onChanged: (itemList) {
                    setState(() {
                      _checkedItemList = itemList;
                    });
                  },
                  textStyle:
                      TextStyle(fontFamily: FontsFamily.lato, fontSize: 12),
                ),
              ),
              _buildLabel(text: 'Tanggal Kontak Terakhir', required: false),
              Container(
                margin: EdgeInsets.only(
                    top: Dimens.fieldMarginTop,
                    bottom: Dimens.fieldMarginBottom),
                child: _buildDateField(
                    title: Dictionary.contactDate,
                    placeholder: _dateController.text == ''
                        ? Dictionary.contactDatePlaceholder
                        : DateFormat.yMMMMd('id')
                            .format(DateTime.parse(_dateController.text)),
                    isEmpty: _isDateEmpty),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: Dimens.buttonTopMargin,
                    bottom: Dimens.fieldMarginBottom),
                child: RoundedButton(
                    title: Dictionary.save,
                    elevation: 0.0,
                    color: ColorBase.green,
                    textStyle: TextStyle(
                        fontFamily: FontsFamily.lato,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                    onPressed: (){}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildLabel({@required String text, bool required = true}) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: text,
          style: TextStyle(
              fontFamily: FontsFamily.lato,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              height: 18.0 / 12.0,
              color: Colors.black)),
      required
          ? TextSpan(
              text: ' (*)',
              style: TextStyle(
                  fontFamily: FontsFamily.lato,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  height: 18.0 / 12.0,
                  color: Colors.red))
          : TextSpan()
    ]));
  }

  _buildTextField(
      {@required TextEditingController controller, @required String hint}) {
    return Container(
      height: Dimens.fieldSize,
      margin: EdgeInsets.only(
          top: Dimens.fieldMarginTop, bottom: Dimens.fieldMarginBottom),
      decoration: BoxDecoration(
          border: Border.all(color: ColorBase.menuBorderColor),
          borderRadius: BorderRadius.circular(8.0)),
      padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
      child: TextField(
        controller: controller,
        maxLines: 1,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }

  _buildGenderOption(
      {@required TextEditingController controller,
      @required String title,
      @required List<String> label,
      @required bool isEmpty}) {
    return Container(
      margin: EdgeInsets.only(
          top: Dimens.fieldMarginTop, bottom: Dimens.fieldMarginBottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RadioButtonGroup(
            activeColor: ColorBase.limeGreen,
            labelStyle: TextStyle(fontSize: 12, fontFamily: FontsFamily.lato),
            orientation: GroupedButtonsOrientation.HORIZONTAL,
            onSelected: (String selected) => setState(() {
              // Set value to M or F
              controller.text = selected.contains('Laki') ? 'M' : 'F';
            }),
            labels: label,
            itemBuilder: (Radio rb, Text txt, int i) {
              return Padding(
                padding: EdgeInsets.only(right: 10),
                child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: ColorBase.menuBorderColor, width: 1)),
                    child: Row(
                      children: <Widget>[
                        rb,
                        txt,
                      ],
                    )),
              );
            },
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

  _buildDateField({String title, placeholder, bool isEmpty}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            _showDatePicker();
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isEmpty ? Colors.red : ColorBase.menuBorderColor)),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      height: 20,
                      child:
                          Image.asset('${Environment.iconAssets}calendar.png')),
                ),
                Text(
                  placeholder,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: FontsFamily.lato,
                      color: placeholder == Dictionary.contactDatePlaceholder
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
      minDateTime: DateTime.parse(_minDate),
      maxDateTime: DateTime.now(),
      initialDateTime: _dateController.text == ''
          ? DateTime.now()
          : DateTime.parse(_dateController.text),
      dateFormat: _format,
      locale: DateTimePickerLocale.id,
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateController.text = dateTime.toString();
          _isDateEmpty = _dateController.text.isEmpty;
        });
      },
    );
  }
}
