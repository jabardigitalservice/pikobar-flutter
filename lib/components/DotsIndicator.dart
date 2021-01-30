import 'dart:math';
import 'package:flutter/material.dart';

/// An indicator showing the currently selected page of a PageController
class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    Key key,
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller, key: key);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        width: _kDotSpacing,
        height: _kDotSpacing,
        child: Center(
          child: Material(
            color: color,
            type: MaterialType.circle,
            child: Container(width: _kDotSize * zoom, height: _kDotSize * zoom),
          ),
        ),
      ),
      onTap: () => onPageSelected(index),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
