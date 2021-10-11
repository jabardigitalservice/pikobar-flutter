import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/blocs/selfReport/selfReportActivation/SelfReportActivationBloc.dart';
import 'package:pikobar_flutter/components/CustomBottomSheet.dart';
import 'package:pikobar_flutter/components/DateField.dart';
import 'package:pikobar_flutter/components/RadioFormField.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/home/components/ImagePicker.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/NavigatorHelper.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';
import 'package:pikobar_flutter/utilities/Validations.dart';

import 'SelfReportList.dart';

class SelfReportActivationScreen extends StatelessWidget {
  const SelfReportActivationScreen({this.location, this.cityId});

  final LatLng location;
  final String cityId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SelfReportActivationBloc>(
          create: (context) => SelfReportActivationBloc(),
        ),
        BlocProvider<RemoteConfigBloc>(
          create: (context) => RemoteConfigBloc(),
        ),
      ],
      child: SelfReportActivationForm(
        location: location,
        cityId: cityId,
      ),
    );
  }
}

class SelfReportActivationForm extends StatefulWidget {
  SelfReportActivationForm({Key key, this.location, this.cityId})
      : super(key: key);
  final LatLng location;
  final String cityId;

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

  SelfReportActivationBloc _activationBloc;
  RemoteConfigBloc _remoteConfigBloc;
  bool _isAgree = false;
  bool _isEmptyType = false;
  bool _isSwabDoc;
  String _imageValidator;

  @override
  void initState() {
    _activationBloc = BlocProvider.of<SelfReportActivationBloc>(context);
    _remoteConfigBloc = BlocProvider.of<RemoteConfigBloc>(context);
    _remoteConfigBloc.add(RemoteConfigLoad());
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
              AnalyticsHelper.setLogEvent(
                  Analytics.selfReportActivationSuccess);

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
                    popUntil(context, multiplication: 2);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelfReportList(
                                location: widget.location,
                                cityId: widget.cityId,
                                analytics: Analytics.tappedDailyReport,
                                isHealthStatusChanged: false,
                              )),
                    );
                  });
            }

            if (state is SelfReportActivationFail) {
              AnalyticsHelper.setLogEvent(Analytics.selfReportActivationFail);

              // Bottom sheet fail message
              showWidgetBottomSheet(
                  context: context,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 44.0, vertical: Dimens.verticalPadding),
                        child: Image.asset(
                          '${Environment.imageAssets}fail.png',
                          width: 200,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          Dictionary.selfReportActivationFail,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: FontsFamily.lato,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
                        cubit: _remoteConfigBloc,
                        builder: (context, state) {
                          if (state is RemoteConfigLoaded) {
                            final remoteValue = RemoteConfigHelper.decode(
                                remoteConfig: state.remoteConfig,
                                firebaseConfig:
                                    FirebaseConfig.selfReportActivation,
                                defaultValue: FirebaseConfig
                                    .selfReportActivationDefaultValue);

                            final url = remoteValue['activation_request_url'];
                            final failMessage = remoteValue['fail_message'];

                            return Column(
                              children: [
                                Text(
                                  failMessage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: FontsFamily.lato,
                                      fontSize: 12.0,
                                      color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 24.0),
                                RoundedButton(
                                    title: Dictionary.requestActivation,
                                    textStyle: TextStyle(
                                        fontFamily: FontsFamily.lato,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    color: ColorBase.green,
                                    elevation: 0.0,
                                    onPressed: () async {
                                      AnalyticsHelper.setLogEvent(Analytics
                                          .selfReportActivationRequerst);
                                      popUntil(context, multiplication: 3);
                                      await launchUrl(
                                          context: context, url: url);
                                    }),
                                const SizedBox(height: 16.0),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      RoundedButton(
                          title: Dictionary.back,
                          textStyle: TextStyle(
                              fontFamily: FontsFamily.lato,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          color: Colors.white,
                          borderSide: BorderSide(color: ColorBase.disableText),
                          elevation: 0.0,
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  ));
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
              showError: _isEmptyType,
            ),
            const SizedBox(
              height: 15,
            ),
            DateField(
              controller: _dateController,
              title: Dictionary.confirmationDate,
              placeholder: Dictionary.chooseDatePlaceholder,
              validator: (value) {
                if (value.isEmpty) {
                  return Dictionary.confirmationDate +
                      Dictionary.pleaseCompleteAllField;
                }
                return null;
              },
            ),
            const SizedBox(
              height: Dimens.verticalPadding,
            ),
            ImagePicker(
              title: Dictionary.uploadTestProof,
              isRequired: true,
              imgToTextValue: (value) {
                _isSwabDoc = Validations.checkSwabDocument(value?.text);
              },
              validator: (value) {
                return _imageValidator;
              },
            ),
            Spacer(),
            Row(
              children: [
                Checkbox(
                  value: _isAgree,
                  activeColor: ColorBase.lightLimeGreen,
                  checkColor: ColorBase.limeGreen,
                  onChanged: (bool value) {
                    setState(() {
                      _isAgree = value;
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
              margin: const EdgeInsets.only(top: 32, bottom: 20),
              child: RaisedButton(
                splashColor: Colors.lightGreenAccent,
                padding: const EdgeInsets.all(0),
                color: ColorBase.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.borderRadius),
                ),
                child: Text(
                  Dictionary.checkTestResult,
                  style: TextStyle(
                      fontFamily: FontsFamily.roboto,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white),
                ),
                onPressed: _isAgree ? _process : null,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _process() {
    setState(() {
      _isEmptyType = _testTypeController.text.isEmpty;
      _imageValidator = _isSwabDoc != null
          ? null
          : Dictionary.uploadTestProof.replaceAll('Unggah', '') +
              Dictionary.pleaseCompleteAllField;
    });

    if (_formKey.currentState.validate() &&
        _testTypeController.text.isNotEmpty &&
        _isSwabDoc != null) {
      AnalyticsHelper.setLogEvent(Analytics.submitSelfReportActivation);

      final date = DateTime.parse(_dateController.text);
      final type = _testTypeController.text == _testTypeValue[1]
          ? SelfReportActivateType.PCR
          : SelfReportActivateType.ANTIGEN;
      _activationBloc.add(
          SelfReportActivate(date: date, type: type, isSwabDoc: _isSwabDoc));
    }
  }
}
