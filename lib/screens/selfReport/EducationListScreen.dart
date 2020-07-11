import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/educations/educationList/Bloc.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/EducationModel.dart';
import 'package:pikobar_flutter/screens/selfReport/EducationDetailScreen.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';

class EducationListScreen extends StatefulWidget {
  @override
  _EducationListScreenState createState() => _EducationListScreenState();
}

class _EducationListScreenState extends State<EducationListScreen> {
  // ignore: close_sinks
  EducationListBloc _educationListBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EducationListBloc>(
            create: (BuildContext context) =>
                _educationListBloc = EducationListBloc()
                  ..add(EducationListLoad(Collections.educationContent))),
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
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontsFamily.lato,
                      fontSize: 14.0),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  Dictionary.educationContentdesc,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: FontsFamily.lato,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.left,
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
    return Container(
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Show data image from server
              Container(
                width: 70,
                height: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: educationModel.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                        heightFactor: 4.2, child: CupertinoActivityIndicator()),
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
                padding: const EdgeInsets.only(left: 10.0),
                width: MediaQuery.of(context).size.width - 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Add data title from server to widget text
                    Text(
                      educationModel.title,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: FontsFamily.lato,
                      ),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Add data timestamp from server to widget text
                    Text(
                      unixTimeStampToDateTime(educationModel.publishedAt),
                      style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey[600],
                          fontFamily: FontsFamily.lato),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Function for direct page to screen detail education
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EducationDetailScreen(
                    id: educationModel.id,
                    educationCollection: Collections.educationContent,
                    model: educationModel,
                  )));
        },
      ),
    );
  }
}
