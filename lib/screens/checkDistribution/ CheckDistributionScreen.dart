import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';

class CheckDistributionScreen extends StatefulWidget {
  @override
  _CheckDistributionScreenState createState() =>
      _CheckDistributionScreenState();
}

class _CheckDistributionScreenState extends State<CheckDistributionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Dictionary.checkDistribution)),
        body: Text('test'));
  }
}
