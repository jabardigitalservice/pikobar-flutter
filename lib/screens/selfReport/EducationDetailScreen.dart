import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:pikobar_flutter/blocs/educations/educationDetail/Bloc.dart';
import 'package:pikobar_flutter/components/CollapsingAppbar.dart';
import 'package:pikobar_flutter/components/EmptyData.dart';
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

  EducationDetailScreen(
      {Key key, this.id, this.educationCollection, this.model})
      : super(key: key);

  @override
  _EducationDetailScreenState createState() => _EducationDetailScreenState();
}

class _EducationDetailScreenState extends State<EducationDetailScreen> {
  ScrollController _scrollController;
  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    AnalyticsHelper.setCurrentScreen(Analytics.education);
    AnalyticsHelper.setLogEvent(Analytics.tappedEducationDetail);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EducationDetailBloc>(
      create: (context) => EducationDetailBloc()
        ..add(EducationDetailLoad(
            educationCollection: widget.educationCollection,
            educationId: widget.id)),
      child: BlocBuilder<EducationDetailBloc, EducationDetailState>(
        builder: (context, state) {
          return _buildScaffold(context, state);
        },
      ),
    );
  }

  Scaffold _buildScaffold(BuildContext context, EducationDetailState state) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CollapsingAppbar(
            scrollController: _scrollController,
            heightAppbar: 300.0,
            showTitle: isShrink,
            isBottomAppbar: false,
            titleAppbar: Dictionary.educationContent,
            backgroundAppBar: GestureDetector(
              child: Hero(
                  tag: Dictionary.heroImageTag,
                  child: Stack(
                    children: [
                      Image.network(
                        widget.model.image,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height,
                      ),
                      Container(
                        color: Colors.black12.withOpacity(0.2),
                      )
                    ],
                  )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => HeroImagePreview(
                              Dictionary.heroImageTag,
                              imageUrl: widget.model.image,
                            )));
              },
            ),
            body: state is EducationDetailLoading
                ? _buildLoading(context)
                : state is EducationDetailLoaded
                    ? _buildContent(context, state.record)
                    : state is EducationDetailFailure
                        ? widget.model != null
                            ? _buildContent(context, widget.model)
                            : EmptyData(
                                message: Dictionary.emptyData,
                                desc: '',
                                isFlare: false,
                                image:
                                    "${Environment.imageAssets}not_found.png",
                              )
                        : Container()));
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
                  Container(
                    margin: const EdgeInsets.only(
                        left: 30.0, top: 15.0, right: 15.0, bottom: 10.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Add data timestamp to Text from server
                          Text(
                              unixTimeStampToDateTimeWithoutDayAndHour(
                                  data.publishedAt),
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[600],
                                  fontFamily: FontsFamily.roboto)),
                          Text(
                            ' • ',
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey[600],
                                fontFamily: FontsFamily.roboto),
                          ),
                          // Add data source channel to Text from server
                          Text(
                            data.sourceChannel,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey[600],
                                fontFamily: FontsFamily.roboto),
                          ),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, bottom: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                                    color: Colors.grey[800],
                                    fontSize: 20.0,
                                    fontFamily: FontsFamily.roboto,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10.0),

                              //add content data from server to widget text
                              Html(
                                  data: data.content,
                                  style: {
                                    'body': Style(
                                        margin: EdgeInsets.zero,
                                        color: Colors.grey[800],
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
                ])));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }
}
