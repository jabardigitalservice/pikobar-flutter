import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: 'News'),
      body: Container(),
    );
  }
}
