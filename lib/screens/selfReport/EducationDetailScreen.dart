import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:pikobar_flutter/blocs/educations/educationDetail/Bloc.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/HeroImagePreviewScreen.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/EducationModel.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:url_launcher/url_launcher.dart';

class EducationDetailScreen extends StatefulWidget {
  final String id;
  final String educationCollection;
  final EducationModel model;

  EducationDetailScreen({this.id, this.educationCollection, this.model});

  @override
  _EducationDetailScreenState createState() => _EducationDetailScreenState();
}

class _EducationDetailScreenState extends State<EducationDetailScreen> {
  // ignore: close_sinks
  EducationDetailBloc _educationDetailBloc;

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.education);
    AnalyticsHelper.setLogEvent(Analytics.tappedEducationDetail);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EducationDetailBloc>(
      create: (context) => _educationDetailBloc = EducationDetailBloc()
        ..add(EducationDetailLoad(
            educationCollection: widget.educationCollection,
            educationId: widget.id)),
      child: BlocBuilder<EducationDetailBloc, EducationDetailState>(
        bloc: _educationDetailBloc,
        builder: (context, state) {
          return _buildScaffold(context, state);
        },
      ),
    );
  }

  Scaffold _buildScaffold(BuildContext context, EducationDetailState state) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: CustomAppBar.setTitleAppBar(Dictionary.educationContent),
        ),
        body: state is EducationDetailLoading
            ? _buildLoading(context)
            : state is EducationDetailLoaded
                ? _buildContent(context, state.record)
                : state is EducationDetailFailure
                    ? _buildContent(context, widget.model)
                    : Container());
  }

  /// Widget for show loading when request data from server
  _buildLoading(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Skeleton(
        child: Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200.0,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, top: 15.0, right: 15.0, bottom: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 20.0,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 25.0,
                          height: 25.0,
                          color: Colors.grey,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 80.0,
                                  height: 10.0,
                                  color: Colors.grey,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 4.0),
                                  width: 150.0,
                                  height: 10.0,
                                  color: Colors.grey,
                                ),
                              ]),
                        )
                      ],
                    ),
                    SizedBox(height: 10.0),
                    _loadingText(),
                    SizedBox(height: 10.0),
                    _loadingText(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Setup text when loading data from server
  _loadingText() {
    List<Widget> widgets = [];

    for (int i = 0; i < 4; i++) {
      widgets.add(Container(
        margin: EdgeInsets.only(bottom: 5.0),
        width: MediaQuery.of(context).size.width,
        height: 18.0,
        color: Colors.grey,
      ));
    }

    widgets.add(Container(
      margin: EdgeInsets.only(bottom: 5.0),
      width: MediaQuery.of(context).size.width / 2,
      height: 18.0,
      color: Colors.grey,
    ));

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
  }

  /// Widget data for show data when loaded from server
  _buildContent(BuildContext context, EducationModel data) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              // widget for show image
              child: Hero(
                tag: Dictionary.heroImageTag,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey,
                  child: CachedNetworkImage(
                    imageUrl: data.image,
                    placeholder: (context, url) => Center(
                        heightFactor: 10.2,
                        child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Container(
                        height: MediaQuery.of(context).size.height / 3.3,
                        color: Colors.grey[200],
                        child: Image.asset(
                            '${Environment.iconAssets}pikobar.png',
                            fit: BoxFit.fitWidth)),
                  ),
                ),
              ),
              // Function for direct to preview page image
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => HeroImagePreview(
                              Dictionary.heroImageTag,
                              imageUrl: data.image,
                            )));
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, top: 15.0, right: 15.0, bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //add title data from server to widget text
                  Text(
                    data.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontFamily: FontsFamily.lato,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Add data source channel to Text from server
                          Text(
                            data.sourceChannel,
                            style: TextStyle(
                                fontSize: 12.0, fontFamily: FontsFamily.lato),
                          ),
                          // Add data timestamp to Text from server
                          Text(unixTimeStampToDateTime(data.publishedAt),
                              style: TextStyle(
                                  fontSize: 12.0, fontFamily: FontsFamily.lato))
                        ]),
                  ),
                  SizedBox(height: 10.0),
                  //add content data from server to widget text
                  Html(
                      data: data.content,
                      style: {
                        'body': Style(
                            margin: EdgeInsets.zero,
                            color: Colors.black,
                            fontSize: FontSize(14.0),
                            textAlign: TextAlign.start),
                      },
                      onLinkTap: (url) {
                        _launchURL(url);
                      }),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
