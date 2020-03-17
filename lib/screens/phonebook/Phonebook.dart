import 'package:flutter/material.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';

class Phonebook extends StatefulWidget {
  @override
  _PhonebookState createState() => _PhonebookState();
}

class _PhonebookState extends State<Phonebook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.defaultAppBar(title: 'Phonebook'),
      body: Container(),
    );
  }
}
