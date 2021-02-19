import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/netPromoterScore/NPSCubit.dart';
import 'package:pikobar_flutter/components/CustomSliderComponents.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/NPSModel.dart';
import 'package:pikobar_flutter/repositories/NPSRepository.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/Validations.dart';
import 'package:pikobar_flutter/utilities/flushbar_helper.dart';

class DialogNPS extends StatefulWidget {
  DialogNPS({Key key}) : super(key: key);

  @override
  _DialogNPSState createState() => _DialogNPSState();
}

class _DialogNPSState extends State<DialogNPS> {
  final _feedbackFieldController = TextEditingController();
  double _currentSliderValue;
  NPSCubit _npsCubit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Flushbar _flushbar = Flushbar();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NPSCubit>(create: (context) => _npsCubit = NPSCubit()),
      ],
      child: BlocConsumer<NPSCubit, NPSState>(
        listener: (BuildContext context, NPSState state) async {
          if (state is NPSLoading) {
            _flushbar = FlushHelper.loading()..show(context);
          } else if (state is NPSFailed) {
            await _flushbar.dismiss();

            showDialog(
                context: context,
                builder: (context) => DialogTextOnly(
                      description: Dictionary.errorExternal,
                      buttonText: Dictionary.ok.toUpperCase(),
                      onOkPressed: () {
                        Navigator.of(context).pop(); // To close the dialog
                      },
                    ));
          } else {
            await _flushbar.dismiss();
          }
        },
        builder: (BuildContext context, NPSState state) {
          return state is NPSSaved
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 44.0, vertical: Dimens.verticalPadding),
                      child: Image.asset(
                          '${Environment.imageAssets}nps_success.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        Dictionary.nspSuccessTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: FontsFamily.roboto,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      Dictionary.nspSuccessDesc,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: FontsFamily.roboto,
                          fontSize: 12.0,
                          color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24.0),
                    RoundedButton(
                        title: Dictionary.ok.toUpperCase(),
                        textStyle: TextStyle(
                            fontFamily: FontsFamily.roboto,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        color: ColorBase.green,
                        elevation: 0.0,
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                )
              : _buildForm();
        },
      ),
    );
  }

  _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Dictionary.npsTitle,
            style: TextStyle(
              fontFamily: FontsFamily.roboto,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: ColorBase.grey800,
            ),
          ),
          const SizedBox(height: 50.0),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.transparent,
              trackShape: RoundedRectSliderTrackShape(),
              trackHeight: 8.0,
              thumbShape: CustomSliderThumbCircle(thumbRadius: 12.0),
              thumbColor: _sliderColor(_currentSliderValue),
              overlayColor: _sliderColor(_currentSliderValue).withAlpha(32),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
              tickMarkShape: CustomSliderTickMark(tickMarkRadius: 4.0),
              activeTickMarkColor: _sliderColor(_currentSliderValue),
              inactiveTickMarkColor: ColorBase.grey,
              valueIndicatorShape: RectangularSliderValueIndicatorShape(),
              valueIndicatorColor: _sliderColor(_currentSliderValue),
              valueIndicatorTextStyle: TextStyle(
                fontFamily: FontsFamily.roboto,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            child: Slider(
              value: _currentSliderValue ?? 0,
              min: 0,
              max: 10,
              divisions: 10,
              label: _currentSliderValue != null
                  ? _currentSliderValue.round().toString()
                  : '0',
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
          ),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sliderLabel(Dictionary.impossible),
              _sliderLabel(Dictionary.veryPossible)
            ],
          ),
          const SizedBox(height: 32.0),
          Text(
            _question(_currentSliderValue),
            style: TextStyle(
              fontFamily: FontsFamily.roboto,
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
              color: ColorBase.grey800,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: Dimens.sizedBoxHeight),
            child: TextFormField(
              controller: _feedbackFieldController,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              validator: Validations.npsValidation,
              style: TextStyle(fontFamily: FontsFamily.roboto, fontSize: 12.0),
              cursorHeight: 16.0,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorBase.greyContainer,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorBase.greyBorder)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorBase.greyBorder)),
                  hintText: Dictionary.hintFeedbackField,
                  hintStyle: TextStyle(
                      fontFamily: FontsFamily.roboto,
                      fontSize: 12.0,
                      color: ColorBase.netralGrey)),
            ),
          ),
          const SizedBox(height: 32.0),
          RoundedButton(
              title: Dictionary.send,
              textStyle: TextStyle(
                  fontFamily: FontsFamily.roboto,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              color: ColorBase.green,
              elevation: 0.0,
              onPressed: _currentSliderValue != null
                  ? () async {
                      if (_formKey.currentState.validate()) {
                        FocusScope.of(context).unfocus();
                        AnalyticsHelper.setLogEvent(Analytics.tappedSendNPS);
                        final NPSModel npsData = NPSModel(
                            score: _currentSliderValue.round().toString(),
                            feedback: _feedbackFieldController.text.trim());
                        await _npsCubit.saveNPS(npsData);
                      }
                    }
                  : null),
          const SizedBox(height: Dimens.padding),
          RoundedButton(
              title: Dictionary.skip,
              textStyle: TextStyle(
                  fontFamily: FontsFamily.roboto,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  color: ColorBase.grey500),
              color: Colors.white,
              borderSide: BorderSide(color: ColorBase.disableText),
              elevation: 0.0,
              onPressed: () async {
                AnalyticsHelper.setLogEvent(Analytics.tappedSkipNPS);
                await NPSRepository.setNPSTimeLater(
                    DateTime.now().millisecondsSinceEpoch);

                Navigator.pop(context);
              }),
          SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom +
                  Dimens.sizedBoxHeight),
        ],
      ),
    );
  }

  Color _sliderColor(double value) {
    return value != null
        ? value <= 3
            ? Colors.red[400]
            : value <= 5
                ? Colors.orange
                : ColorBase.green
        : Colors.red[400];
  }

  String _question(double value) {
    return value == null || value <= 8
        ? Dictionary.badRateDesc
        : Dictionary.goodRateDesc;
  }

  Text _sliderLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: FontsFamily.roboto,
        fontSize: 12.0,
        color: ColorBase.netralGrey,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _feedbackFieldController.dispose();
    _npsCubit.close();
  }
}
