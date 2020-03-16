import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final double height, width, padding, margin;
  final Widget child;

  Skeleton({
    Key key,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.white,
      child: child != null
          ? child
          : Container(
              height: height,
              padding: padding != null
                  ? EdgeInsets.all(padding)
                  : EdgeInsets.all(0.0),
              margin:
                  margin != null ? EdgeInsets.all(margin) : EdgeInsets.all(0.0),
              width: width,
              color: Colors.grey[300],
            ),
    );
  }
}
