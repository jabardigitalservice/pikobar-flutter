import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/pcr/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/pcrIndividu/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/rdt/Bloc.dart';
import 'package:pikobar_flutter/blocs/statistics/rdtAntigen/Bloc.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/environment/Environment.dart';
import 'package:pikobar_flutter/screens/home/components/RapidTestDetail.dart';
import 'package:pikobar_flutter/screens/home/components/statistics/StatisticsDetailScreen.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/BasicUtils.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/RemoteConfigHelper.dart';

class Statistics extends StatefulWidget {
  Statistics({Key key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final formatter = new NumberFormat("#,###");
  String urlStatistic = "";
  RemoteConfigLoaded remoteConfigLoaded;
  RapidTestLoaded rapidTestLoaded;
  RapidTestAntigenLoaded rapidTestAntigenLoaded;
  PcrTestLoaded pcrTestLoaded;
  PcrTestIndividuLoaded pcrTestIndividuLoaded;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
          builder: (context, remoteState) {
        return remoteState is RemoteConfigLoaded
            ? BlocBuilder<StatisticsBloc, StatisticsState>(builder:
                (BuildContext context, StatisticsState statisticState) {
                return statisticState is StatisticsLoaded
                    ? statisticState.snapshot.exists
                        ? Column(
                            children: <Widget>[
                              _buildContent(statisticState.snapshot,
                                  remoteState, statisticState),
                              const SizedBox(
                                height: 20,
                              ),
                              _buildRapidTest(remoteState),
                            ],
                          )
                        : _buildLoading()
                    : _buildLoading();
              })
            : _buildLoading();
      }),
    );
  }

  _buildMore(StatisticsLoaded statisticState) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Dictionary.moreDetail,
              style: TextStyle(
                  fontFamily: FontsFamily.roboto,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: ColorBase.green),
            ),
          ],
        ),
      ),
      onTap: () {
        AnalyticsHelper.setLogEvent(Analytics.tappedMoreCaseDataJabar);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StatisticsDetailScreen(
                  remoteConfigLoaded: remoteConfigLoaded,
                  statisticsLoaded: statisticState,
                  rapidTestLoaded: rapidTestLoaded,
                  pcrTestLoaded: pcrTestLoaded,
                  pcrTestIndividuLoaded: pcrTestIndividuLoaded,
                  rapidTestAntigenLoaded: rapidTestAntigenLoaded,
                )));
      },
    );
  }

  _buildRapidTest(RemoteConfigLoaded remoteState) {
    return remoteState.remoteConfig.getBool(FirebaseConfig.rapidTestEnable)
        ? MultiBlocListener(
            listeners: [
              BlocListener<RapidTestBloc, RapidTestState>(
                  listener: (BuildContext context, RapidTestState rapidState) {
                if (rapidState is RapidTestLoaded) {
                  setState(() {
                    this.rapidTestLoaded = rapidState;
                  });
                }
              }),
              BlocListener<RapidTestAntigenBloc, RapidTestAntigenState>(
                  listener: (BuildContext context,
                      RapidTestAntigenState rapidAntigenState) {
                if (rapidAntigenState is RapidTestAntigenLoaded) {
                  setState(() {
                    this.rapidTestAntigenLoaded = rapidAntigenState;
                  });
                }
              }),
              BlocListener<PcrTestBloc, PcrTestState>(
                  listener: (BuildContext context, PcrTestState pcrState) {
                if (pcrState is PcrTestLoaded) {
                  setState(() {
                    this.pcrTestLoaded = pcrState;
                  });
                }
              }),
              BlocListener<PcrTestIndividuBloc, PcrTestIndividuState>(listener:
                  (BuildContext context,
                      PcrTestIndividuState pcrIndividuState) {
                if (pcrIndividuState is PcrTestIndividuLoaded) {
                  setState(() {
                    this.pcrTestIndividuLoaded = pcrIndividuState;
                  });
                }
              })
            ],
            child: BlocBuilder<RapidTestBloc, RapidTestState>(
              builder: (BuildContext context, RapidTestState rapidState) {
                urlStatistic = remoteState.remoteConfig
                    .getString(FirebaseConfig.pikobarUrl);
                return rapidState is RapidTestLoaded
                    ? rapidState.snapshot.exists
                        ? _buildPcrTestBloc(remoteState, rapidState)
                        : buildLoadingRapidTest()
                    : buildLoadingRapidTest();
              },
            ),
          )
        : Container();
  }

  _buildPcrTestBloc(RemoteConfigLoaded remoteState, RapidTestState rapidState) {
    return BlocBuilder<PcrTestBloc, PcrTestState>(
      builder: (BuildContext context, PcrTestState pcrState) {
        this.rapidTestLoaded = rapidState;
        return pcrState is PcrTestLoaded
            ? pcrState.snapshot.exists
                ? _buildRapidTestAntigenBloc(remoteState, rapidState, pcrState)
                : buildLoadingRapidTest()
            : buildLoadingRapidTest();
      },
    );
  }

  _buildRapidTestAntigenBloc(RemoteConfigLoaded remoteState,
      RapidTestState rapidState, PcrTestState pcrState) {
    return BlocBuilder<RapidTestAntigenBloc, RapidTestAntigenState>(
      builder: (BuildContext context, RapidTestAntigenState rapidAntigenState) {
        if (rapidAntigenState is RapidTestAntigenLoaded) {
          this.rapidTestAntigenLoaded = rapidAntigenState;
          return rapidAntigenState.snapshot.exists
              ? _buildPcrTestIndividuBloc(
                  remoteState, rapidState, pcrState, rapidAntigenState)
              : buildLoadingRapidTest();
        } else {
          return buildLoadingRapidTest();
        }
      },
    );
  }

  _buildPcrTestIndividuBloc(
      RemoteConfigLoaded remoteState,
      RapidTestState rapidState,
      PcrTestState pcrState,
      RapidTestAntigenState rapidAntigenState) {
    return BlocBuilder<PcrTestIndividuBloc, PcrTestIndividuState>(
      builder: (BuildContext context, PcrTestIndividuState pcrIndividuState) {
        if (pcrIndividuState is PcrTestIndividuLoaded) {
          this.pcrTestIndividuLoaded = pcrIndividuState;
          return pcrIndividuState.snapshot.exists
              ? buildContentRapidTest(remoteState.remoteConfig, rapidState,
                  pcrState, rapidAntigenState, pcrIndividuState)
              : buildLoadingRapidTest();
        } else {
          return buildLoadingRapidTest();
        }
      },
    );
  }

  _buildLoading() {
    return Container(
      color: Colors.white,
      child: Skeleton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Dictionary.statistics,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontsFamily.lato,
                  fontSize: Dimens.textTitleSize),
            ),
            const SizedBox(height: Dimens.padding),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildContainer(
                    '',
                    Dictionary.positif,
                    Dictionary.positif,
                    '-',
                    4,
                    Dictionary.people,
                    Colors.grey[600],
                    Colors.grey[600],
                    ''),
                const SizedBox(width: 16),
                _buildContainer(
                    '',
                    Dictionary.positif,
                    Dictionary.positif,
                    '-',
                    4,
                    Dictionary.people,
                    Colors.grey[600],
                    Colors.grey[600],
                    ''),
                const SizedBox(width: 16),
                _buildContainer('', Dictionary.die, Dictionary.die, '-', 4,
                    Dictionary.people, Colors.grey[600], Colors.grey[600], ''),
              ],
            ),
            const SizedBox(height: Dimens.padding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildContainer(
                    '',
                    Dictionary.underSupervision,
                    Dictionary.underSupervision,
                    '-',
                    2,
                    Dictionary.people,
                    Colors.grey[600],
                    Colors.grey[600],
                    ''),
                _buildContainer(
                    '',
                    Dictionary.inMonitoring,
                    Dictionary.inMonitoring,
                    '-',
                    2,
                    Dictionary.people,
                    Colors.grey[600],
                    Colors.grey[600],
                    ''),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildContent(DocumentSnapshot data,
      RemoteConfigLoaded remoteConfigLoaded, StatisticsLoaded statisticState) {
    this.remoteConfigLoaded = remoteConfigLoaded;
    final RemoteConfig remoteConfig = remoteConfigLoaded.remoteConfig;
    if (!data.exists)
      return Container(
        child: Center(
          child: Text(Dictionary.errorStatisticsNotExists),
        ),
      );

    // Get label from the remote config
    Map<String, dynamic> labelUpdateTerkini = RemoteConfigHelper.decode(
        remoteConfig: remoteConfig,
        firebaseConfig: FirebaseConfig.labels,
        defaultValue: FirebaseConfig.labelsDefaultValue);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Dictionary.statistics,
                style: TextStyle(
                    color: Color(0xff333333),
                    fontWeight: FontWeight.w600,
                    fontFamily: FontsFamily.lato,
                    fontSize: Dimens.textTitleSize),
              ),
              //_buildMore(statisticState)
            ],
          ),
          const SizedBox(height: 10),
          Text(
            unixTimeStampToCustomDateFormat(
                data['updated_at'].seconds, 'dd MMM yyyy HH:mm'),
            style: TextStyle(
                color: Color(0xff333333),
                fontFamily: FontsFamily.roboto,
                fontSize: Dimens.textSubtitleSize),
          ),
          const SizedBox(height: Dimens.padding),
          _buildConfirmedBox(
              label: labelUpdateTerkini['statistics']['confirmed'],
              caseTotal: '${data['aktif']['jabar']}'),
          const SizedBox(height: Dimens.padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildContainer(
                  '${Environment.iconAssets}circle_plus_yellow.png',
                  labelUpdateTerkini['statistics']['positif'],
                  labelUpdateTerkini['statistics']['positif'],
                  getDataActivePositive(data['aktif']['jabar'],
                      data['sembuh']['jabar'], data['meninggal']['jabar']),
                  4,
                  Dictionary.people,
                  const Color(0xff333333),
                  const Color(0xff333333),
                  getDataProcessPercent(
                      data['aktif']['jabar'],
                      int.parse(getDataActivePositive(
                          data['aktif']['jabar'],
                          data['sembuh']['jabar'],
                          data['meninggal']['jabar'])))),
              const SizedBox(width: 16),
              _buildContainer(
                  '${Environment.iconAssets}circle_check_green.png',
                  labelUpdateTerkini['statistics']['recovered'],
                  labelUpdateTerkini['statistics']['recovered'],
                  '${data['sembuh']['jabar']}',
                  4,
                  Dictionary.people,
                  const Color(0xff333333),
                  const Color(0xff333333),
                  getDataProcessPercent(
                      data['aktif']['jabar'], data['sembuh']['jabar'])),
              const SizedBox(width: 16),
              _buildContainer(
                  '${Environment.iconAssets}circle_cross_red.png',
                  labelUpdateTerkini['statistics']['deaths'],
                  labelUpdateTerkini['statistics']['deaths'],
                  '${data['meninggal']['jabar']}',
                  4,
                  Dictionary.people,
                  const Color(0xff333333),
                  const Color(0xff333333),
                  getDataProcessPercent(
                      data['aktif']['jabar'], data['meninggal']['jabar'])),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLoadingRapidTest() {
    return Card(
      elevation: 0,
      color: const Color(0xffFAFAFA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Skeleton(
                  child: Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: Text(Dictionary.testSummaryTitle,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xff828282),
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.roboto)),
                  ),
                ),
                Skeleton(
                  child: Container(
                    margin: const EdgeInsets.only(top: Dimens.padding, left: 5),
                    child: Text('0',
                        style: TextStyle(
                            fontSize: 22,
                            color: const Color(0xff828282),
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.roboto)),
                  ),
                )
              ],
            ),
            Skeleton(
              child: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildContentRapidTest(
      RemoteConfig remoteConfig,
      RapidTestLoaded rapidTestLoaded,
      PcrTestLoaded pcrTestLoaded,
      RapidTestAntigenLoaded rapidTestAntigenLoaded,
      PcrTestIndividuLoaded pcrTestIndividuLoaded) {
    final DocumentSnapshot documentRapidTest = rapidTestLoaded.snapshot;
    final DocumentSnapshot documentPCR = pcrTestLoaded.snapshot;
    final DocumentSnapshot documentPCRIndividu = pcrTestIndividuLoaded.snapshot;
    final DocumentSnapshot documentRDTAntigen = rapidTestAntigenLoaded.snapshot;

    this.pcrTestLoaded = pcrTestLoaded;
    this.rapidTestAntigenLoaded = rapidTestAntigenLoaded;
    this.pcrTestIndividuLoaded = pcrTestIndividuLoaded;

    final String count = formatter
        .format(documentRapidTest.get('total') +
            documentPCR.get('total') +
            documentPCRIndividu.get('total') +
            documentRDTAntigen.get('total'))
        .replaceAll(',', '.');

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RapidTestDetail(
                    remoteConfig: remoteConfig,
                    document: documentRapidTest,
                    documentPCR: documentPCR,
                    documentPCRIndividu: documentPCRIndividu,
                    documentRdtAntigen: documentRDTAntigen,
                  )),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(0),
        elevation: 0,
        color: const Color(0xffFAFAFA),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 5, right: 20, top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 5),
                    child: Text(Dictionary.testSummaryTitle,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xff333333),
                            fontFamily: FontsFamily.roboto)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: Dimens.padding, left: 5),
                    child: Text(count,
                        style: TextStyle(
                            fontSize: 16,
                            color: const Color(0xff333333),
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsFamily.roboto)),
                  )
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildContainer(
      String image,
      String title,
      String description,
      String count,
      int length,
      String label,
      Color colorTextTitle,
      Color colorNumber,
      String percentage) {
    count = formattedStringNumber(count);

    return Expanded(
      child: InkWell(
        child: Container(
          width: (MediaQuery.of(context).size.width / length),
          padding:
              const EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 15),
          decoration: BoxDecoration(
              color: const Color(0xffFAFAFA),
              borderRadius: BorderRadius.circular(Dimens.borderRadius)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: image != ''
                      ? Image.asset(
                          image,
                          height: 15,
                        )
                      : null),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 5),
                child: Text(title,
                    style: TextStyle(
                        fontSize: 12,
                        color: colorTextTitle,
                        fontFamily: FontsFamily.roboto)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, left: 5),
                child: Text(count,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        color: colorNumber,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.roboto)),
              ),
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }

  _buildConfirmedBox({@required String label, @required caseTotal}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: ColorBase.gradientBlueStatistics),
          borderRadius: BorderRadius.circular(Dimens.borderRadius)),
      child: Stack(
        children: [
          Positioned(
              width: 60,
              height: 60,
              right: 0,
              top: 0,
              child: Image.asset(
                '${Environment.iconAssets}virus_purple.png',
                width: 60,
                height: 60,
              )),
          Container(
            margin: const EdgeInsets.all(Dimens.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontFamily: FontsFamily.roboto,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    formattedStringNumber(caseTotal),
                    style: TextStyle(
                        fontFamily: FontsFamily.roboto,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  bool getStatisticsSwitch(RemoteConfig remoteConfig) {
    if (remoteConfig != null &&
        remoteConfig.getBool(FirebaseConfig.statisticsSwitch) != null) {
      return remoteConfig.getBool(FirebaseConfig.statisticsSwitch);
    } else {
      return false;
    }
  }
}

String getDataProcess(int totalData, int dataDone) {
  final int processData = totalData - dataDone;
  return processData.toString();
}

String getDataActivePositive(int totalData, int dataDone, int dataRecover) {
  final int dataActivePositive = totalData - dataDone - dataRecover;
  return dataActivePositive.toString();
}

String getDataProcessPercent(int totalData, int dataDone) {
  final double processData =
      num.parse(((dataDone / totalData) * 100).toStringAsFixed(2));

  return processData.toString() + '%';
}
