import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pikobar_flutter/blocs/selfReport/selfReportActivation/SelfReportActivationBloc.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/components/DateField.dart';
import 'package:pikobar_flutter/components/RadioFormField.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class SelfReportActivationScreen extends StatelessWidget {
  const SelfReportActivationScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SelfReportActivationBloc>(
      create: (context) => SelfReportActivationBloc(),
      child: SelfReportActivationForm(),
    );
  }
}

class SelfReportActivationForm extends StatefulWidget {
  SelfReportActivationForm({Key key}) : super(key: key);

  @override
  _SelfReportActivationFormState createState() =>
      _SelfReportActivationFormState();
}

class _SelfReportActivationFormState extends State<SelfReportActivationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _testTypeController = TextEditingController();
  final _dateController = TextEditingController();
  final _testTypeValue = <String>[
    'Rapid Antigen',
    'PCR',
  ];

  SelfReportActivationBloc _bloc;
  bool isAgree = false;
  bool isEmptyType = false;

  @override
  void initState() {
    _bloc = BlocProvider.of<SelfReportActivationBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
            BlocListener<SelfReportActivationBloc, SelfReportActivationState>(
          listener: (context, state) {
            if (state is SelfReportActivationSuccess) {
              // Bottom sheet success message
              showSuccessBottomSheet(
                  context: context,
                  image: Image.asset(
                    '${Environment.imageAssets}success.png',
                    width: 200,
                  ),
                  title: Dictionary.selfReportActivationSuccess,
                  message: Dictionary.selfReportActivationSuccessMessage,
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  });
            }
          },
          child:
              BlocBuilder<SelfReportActivationBloc, SelfReportActivationState>(
            builder: (context, state) {
              return state is SelfReportActivationLoading
                  ? _buildLoading()
                  : _buildForm();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Column(
      children: [
        // Load a Lottie file from your assets
        Lottie.asset('${Environment.lottieAssets}loading_animation.json'),

        Text(
          Dictionary.selfReportActivationLoading,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 14,
              height: 1.5,
              fontFamily: FontsFamily.roboto,
              fontWeight: FontWeight.bold,
              color: ColorBase.netralGrey),
        )
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 32),
              child: Text(
                Dictionary.dailySelfReport,
                style: TextStyle(
                    fontFamily: FontsFamily.lato,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            RadioFormField(
              controller: _testTypeController,
              title: Dictionary.testType,
              items: _testTypeValue,
              showError: isEmptyType,
            ),
            SizedBox(
              height: 15,
            ),
            DateField(
              controller: _dateController,
              title: Dictionary.confirmationDate,
              placeholder: Dictionary.chooseDatePlaceholder,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Harus diisi';
                }
                return null;
              },
            ),
            Spacer(),
            Row(
              children: [
                Checkbox(
                  value: isAgree,
                  activeColor: ColorBase.lightLimeGreen,
                  checkColor: ColorBase.limeGreen,
                  onChanged: (bool value) {
                    setState(() {
                      isAgree = value;
                    });
                  },
                ),
                Expanded(
                  child: Text(Dictionary.selfReportActivationAgreement),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(top: 32),
              child: RaisedButton(
                splashColor: Colors.lightGreenAccent,
                padding: const EdgeInsets.all(0),
                color: ColorBase.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.borderRadius),
                ),
                child: Text(
                  Dictionary.acceptLogin,
                  style: TextStyle(
                      fontFamily: FontsFamily.roboto,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white),
                ),
                onPressed: isAgree ? _process : null,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _process() {
    setState(() {
      isEmptyType = _testTypeController.text.isEmpty;
    });

    if (_formKey.currentState.validate() &&
        _testTypeController.text.isNotEmpty) {
      final date = DateTime.parse(_dateController.text);
      final type = _testTypeController.text == _testTypeValue[1]
          ? SelfReportActivateType.PCR
          : SelfReportActivateType.ANTIGEN;
      _bloc.add(SelfReportActivate(date: date, type: type));
    }
  }
}
