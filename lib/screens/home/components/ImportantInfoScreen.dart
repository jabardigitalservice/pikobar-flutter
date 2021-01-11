import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/importantinfo/importantInfoList/Bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/Navigation.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/ImportantinfoModel.dart';
import 'package:pikobar_flutter/screens/importantInfo/ImportantInfoDetailScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/constants/Colors.dart' as clr;

class ImportantInfoScreen extends StatefulWidget {
  final int maxLength;

  ImportantInfoScreen({this.maxLength});

  @override
  _ImportantInfoScreenState createState() => _ImportantInfoScreenState();
}

class _ImportantInfoScreenState extends State<ImportantInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
        builder: (context, state) {
          return  state is RemoteConfigLoaded ?
          state.remoteConfig != null &&
              state.remoteConfig
                          .getBool(FirebaseConfig.importantinfoStatusVisible) !=
                      null &&
              state.remoteConfig
                      .getBool(FirebaseConfig.importantinfoStatusVisible)
              ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.maxLength != null
                    ? Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 10.0, top: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        Dictionary.importantInfo,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: FontsFamily.productSans,
                            fontSize: 16.0),
                      ),
                      InkWell(
                        child: Text(
                          Dictionary.more,
                          style: TextStyle(
                              color: Color(0xFF828282),
                              fontWeight: FontWeight.w600,
                              fontFamily: FontsFamily.productSans,
                              fontSize: 14.0),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context,
                              NavigationConstrants.ImportantInfoList);

                          AnalyticsHelper.setLogEvent(
                              Analytics.tappedImportantInfoMore);
                        },
                      ),
                    ],
                  ),
                )
                    : Container(),
                BlocBuilder<ImportantInfoListBloc, ImportantInfoListState>(
                  builder: (context, state) {
                    return state is ImpoftantInfoListLoaded
                        ? widget.maxLength != null
                        // ? _buildContent(state.imporntantinfoList)
                        // : _buildContentList(state.imporntantinfoList)
                        : _buildLoading();
                  },
                )
              ],
            ),
          )
              : Container() : Container();
        });
  }

  _buildContent(List<ImportantInfoModel> list) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: list.length > 3 ? 3 : list.length,
            padding: const EdgeInsets.only(bottom: 10.0),
            itemBuilder: (BuildContext context, int index) {
              return designImportantInfoHome(list[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget designImportantInfoHome(ImportantInfoModel data) {
    return GestureDetector(
      child: Container(
          height: 80.0,
          margin: EdgeInsets.only(top: 10.0),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 75.0, 10.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: clr.ColorBase.gradientGreen),
              borderRadius: BorderRadius.circular(5.0)),
          child: Text(
            data.title,
            maxLines: 3,
            overflow: TextOverflow.clip,
            style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          )),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImportantInfoDetailScreen(id: data.id),
          ),
        );
        AnalyticsHelper.setLogEvent(Analytics.tappedImportantInfoDetail,
            <String, dynamic>{
          'id': data.id,
          'title': data.title.length < 100 ? data.title : data.title.substring(0, 100)});
      },
    );
  }

  Widget designListImportantInfo(ImportantInfoModel data) {
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          elevation: 0,
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.only(left: 5, right: 5, top: 17, bottom: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 70,
                  height: 75,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: data.image,
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
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.title,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                     SizedBox(
                       height: 2,
                     ),
                      Container(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                unixTimeStampToDate(data.publishedAt),
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.grey),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImportantInfoDetailScreen(id: data.id),
              ),
            );
            AnalyticsHelper.setLogEvent(Analytics.tappedImportantInfoDetail,
                <String, dynamic>{
                  'id': data.id,
                  'title': data.title.length < 100 ? data.title : data.title.substring(0, 100)});
          },
        ),
      ),
    );
  }

  _buildContentList(List<ImportantInfoModel> list) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      padding: const EdgeInsets.only(bottom: 10.0),
      itemBuilder: (BuildContext context, int index) {
        return designListImportantInfo(list[index]);
      },
    );
  }

  _buildLoading() {
    return Container(
      padding: EdgeInsets.fromLTRB(Dimens.padding, 10.0, Dimens.padding, 10.0),
      color: Colors.white,
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.maxLength != null ? 3 : 10,
          itemBuilder: (context, index) {
            return Skeleton(
                child: Container(
                    height: 75.0,
                    margin: EdgeInsets.only(top: 10.0),
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 75.0, 10.0),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5.0))));
          }),
    );
  }
}
