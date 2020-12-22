import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomSliderComponents.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

class DialogNPS extends StatefulWidget {
  @override
  _DialogNPSState createState() => _DialogNPSState();
}

class _DialogNPSState extends State<DialogNPS> {
  double _currentSliderValue;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        SizedBox(height: 50.0),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
            trackShape: RoundedRectSliderTrackShape(),
            trackHeight: 8.0,
            thumbShape: CustomSliderThumbCircle(thumbRadius: 12.0),
            thumbColor: sliderColor(_currentSliderValue),
            overlayColor: sliderColor(_currentSliderValue).withAlpha(32),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
            tickMarkShape: CustomSliderTickMark(tickMarkRadius: 4.0),
            activeTickMarkColor: sliderColor(_currentSliderValue),
            inactiveTickMarkColor: ColorBase.grey,
            valueIndicatorShape: RectangularSliderValueIndicatorShape(),
            valueIndicatorColor: sliderColor(_currentSliderValue),
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
        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            sliderLabel(Dictionary.impossible),
            sliderLabel(Dictionary.veryPossible)
          ],
        ),
        SizedBox(height: 32.0),
        Text(
          question(_currentSliderValue),
          style: TextStyle(
            fontFamily: FontsFamily.roboto,
            fontSize: 12.0,
            fontWeight: FontWeight.w700,
            color: ColorBase.grey800,
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(top: Dimens.sizedBoxHeight),
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            decoration: InputDecoration(
              filled: true,
              fillColor: ColorBase.greyContainer,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorBase.greyBorder)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorBase.greyBorder)),
            ),
          ),
        ),
        SizedBox(height: 32.0),
        RoundedButton(
            title: Dictionary.send,
            textStyle: TextStyle(
                fontFamily: FontsFamily.roboto,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: Colors.white),
            color: ColorBase.green,
            elevation: 0.0,
            onPressed: _currentSliderValue != null ? () {
              print('$_currentSliderValue');
            } : null),
        SizedBox(height: Dimens.padding),
        RoundedButton(
            title: Dictionary.skip,
            textStyle: TextStyle(
                fontFamily: FontsFamily.roboto,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: ColorBase.grey500),
            color: Colors.white,
            borderSide: BorderSide(
                color: ColorBase.disableText),
            elevation: 0.0,
            onPressed: () {
              Navigator.pop(context);
            }),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom + Dimens.sizedBoxHeight),
      ],
    );
  }

  Color sliderColor(double value) {
    return value != null
        ? value <= 3
            ? Colors.red[400]
            : value <= 5
                ? Colors.orange
                : ColorBase.green
        : Colors.red[400];
  }

  String question(double value) {
    return value == null || value <= 5
        ? Dictionary.badRateDesc
        : Dictionary.goodRateDesc;
  }

  Text sliderLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: FontsFamily.roboto,
        fontSize: 12.0,
        color: ColorBase.netralGrey,
      ),
    );
  }
}
