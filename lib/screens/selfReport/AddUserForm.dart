import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/components/Announcement.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/GroupedRadioButton.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/selfReport/ConfirmUserForm.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/Validations.dart';

class AddUserFormScreen extends StatefulWidget {
  AddUserFormScreen({Key key}) : super(key: key);

  @override
  _AddUserFormScreenState createState() => _AddUserFormScreenState();
}

class _AddUserFormScreenState extends State<AddUserFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _relationController = TextEditingController();
  final _nikController = MaskedTextController(mask: '0000000000000000');

  bool isBirthdayEmpty = false;
  bool isGenderEmpty = false;
  bool isRelationEmpty = false;
  ScrollController _scrollController;

  String _format = 'dd-MMMM-yyyy';
  String minDate = '1900-01-01';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));

    AnalyticsHelper.setCurrentScreen(Analytics.selfReports);
    AnalyticsHelper.setLogEvent(Analytics.tappedAddOtherUserReportForm);
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset >
            0.16 * MediaQuery.of(context).size.height - (kToolbarHeight * 1.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.animatedAppBar(
        showTitle: _showTitle,
        title: Dictionary.addUserForm,
      ),
      backgroundColor: Colors.white,
      body: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Dimens.contentPadding),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: _scrollController,
              children: <Widget>[
                AnimatedOpacity(
                  opacity: _showTitle ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 250),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      Dictionary.addUserForm,
                      style: TextStyle(
                          fontFamily: FontsFamily.lato,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: Dimens.padding),
                buildAnnouncement(),
                const SizedBox(height: Dimens.padding),
                buildTextField(
                    controller: _nikController,
                    hintText: Dictionary.placeholderNIK,
                    validation: Validations.nikValidation,
                    isEdit: true,
                    title: Dictionary.nik,
                    textInputType: TextInputType.number),
                const SizedBox(height: Dimens.padding),
                buildTextField(
                    controller: _nameController,
                    hintText: Dictionary.placeholderName,
                    isEdit: true,
                    title: Dictionary.name,
                    validation: Validations.nameValidation,
                    textInputType: TextInputType.text),
                const SizedBox(height: Dimens.padding),
                buildLabel(text: Dictionary.birthday, required: true),
                const SizedBox(height: Dimens.padding),
                buildDateField(
                    title: Dictionary.birthday,
                    placeholder: _dateController.text == ''
                        ? Dictionary.birthdayPlaceholder
                        : DateFormat.yMMMMd('id')
                            .format(DateTime.parse(_dateController.text)),
                    isEmpty: isBirthdayEmpty),
                const SizedBox(height: Dimens.padding),
                buildLabel(text: Dictionary.gender),
                _buildRadioButton(
                    title: Dictionary.gender,
                    itemList: <String>[
                      "Laki - Laki",
                      "Perempuan",
                    ],
                    onChanged: (label, index) {
                      setState(() {
                        _genderController.text = index == 0 ? 'M' : 'F';
                        isGenderEmpty = _genderController.text.isEmpty;
                      });
                    },
                    validator: (value) {
                      return isGenderEmpty
                          ? '${Dictionary.gender + Dictionary.pleaseCompleteAllField}'
                          : null;
                    }),
                buildLabel(text: Dictionary.relation),
                _buildRadioButton(
                    title: Dictionary.relationOtherSelfReport,
                    itemList: <String>[
                      "Orangtua",
                      "Suami/Istri",
                      "Anak",
                      "Kerabat Lainnya",
                    ],
                    onChanged: (label, index) {
                      setState(() {
                        _relationController.text = label;
                        isRelationEmpty = _relationController.text.isEmpty;
                      });
                    },
                    validator: (value) {
                      return isRelationEmpty
                          ? '${Dictionary.relation + Dictionary.pleaseCompleteAllField}'
                          : null;
                    }),
                const SizedBox(height: 32.0),
                RoundedButton(
                    title: Dictionary.nextStep,
                    elevation: 0.0,
                    color: ColorBase.green,
                    textStyle: TextStyle(
                        fontFamily: FontsFamily.roboto,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                    onPressed: () {
                      _saveSelfReport();
                    }),
                const SizedBox(height: Dimens.padding),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Funtion to build text field
  Widget buildTextField(
      {String title,
      TextEditingController controller,
      String hintText,
      validation,
      TextInputType textInputType,
      TextStyle textStyle,
      bool isEdit,
      int maxLines,
      bool isRequired = true}) {
    return Container(
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
                    fontFamily: FontsFamily.roboto,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                isRequired ? Dictionary.requiredForm : '',
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
            maxLines: maxLines != null ? maxLines : 1,
            style: isEdit
                ? TextStyle(
                    color: Colors.black,
                    fontFamily: FontsFamily.roboto,
                    fontSize: 12)
                : TextStyle(
                    color: ColorBase.disableText,
                    fontFamily: FontsFamily.roboto,
                    fontSize: 12),
            enabled: isEdit,
            validator: validation,
            textCapitalization: TextCapitalization.words,
            controller: controller,
            decoration: InputDecoration(
                fillColor: ColorBase.greyContainer,
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(
                    color: ColorBase.netralGrey,
                    fontFamily: FontsFamily.roboto,
                    fontSize: 12),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.red, width: 1.5)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: ColorBase.greyBorder, width: 1.5)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: ColorBase.greyBorder, width: 1.5)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: ColorBase.greyBorder, width: 1.5))),
            keyboardType:
                textInputType != null ? textInputType : TextInputType.text,
          )
        ],
      ),
    );
  }

  RichText buildLabel({@required String text, bool required = true}) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: text,
          style: TextStyle(
              fontFamily: FontsFamily.roboto,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              height: 18.0 / 12.0,
              color: ColorBase.veryDarkGrey)),
      required
          ? TextSpan(
              text: Dictionary.requiredForm,
              style: TextStyle(
                  fontFamily: FontsFamily.roboto,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  height: 18.0 / 12.0,
                  color: Colors.green))
          : TextSpan()
    ]));
  }

  // Funtion to build date field
  Widget buildDateField({String title, placeholder, bool isEmpty}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            _showDatePicker();
          },
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: ColorBase.greyContainer,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isEmpty ? Colors.red : ColorBase.greyBorder,
                    width: 1.5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    placeholder,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: FontsFamily.roboto,
                        color: placeholder == Dictionary.birthdayPlaceholder
                            ? ColorBase.netralGrey
                            : Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      height: 15,
                      child:
                          Image.asset('${Environment.iconAssets}calendar.png')),
                )
              ],
            ),
          ),
        ),
        isEmpty
            ? const SizedBox(
                height: 10,
              )
            : Container(),
        isEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 15),
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
      minDateTime: DateTime.parse(minDate),
      maxDateTime: DateTime.now(),
      initialDateTime: _dateController.text == ''
          ? DateTime.now()
          : DateTime.parse(_dateController.text),
      dateFormat: _format,
      locale: DateTimePickerLocale.id,
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateController.text = dateTime.toString();
          isBirthdayEmpty = _dateController.text.isEmpty;
        });
      },
    );
  }

  // Build each radio button on the form
  _buildRadioButton(
      {@required title,
      @required List<String> itemList,
      @required void Function(String label, int index) onChanged,
      FormFieldValidator<String> validator}) {
    return Container(
      margin: const EdgeInsets.only(
          top: Dimens.fieldMarginTop, bottom: Dimens.fieldMarginBottom),
      child: GroupedRadioButton(
        itemWidth: MediaQuery.of(context).size.width / 2 - 21,
        itemHeight: 40.0,
        borderRadius: BorderRadius.circular(Dimens.borderRadius),
        color: ColorBase.menuBorderColor,
        activeColor: ColorBase.green,
        itemLabelList: itemList,
        orientation: RadioButtonOrientation.VERTICAL,
        wrapDirection: Axis.horizontal,
        wrapSpacing: 10.0,
        wrapRunSpacing: 10.0,
        onChanged: (label, index) {
          setState(() {
            onChanged(label, index);
            FocusScope.of(context).unfocus();
          });
        },
        textStyle: TextStyle(
            fontFamily: FontsFamily.roboto,
            fontSize: 14,
            color: ColorBase.grey800),
        validator: validator,
      ),
    );
  }

  /// Set up for show announcement widget
  Widget buildAnnouncement() {
    return Announcement(
      margin: const EdgeInsets.all(0),
      title: Dictionary.titleInfoTextAnnouncement,
      content: Dictionary.otherReportAnnouncement,
      context: context,
      onLinkTap: (url) {},
    );
  }

  // Validate and Record data to firestore
  void _saveSelfReport() async {
    isBirthdayEmpty = _dateController.text.isEmpty;
    isRelationEmpty = _relationController.text.isEmpty;
    isGenderEmpty = _genderController.text.isEmpty;
    setState(() {
      FocusScope.of(context).unfocus();
      if (_formKey.currentState.validate()) {
        if (!isBirthdayEmpty && !isRelationEmpty && !isGenderEmpty) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ConfirmUserForm(
                    nik: _nikController.text,
                    name: _nameController.text,
                    birthday: _dateController.text,
                    gender: _genderController.text,
                    relation: _relationController.text,
                  )));
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nikController.dispose();
    _nameController.dispose();
    _dateController.dispose();
  }
}
