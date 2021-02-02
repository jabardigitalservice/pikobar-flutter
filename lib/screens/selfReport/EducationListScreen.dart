import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/educations/educationList/Bloc.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/EducationModel.dart';
import 'package:pikobar_flutter/screens/selfReport/EducationDetailScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';

class EducationListScreen extends StatefulWidget {
  EducationListScreen({Key key}) : super(key: key);

  @override
  _EducationListScreenState createState() => _EducationListScreenState();
}

class _EducationListScreenState extends State<EducationListScreen> {
  // ignore: close_sinks, unused_field
  EducationListBloc _educationListBloc;

  @override
  void initState() {
    super.initState();
    AnalyticsHelper.setCurrentScreen(Analytics.selfReports);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EducationListBloc>(
            create: (BuildContext context) => _educationListBloc =
                EducationListBloc()..add(EducationListLoad(kEducationContent))),
      ],
      child: BlocListener<EducationListBloc, EducationListState>(
        listener: (context, state) {},
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  Dictionary.educationContent,
                  style: TextStyle(
                      color: ColorBase.grey800,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontsFamily.roboto,
                      fontSize: 16.0),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              BlocBuilder<EducationListBloc, EducationListState>(builder: (
                BuildContext context,
                EducationListState state,
              ) {
                if (state is EducationListLoaded) {
                  return _buildContent(state);
                } else if (state is EducationLisLoading) {
                  return _buildLoading();
                } else {
                  return Container();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget for show loading when request data from server
  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Widget data for show data when loaded from server
  Widget _buildContent(EducationListLoaded state) {
    //Create list education content
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: state.educationList.length,
      padding: const EdgeInsets.only(bottom: 10.0),
      itemBuilder: (BuildContext context, int index) {
        return _educationItem(state.educationList[index]);
      },
    );
  }

  /// Widget for create item education list
  Widget _educationItem(EducationModel educationModel) {
    return Column(
      children: <Widget>[
        RaisedButton(
          elevation: 0,
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 60,
                      height: 300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: educationModel.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                              heightFactor: 4.2,
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
                    Container(
                      width: MediaQuery.of(context).size.width - 60,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.black12.withOpacity(0.2),
                        shape: BoxShape.rectangle,
                        borderRadius:
                            BorderRadius.circular(Dimens.dialogRadius),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            unixTimeStampToDateTime(educationModel.publishedAt),
                            style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                                fontFamily: FontsFamily.roboto),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            educationModel.title,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: FontsFamily.roboto,
                                color: Colors.white),
                            textAlign: TextAlign.left,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EducationDetailScreen(
                      id: educationModel.id,
                      educationCollection: kEducationContent,
                      model: educationModel,
                    )));
          },
        ),
      ],
    );
  }
}
