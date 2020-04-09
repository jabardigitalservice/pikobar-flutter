import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';

class CheckDistributionCardFilter extends StatelessWidget {
  final String region;
  final int countPositif;
  final int countOdp;
  final int countPdp;
  final String typeRegion;

  const CheckDistributionCardFilter(
      {Key key,
      @required this.region,
      @required this.countPositif,
      @required this.countOdp,
      @required this.countPdp,
      @required this.typeRegion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimens.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '${Dictionary.regionInfo} $typeRegion ',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: FontsFamily.productSans,
                    fontSize: 14.0,
                    height: 1.5,
                  ),
                ),
                TextSpan(
                  text: region,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: FontsFamily.productSans,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    height: 1.5,
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 20),

          // build location by sub city
          _buildContent(context, countPositif, Dictionary.positifString,
              Color(0xffF08484)),
          SizedBox(height: 20),

          // build ODP
          _buildContent(
              context, countOdp, Dictionary.odpString, Color(0xffFFCC29)),
          SizedBox(height: 20),

          // build PDP
          _buildContent(
              context, countPdp, Dictionary.pdpString, Color(0xffF2994A)),
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, int count, String description, Color color) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 0.0,
              offset: Offset(0.0, 0.0),
            ),
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          count > 0
              ? Container(
                  width: 5,
                  height: MediaQuery.of(context).size.height * 0.12,
                  padding: EdgeInsets.only(right: 4.0, left: 4.0),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(17.0),
                        bottomLeft: Radius.circular(17.0)),
                  ),
                )
              : Container(),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(Dimens.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      description,
                      style: TextStyle(
                        fontFamily: FontsFamily.productSans,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        height: 1.2,
                      ),
                    ),
                    // SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: Dimens.padding),
                          child: Text(count.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontsFamily.productSans)),
                        ),
                        SizedBox(height: 5),
                        Container(
                          margin: EdgeInsets.only(
                              top: Dimens.padding, left: 4.0, bottom: 2.0),
                          child: Text(Dictionary.people,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontsFamily.productSans)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
