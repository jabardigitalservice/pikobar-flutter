import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/infographics/infographicdetail/Bloc.dart';
import 'package:pikobar_flutter/components/DialogRequestPermission.dart';
import 'package:pikobar_flutter/components/ErrorContent.dart';
import 'package:pikobar_flutter/components/HeroImagePreviewScreen.dart';
import 'package:pikobar_flutter/components/PikobarPlaceholder.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/infoGraphics/infoGraphicsServices.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pedantic/pedantic.dart';

@immutable
class DetailInfoGraphicScreen extends StatefulWidget {
  final DocumentSnapshot dataInfoGraphic;
  final String id;
  final String infographicType;

  DetailInfoGraphicScreen(
      {Key key, this.dataInfoGraphic, this.id, this.infographicType})
      : super(key: key);

  @override
  _DetailInfoGraphicScreenState createState() =>
      _DetailInfoGraphicScreenState();
}

class _DetailInfoGraphicScreenState extends State<DetailInfoGraphicScreen> {
  int _current = 0;
  FToast fToast;
  final ReceivePort _port = ReceivePort();
  List<String> dataUrl = [];

  List<String> getDataUrl() {
    for (int i = 0; i < widget.dataInfoGraphic.get('images').length; i++) {
      dataUrl.add(widget.dataInfoGraphic.get('images')[i]);
    }
    return dataUrl;
  }

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    _downloadListener();
    if (widget.dataInfoGraphic != null) {
      getDataUrl();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light),
        child: widget.dataInfoGraphic == null
            ? BlocProvider<InfoGraphicDetailDetailBloc>(
                create: (context) => InfoGraphicDetailDetailBloc()
                  ..add(InfoGraphicDetailLoad(
                      infographicCollection: widget.infographicType,
                      infographicId: widget.id)),
                child: BlocListener<InfoGraphicDetailDetailBloc,
                    InfoGraphicDetailState>(listener: (context, state) {
                  if (state is InfoGraphicDetailLoaded) {
                    setState(() {
                      dataUrl.clear();
                      for (int i = 0;
                          i < state.record.get('images').length;
                          i++) {
                        dataUrl.add(state.record.get('images')[i]);
                      }
                    });
                  }
                }, child: BlocBuilder<InfoGraphicDetailDetailBloc,
                    InfoGraphicDetailState>(
                  builder: (context, state) {
                    return state is InfoGraphicDetailLoaded
                        ? _buildScaffold(context, state.record)
                        : state is InfoGraphicDetailLoading
                            ? _buildLoading(context)
                            : state is InfoGraphicDetailFailure
                                ? Container(
                                    child: ErrorContent(error: state.error),
                                  )
                                : Container();
                  },
                )))
            : _buildScaffold(context, widget.dataInfoGraphic));
  }

  _buildLoading(BuildContext context) {
    return Container();
  }

  Scaffold _buildScaffold(
      BuildContext context, DocumentSnapshot documentSnapshot) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    height: 360,
                    width: MediaQuery.of(context).size.width,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        initialPage: 0,
                        enableInfiniteScroll: dataUrl.length > 1 ? true : false,
                        aspectRatio: 9 / 9,
                        viewportFraction: 1.0,
                        autoPlay: dataUrl.length > 1 ? true : false,
                        autoPlayInterval: const Duration(seconds: 5),
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                      items: dataUrl.map((String data) {
                        return Builder(builder: (BuildContext context) {
                          return GestureDetector(
                            child: Stack(
                              children: [
                                OptimizedCacheImage(
                                    imageUrl: data ?? '',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                    placeholder: (context, url) => const Center(
                                        heightFactor: 10.2,
                                        child: const CupertinoActivityIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: const BorderRadius.only(
                                                  topLeft:
                                                      const Radius.circular(
                                                          5.0),
                                                  topRight:
                                                      const Radius.circular(
                                                          5.0)),
                                            ),
                                            child: const PikobarPlaceholder())),
                                Container(
                                  height: 360,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    gradient: LinearGradient(
                                      begin: FractionalOffset.topCenter,
                                      end: FractionalOffset.bottomCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.6),
                                        Colors.transparent,
                                      ],
                                      stops: [0.0, 1.0],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (data.isNotEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => HeroImagePreview(
                                        Dictionary.heroImageTag,
                                        galleryItems: dataUrl,
                                      ),
                                    ));
                              }
                            },
                          );
                        });
                      }).toList(),
                    ),
                  ),
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            InfoGraphicsServices().shareInfoGraphics(
                                documentSnapshot['title'],
                                documentSnapshot['images']);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: dataUrl.map((String data) {
                    final int index = dataUrl.indexOf(data);
                    return _current == index
                        ? Container(
                            width: 24.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(30.0),
                                color: ColorBase.green))
                        : Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          );
                  }).toList(),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      unixTimeStampToDateTime(
                          documentSnapshot['published_date'].seconds),
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: FontsFamily.roboto,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              documentSnapshot['title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: FontsFamily.roboto,
                                  fontSize: 20.0),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(
                  left: Dimens.padding, right: Dimens.padding, bottom: 32.0),
              child: RoundedButton(
                  borderRadius: BorderRadius.circular(10.0),
                  title: Dictionary.downloadImage,
                  color: ColorBase.green,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsFamily.roboto,
                  ),
                  onPressed: () {
                    _downloadAttachment(documentSnapshot['images'][_current]);
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _findLocalPath() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

   _downloadAttachment(String url) async {
    final String decodeUrl = Uri.decodeComponent(url);
    final String fileName = decodeUrl.split('/').last.split('?').first;

    if (!await Permission.storage.status.isGranted) {
      unawaited(showDialog(
          context: context,
          builder: (BuildContext context) => DialogRequestPermission(
                image: Image.asset(
                  'assets/icons/folder.png',
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
                description: Dictionary.permissionDownloadAttachment,
                onOkPressed: () {
                  Navigator.of(context).pop();
                  Permission.storage.request().then((val) {
                    _onStatusRequested(val, url);
                  });
                },
              )));
    } else {
      final Widget toast = Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: ColorBase.grey500,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 12.0,
              ),
              Text(
                Dictionary.downloadingFile,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: FontsFamily.roboto,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );

      fToast.showToast(
          child: toast,
          toastDuration: const Duration(seconds: 2),
          positionedToastBuilder: (context, child) {
            return Positioned(
              child: child,
              bottom: 100,
            );
          });

      if (Platform.isAndroid) {
        try {
          await FlutterDownloader.enqueue(
            url: url,
            savedDir: Environment.downloadStorage,
            fileName: fileName,
            showNotification: true,
            // show download progress in status bar (for Android)
            openFileFromNotification:
                true, // click on notification to open downloaded file (for Android)
          );
        } catch (e) {
          final String dir =
              (await getExternalStorageDirectory()).path + '/download';
          await FlutterDownloader.enqueue(
            url: url,
            savedDir: dir,
            fileName: fileName,
            showNotification: true,
            // show download progress in status bar (for Android)
            openFileFromNotification:
                true, // click on notification to open downloaded file (for Android)
          );
        }
      } else if (Platform.isIOS) {
        final String _localPath =
            (await _findLocalPath()) + Platform.pathSeparator + 'images';

        try {
          await FlutterDownloader.enqueue(
            url: url,
            headers: {"auth": "test_for_sql_encoding"},
            savedDir: _localPath,
            fileName: fileName,
            showNotification: true,
            openFileFromNotification: true,
          );
        } catch (e) {
          print(e.toString());
        }
      }

      await AnalyticsHelper.setLogEvent(
          Analytics.tappedDownloadImage, <String, dynamic>{
        'name_image':
            fileName.length < 100 ? fileName : fileName.substring(0, 100),
      });
    }
  }

  void _onStatusRequested(PermissionStatus statuses, String url) {
    if (statuses.isGranted) {
      _downloadAttachment(url);
    }
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  _downloadListener() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      final String id = data[0];
      final DownloadTaskStatus status = data[1];
      final int progress = data[2];
      if (status.toString() == "DownloadTaskStatus(3)" &&
          progress == 100 &&
          id != null) {
        final String query = "SELECT * FROM task WHERE task_id='" + id + "'";
        final  tasks = FlutterDownloader.loadTasksWithRawQuery(query: query);
        //if the task exists, open it
        if (tasks != null) FlutterDownloader.open(taskId: id);
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
