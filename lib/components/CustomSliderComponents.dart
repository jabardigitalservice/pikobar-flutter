import 'package:flutter/material.dart';

/// The shape of a [Slider]'s thumb.
class CustomSliderThumbCircle extends SliderComponentShape {
  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the material default of 10 is used.
  final double thumbRadius;

  /// Create a slider thumb that draws a circle.
  const CustomSliderThumbCircle({
    this.thumbRadius = 10,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = Colors.white //Thumb Background Color
      ..style = PaintingStyle.fill;

    final paintBorder = Paint()
      ..color = sliderTheme.thumbColor //Thumb Background Color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawCircle(center, thumbRadius * .9, paint);
    canvas.drawCircle(center, thumbRadius * .9, paintBorder);
  }
}

/// Tick marks are only displayed if the slider is discrete, which can be done
/// by setting the [Slider.divisions] to an integer value.
///
/// It paints a solid circle, centered in the on the track.
class CustomSliderTickMark extends SliderTickMarkShape {
  /// The preferred radius of the round tick mark.
  ///
  /// If it is not provided, then 1/4 of the [SliderThemeData.trackHeight] is used.
  final double tickMarkRadius;

  /// Create a slider tick mark that draws a circle.
  const CustomSliderTickMark({
    this.tickMarkRadius,
  });

  @override
  Size getPreferredSize(
      {@required SliderThemeData sliderTheme, @required bool isEnabled}) {
    assert(sliderTheme != null);
    assert(sliderTheme.trackHeight != null);
    assert(isEnabled != null);
    // The tick marks are tiny circles. If no radius is provided, then the
    // radius is defaulted to be a fraction of the
    // [SliderThemeData.trackHeight]. The fraction is 1/2.
    return Size.fromRadius(tickMarkRadius ?? sliderTheme.trackHeight / 2);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {@required RenderBox parentBox,
      @required SliderThemeData sliderTheme,
      @required Animation<double> enableAnimation,
      @required Offset thumbCenter,
      @required bool isEnabled,
      @required TextDirection textDirection}) {
    assert(context != null);
    assert(center != null);
    assert(parentBox != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledActiveTickMarkColor != null);
    assert(sliderTheme.disabledInactiveTickMarkColor != null);
    assert(sliderTheme.activeTickMarkColor != null);
    assert(sliderTheme.inactiveTickMarkColor != null);
    assert(enableAnimation != null);
    assert(textDirection != null);
    assert(thumbCenter != null);
    assert(isEnabled != null);
    // The paint color of the tick mark depends on its position relative
    // to the thumb and the text direction.
    Color begin;
    Color end;
    switch (textDirection) {
      case TextDirection.ltr:
        final bool isTickMarkRightOfThumb = center.dx > thumbCenter.dx;
        begin = isTickMarkRightOfThumb
            ? sliderTheme.disabledInactiveTickMarkColor
            : sliderTheme.disabledActiveTickMarkColor;
        end = isTickMarkRightOfThumb
            ? sliderTheme.inactiveTickMarkColor
            : sliderTheme.activeTickMarkColor;
        break;
      case TextDirection.rtl:
        final bool isTickMarkLeftOfThumb = center.dx < thumbCenter.dx;
        begin = isTickMarkLeftOfThumb
            ? sliderTheme.disabledInactiveTickMarkColor
            : sliderTheme.disabledActiveTickMarkColor;
        end = isTickMarkLeftOfThumb
            ? sliderTheme.inactiveTickMarkColor
            : sliderTheme.activeTickMarkColor;
        break;
    }

    final Canvas canvas = context.canvas;

    // The tick marks are tiny circles that are the same height as the track.
    final double tickMarkRadius = getPreferredSize(
      isEnabled: isEnabled,
      sliderTheme: sliderTheme,
    ).width;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: center, width: tickMarkRadius * 2.5, height: tickMarkRadius),
      Radius.circular(tickMarkRadius),
    );

    final Paint paint = Paint()
      ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation);

    if (tickMarkRadius > 0) {
      canvas.drawRRect(rRect, paint);
    }
  }
}
