import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/UrlThirdParty.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:share/share.dart';

class InfoGraphicsServices {
  void choiceAction(
      BuildContext context, String choice, DocumentSnapshot data) {
    if (choice == 'Unduh') {
      downloadFile(context, data['title'], data['images'][0]);
    } else if (choice == 'Bagikan') {
      final _backLink =
          '${UrlThirdParty.urlCoronaInfo}infographics/${data.documentID}';

      Share.share(
          '${data['title']}\n\n${_backLink != null ? _backLink + '\n' : ''}\nBaca Selengkapnya di aplikasi Pikobar : ${UrlThirdParty.pathPlaystore}');
    }
  }

  void downloadFile(BuildContext context, String name, String url) async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogRequestPermission(
                image: Image.asset(
                  '${Environment.iconAssets}folder.png',
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                description: Dictionary.permissionDownloadFile,
                onOkPressed: () {
                  Navigator.of(context).pop();
                  PermissionHandler().requestPermissions(
                      [PermissionGroup.storage]).then((val) {
                    // _onStatusRequested(val, name, url);
                    final status = val[PermissionGroup.storage];
                    if (status == PermissionStatus.granted) {
                      downloadFile(context, name, url);
                    }
                  });
                },
              ));
    } else {
      String _localPath =
          (await getExternalStorageDirectory()).path + '/download';
      final dir = Directory(_localPath);
      bool hasExisted = await dir.exists();
      if (!hasExisted) {
        dir.create();
      }
      await FlutterDownloader.enqueue(
        url: url,
        savedDir: _localPath,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );

      // await AnalyticsHelper.setLogEvent(
      //     Analytics.EVENT_DOWNLOAD_ATTACHMENT_IMPORTANT_INFO, <String, dynamic>{
      //   'important_info_id': _id,
      //   'attachment_name': name,
      // });
    }
  }
}
