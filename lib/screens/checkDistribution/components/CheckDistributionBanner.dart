import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

class CheckDistributionBanner extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;

  const CheckDistributionBanner(
      {Key key, this.title, this.subTitle, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      child: Card(
        color: Color(0xFFF2C94C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: Dimens.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          fontFamily: FontsFamily.productSans,
                          fontSize: 16.0,
                          height: 1.2,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      subTitle,
                      style: TextStyle(
                        fontFamily: FontsFamily.productSans,
                        fontSize: 12.0,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Image.asset(
                image,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
