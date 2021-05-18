import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pikobar_flutter/blocs/dailyChart/DailyChartBloc.dart';
import 'package:pikobar_flutter/blocs/locationPermission/location_permission_bloc.dart';
import 'package:pikobar_flutter/blocs/remoteConfig/Bloc.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/components/Skeleton.dart';
import 'package:pikobar_flutter/constants/Analytics.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/constants/collections.dart';
import 'package:pikobar_flutter/constants/firebaseConfig.dart';
import 'package:pikobar_flutter/models/DailyChartModel.dart';
import 'package:pikobar_flutter/repositories/DailyChartRepository.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/FormatDate.dart';
import 'package:pikobar_flutter/utilities/LocationService.dart';
import 'package:recase/recase.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:geolocator_platform_interface/src/models/position.dart'
    as position;

class DailyChart extends StatefulWidget {
  DailyChart({
    Key key,
  }) : super(key: key);

  @override
  _DailyChartState createState() => _DailyChartState();
}

class _DailyChartState extends State<DailyChart> {
  List<dynamic> listCity;
  List<dynamic> filterData;
  String cityId;
  RemoteConfigLoaded remoteConfigLoaded;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemoteConfigBloc, RemoteConfigState>(
        builder: (BuildContext context, RemoteConfigState remoteState) {
      return remoteState is RemoteConfigLoaded
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(kAreas)
                  .orderBy('name')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Container();
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return _buildLoading();
                  default:
                    listCity = snapshot.data.docs.toList();
                    return BlocBuilder<LocationPermissionBloc,
                            LocationPermissionState>(
                        builder: (BuildContext context,
                            LocationPermissionState state) {
                      return state is LocationPermissionLoaded
                          ? state.isGranted
                              ? _buildDailyChartBloc(context, remoteState)
                              : _buildIntroContent()
                          : Container();
                    });
                }
              })
          : _buildLoading();
    });
  }

  Widget _buildLoading() {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(Dimens.contentPadding),
        child: Skeleton(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              Dictionary.dailyChart,
              style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                  fontFamily: FontsFamily.lato,
                  fontSize: Dimens.textTitleSize),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              Dictionary.last7DaysConfirmedData,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: FontsFamily.roboto,
                  fontSize: 12),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                  color: ColorBase.greyContainer,
                  borderRadius: BorderRadius.circular(Dimens.borderRadius)),
            ),
          ]),
        ));
  }

  Widget _buildDailyChartBloc(
      BuildContext context, RemoteConfigLoaded remoteState) {
    // Retrieve api key data from remote config
    final String apiKey = remoteState.remoteConfig
        .getString(FirebaseConfig.dashboardPikobarApiKey);
    return FutureBuilder<position.Position>(
      future:
          Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
      builder:
          (BuildContext context, AsyncSnapshot<position.Position> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return BlocProvider<DailyChartBloc>(
            create: (BuildContext context) =>
                DailyChartBloc(dailyChartRepository: DailyChartRepository())
                  ..add(LoadDailyChart(
                      cityId: snapshot.data,
                      listCityId: listCity,
                      apiKey: apiKey)),
            child: BlocBuilder<DailyChartBloc, DailyChartState>(
                builder: (BuildContext context, DailyChartState state) {
              return state is DailyChartLoading
                  ? _buildLoading()
                  : state is DailyChartLoaded
                      ? buildChart(state.record)
                      : Container();
            }),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildIntroContent() {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(Dimens.contentPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Dictionary.dailyChart,
            style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
                fontFamily: FontsFamily.lato,
                fontSize: Dimens.textTitleSize),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            Dictionary.last7DaysConfirmedData,
            style: TextStyle(
                color: Colors.grey[600],
                fontFamily: FontsFamily.roboto,
                fontSize: 12),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: size.width,
            decoration: BoxDecoration(
                color: ColorBase.greyContainer,
                borderRadius: BorderRadius.circular(Dimens.borderRadius)),
            child: Padding(
              padding: const EdgeInsets.all(Dimens.homeCardMargin),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.only(top: 6),
                          child: Icon(
                            Icons.bar_chart,
                            color: ColorBase.netralGrey,
                          )),
                      const SizedBox(
                        width: Dimens.padding,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Dictionary.introChartTitle,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: FontsFamily.roboto,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(Dictionary.shareChartInfo,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: FontsFamily.roboto,
                                  color: ColorBase.netralGrey)),
                          const SizedBox(
                            height: Dimens.padding,
                          ),
                        ],
                      ),
                    ],
                  ),
                  RoundedButton(
                      title: Dictionary.shareLocation,
                      textStyle: TextStyle(
                          fontFamily: FontsFamily.lato,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      color: ColorBase.green,
                      elevation: 0,
                      onPressed: () async {
                        AnalyticsHelper.setLogEvent(
                            Analytics.tappedShareLocation);
                        await LocationService.initializeBackgroundLocation(
                            context);
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChart(DailyChartModel dailyChartModel) {
    /// Filtering data by last 7 days
    filterData = dailyChartModel.data[0].series
        .where((element) => DateTime.parse(element.tanggal)
            .isAfter(DateTime.now().add(Duration(days: -7))))
        .toList();
    final String firstDay =
        stringDateFormat(filterData.first.tanggal, 'dd MMM yyyy');
    final String lastDay =
        stringDateFormat(filterData.last.tanggal, 'dd MMM yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(Dimens.contentPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Dictionary.dailyChart,
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w600,
                    fontFamily: FontsFamily.lato,
                    fontSize: Dimens.textTitleSize),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    Dictionary.confirmedData,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: FontsFamily.roboto,
                        fontSize: 12),
                  ),
                  Text(
                    firstDay + ' - ' + lastDay,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsFamily.roboto,
                        fontSize: 12),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                ReCase(dailyChartModel.data[0].namaKab).titleCase +
                    ', ' +
                    Dictionary.westJava,
                style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontFamily: FontsFamily.roboto,
                    fontSize: 14),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.38,
          child: SfCartesianChart(
            // Custom chart display
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(
                    fontSize: 10,
                    fontFamily: FontsFamily.roboto,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600]),
                majorGridLines: MajorGridLines(width: 0),
                axisLine: AxisLine(width: 0.2),
                majorTickLines: MajorTickLines(size: 0)),
            primaryYAxis: NumericAxis(
                labelStyle: TextStyle(
                    fontSize: 10,
                    fontFamily: FontsFamily.roboto,
                    color: Colors.grey[600]),
                axisLine: AxisLine(width: 0),
                majorGridLines: MajorGridLines(width: 1, dashArray: [7, 7]),
                majorTickLines: MajorTickLines(size: 0)),
            series: <ChartSeries>[
              // Renders column chart
              ColumnSeries<dynamic, String>(
                  dataLabelSettings: DataLabelSettings(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontFamily: FontsFamily.roboto,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.middle),
                  color: ColorBase.primaryGreen,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      topLeft: Radius.circular(4)),
                  width: 0.6,
                  dataSource: filterData,
                  xValueMapper: (dynamic, int index) =>
                      stringDateFormat(filterData[index].tanggal, 'dd MMM'),
                  yValueMapper: (dynamic, int index) => double.parse(
                      filterData[index].harian.confirmationTotal.toString()))
            ],
            margin: EdgeInsets.symmetric(horizontal: Dimens.contentPadding),
          ),
        ),
      ],
    );
  }
}
