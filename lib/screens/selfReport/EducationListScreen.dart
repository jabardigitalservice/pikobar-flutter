import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/educations/educationList/Bloc.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
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
  final ScrollController scrollController;

  const EducationListScreen({Key key, this.scrollController}) : super(key: key);

  @override
  _EducationListScreenState createState() => _EducationListScreenState();
}

class _EducationListScreenState extends State<EducationListScreen> {
  EducationListBloc _educationListBloc;

  ScrollController get _scrollController => widget.scrollController;

  final int _limitMax = 500;
  final int _limitPerPage = 10;

  List<EducationModel> _allDocs = [];
  List<EducationModel> _limitedDocs = [];

  @override
  void initState() {
    super.initState();
    AnalyticsHelper.setCurrentScreen(Analytics.selfReports);

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        await _getMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EducationListBloc>(
      create: (BuildContext context) => _educationListBloc = EducationListBloc()
        ..add(EducationListLoad(kEducationContent, limit: _limitMax)),
      child: BlocListener<EducationListBloc, EducationListState>(
        listener: (context, state) {
          if (state is EducationListLoaded) {
            _allDocs = state.educationList;

            int limit = _allDocs.length > _limitPerPage
                ? _limitPerPage
                : _allDocs.length;

            _limitedDocs = _allDocs.getRange(0, limit).toList();
          }
        },
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
                  return _buildContent(_limitedDocs);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Skeleton(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          decoration: BoxDecoration(
              color: ColorBase.greyContainer,
              borderRadius: BorderRadius.circular(Dimens.borderRadius)),
        ),
      ),
    );
  }

  /// Widget data for show data when loaded from server
  Widget _buildContent(List<EducationModel> listData) {
    int itemCount = listData.length != _allDocs.length
        ? listData.length + 1
        : listData.length;

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      padding: const EdgeInsets.only(bottom: 10.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == listData.length) {
          return CupertinoActivityIndicator();
        }

        return _educationItem(listData[index]);
      },
    );
  }

  /// Widget for create item education list
  Widget _educationItem(EducationModel educationModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: InkWell(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
                child: CachedNetworkImage(
                  imageUrl: educationModel.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                      heightFactor: 4.2, child: CupertinoActivityIndicator()),
                  errorWidget: (context, url, error) => Container(
                      height: MediaQuery.of(context).size.height / 3.3,
                      color: Colors.grey[200],
                      child: Image.asset('${Environment.iconAssets}pikobar.png',
                          fit: BoxFit.fitWidth)),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.borderRadius),
                color: Colors.white,
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: [0.0, 1.0],
                ),
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
                  Container(
                    child: Text(
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
                  ),
                ],
              ),
            )
          ],
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EducationDetailScreen(
                    id: educationModel.id,
                    educationCollection: kEducationContent,
                    model: educationModel,
                  )));
        },
      ),
    );
  }

  /// Load more data to list
  Future<void> _getMoreData() async {
    final nextPage = _limitedDocs.length + _limitPerPage;
    final remains =
        _limitedDocs.length + (_allDocs.length - _limitedDocs.length);
    final limit = _allDocs.length > nextPage ? nextPage : remains;

    _limitedDocs.addAll(_allDocs.getRange(_limitedDocs.length, limit).toList());
    await Future.delayed(Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    super.dispose();
    if (_educationListBloc != null) {
      _educationListBloc.close();
    }
  }
}
