import 'package:flutter/material.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';

class ErrorContent extends StatefulWidget {
  final String error;

  ErrorContent({this.error});

  @override
  _ErrorContentState createState() => _ErrorContentState();
}

class _ErrorContentState extends State<ErrorContent> {
  String get _error => widget.error;

  @override
  Widget build(BuildContext context) {
    if (_error.contains(Dictionary.errorTimeOut)) {
      return Center(child: _buildContent('assets/images/server-error.png'));
    } else if (_error.contains(Dictionary.errorIOConnection)) {
      return Center(child: _buildContent('assets/images/server-error.png'));
    } else if (_error.contains(Dictionary.errorConnection)) {
      return Center(child: _buildContent('assets/images/offline.png'));
    } else if (_error.contains(Dictionary.errorNotFound)) {
      return Container(
        child: _buildContent('assets/images/not-found.jpg'),
        alignment: Alignment.center,
        color: Colors.white,
      );
    } else {
      return Center(child: _buildUnknownErrorContent());
    }
  }

  _buildContent(String uri) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(uri, width: 200.0, height: 200.0),
          Text(
            _error,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          )
        ],
      );

  _buildUnknownErrorContent() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error,
            size: 100.0,
            color: Colors.grey,
          ),
          SizedBox(height: 20.0),
          Text(
            _error,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          )
        ],
      );
}
