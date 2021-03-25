import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/environment/Environment.dart';

class DocumentViewScreen extends StatefulWidget {
  final String url;
  final String nameFile;

  DocumentViewScreen({this.url, this.nameFile});

  @override
  _DocumentViewScreenState createState() => _DocumentViewScreenState();
}

class _DocumentViewScreenState extends State<DocumentViewScreen> {
  String remotePDFpath = "";
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  String nameFile;

  @override
  void initState() {
    if (widget.nameFile.length > 253) {
      var maxlength = widget.nameFile.length - 253;
      nameFile =
          widget.nameFile.substring(0, widget.nameFile.length - maxlength);
    } else {
      nameFile = widget.nameFile;
    }

    createFileOfPdfUrl().then((f) {
      setState(() {
        remotePDFpath = f.path;
      });
    });

    super.initState();
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    print("Start download file from internet! url : " + widget.url);
    try {
      final url = widget.url;
      final filename =
          nameFile.replaceAll(RegExp(r"\|.*"), '').replaceAll('/', '').trim() +
              '.pdf';
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = Environment.downloadStorage;
      print("$dir/$filename");
      File file = File("$dir/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return remotePDFpath.isNotEmpty
        ? PDFViewerScaffold(
            appBar: CustomAppBar.defaultAppBar(
              title: Dictionary.documentPreview,
            ),
            path: remotePDFpath,
          )
        : Scaffold(
            appBar: CustomAppBar.defaultAppBar(
              title: Dictionary.documentPreview,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
  }
}
