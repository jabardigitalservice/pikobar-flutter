import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikobar_flutter/blocs/importantinfo/importantInfoList/Bloc.dart';
import 'package:pikobar_flutter/blocs/importantinfo/importantInfoList/ImportantInfoListBloc.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';
import 'package:pikobar_flutter/screens/news/NewsDetailScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';

class DailyUpdateScreen extends StatefulWidget {
  DailyUpdateScreen({Key key}) : super(key: key);

  @override
  _DailyUpdateScreenState createState() => _DailyUpdateScreenState();
}

class _DailyUpdateScreenState extends State<DailyUpdateScreen> {
  ImportantInfoListBloc newsListBloc;

  @override
  void initState() {
    newsListBloc = BlocProvider.of<ImportantInfoListBloc>(context);
    newsListBloc.add(ImportantInfoListLoad(kImportantInfor));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImportantInfoListBloc, ImportantInfoListState>(
      builder: (context, state) {
        return state is ImpoftantInfoListLoaded
            ? _buildContent(state.imporntantinfoList)
            : Container();
      },
    );
  }

  _buildContent(List<NewsModel> list) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(
                id: Environment.idDailyUpdate,
                news: Dictionary.importantInfo,
                model: list[0]),
          ),
        );

        AnalyticsHelper.setLogEvent(Analytics.tappedDailyUpdate,
            <String, dynamic>{'title': list[0].title});
      },
      child: Container(
        width: (MediaQuery.of(context).size.width),
        margin: EdgeInsets.only(
            left: Dimens.padding,
            right: Dimens.padding,
            top: Dimens.homeCardMargin),
        decoration: BoxDecoration(
            color: ColorBase.greyContainer,
            borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: EdgeInsets.all(Dimens.homeCardMargin),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                        height: 13,
                        child: Image.asset(
                            '${Environment.iconAssets}email_icon.png')),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Dictionary.dailyUpdateSatgasJabar,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: FontsFamily.roboto,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10,
                        ),
                        Text(unixTimeStampToDateWithoutDay(list[0].publishedAt),
                            style: TextStyle(
                                fontSize: 12.0,
                                fontFamily: FontsFamily.roboto,
                                color: ColorBase.netralGrey))
                      ],
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.black,
                )
              ]),
        ),
      ),
    );
  }
}
