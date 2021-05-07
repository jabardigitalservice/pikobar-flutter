import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pikobar_flutter/blocs/zonation/zonation_cubit.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/components/DialogTextOnly.dart';
import 'package:pikobar_flutter/components/RoundedButton.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
import 'package:pikobar_flutter/utilities/AnalyticsHelper.dart';
import 'package:pikobar_flutter/utilities/flushbar_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DailyChart extends StatefulWidget {
  DailyChart({
    Key key,
  }) : super(key: key);

  @override
  _DailyChartState createState() => _DailyChartState();
}

class _DailyChartState extends State<DailyChart> {
  Map<String, dynamic> dataDummy = {
    "message": "Get data successfull",
    "error": 0,
    "metadata": {
      "data_source": "Dinas Kesehatan Provinsi Jawa Barat",
      "parameter": {
        "kode_kab": "3273",
        "kode_kec": "32730101",
        "sort": [
          "kode_kab:asc",
          "nama_kab:asc",
          "persentasi:desc",
          "persentasi_confirmation_total:asc",
          "persentasi_confirmation_diisolasi:asc",
          "persentasi_confirmation_meninggal:asc",
          "persentasi_confirmation_selesai:asc"
        ],
        "wilayah": ["provinsi", "kota", "kecamatan", "kelurahan"],
        "kode_kel": "3273010001",
        "tanggal": ["pusat", "lab"]
      },
      "last_update": "2021-05-04"
    },
    "tren": {},
    "data": [
      {
        "series": [
          {
            "kumulatif": {
              "suspect_diisolasi": -3408,
              "probable_meninggal": 29,
              "suspect_meninggal": 121,
              "closecontact_discarded": 15181,
              "closecontact_total": 0,
              "confirmation_meninggal": 43,
              "confirmation_selesai": 9016,
              "probable_total": 0,
              "probable_discarded": 0,
              "suspect_discarded": 3287,
              "closecontact_dikarantina": -15181,
              "probable_diisolasi": -29,
              "suspect_total": 0,
              "confirmation_diisolasi": 1103,
              "confirmation_total": 10162
            },
            "kode_kab": "3204",
            "nama_kab": "KAB. BANDUNG",
            "harian": {
              "suspect_diisolasi": 0,
              "probable_total": 0,
              "probable_meninggal": 0,
              "suspect_meninggal": 0,
              "closecontact_discarded": 0,
              "probable_ratarata": 0.0,
              "closecontact_ratarata": 0.0,
              "closecontact_total": 0,
              "suspect_ratarata": 0.0,
              "confirmation_meninggal": 0,
              "confirmation_total": 47,
              "confirmation_ratarata": 36.0,
              "probable_discarded": 0,
              "suspect_discarded": 0,
              "closecontact_dikarantina": 0,
              "probable_diisolasi": 0,
              "suspect_total": 0,
              "confirmation_diisolasi": 39,
              "confirmation_selesai": 8
            },
            "tanggal": "2021-04-29"
          },
          {
            "kumulatif": {
              "suspect_diisolasi": -3408,
              "probable_meninggal": 29,
              "suspect_meninggal": 121,
              "closecontact_discarded": 15181,
              "closecontact_total": 0,
              "confirmation_meninggal": 43,
              "confirmation_selesai": 9032,
              "probable_total": 0,
              "probable_discarded": 0,
              "suspect_discarded": 3287,
              "closecontact_dikarantina": -15181,
              "probable_diisolasi": -29,
              "suspect_total": 0,
              "confirmation_diisolasi": 1103,
              "confirmation_total": 10178
            },
            "kode_kab": "3204",
            "nama_kab": "KAB. BANDUNG",
            "harian": {
              "suspect_diisolasi": 0,
              "probable_total": 0,
              "probable_meninggal": 0,
              "suspect_meninggal": 0,
              "closecontact_discarded": 0,
              "probable_ratarata": 0.0,
              "closecontact_ratarata": 0.0,
              "closecontact_total": 0,
              "suspect_ratarata": 0.0,
              "confirmation_meninggal": 0,
              "confirmation_total": 16,
              "confirmation_ratarata": 36.0,
              "probable_discarded": 0,
              "suspect_discarded": 0,
              "closecontact_dikarantina": 0,
              "probable_diisolasi": 0,
              "suspect_total": 0,
              "confirmation_diisolasi": 0,
              "confirmation_selesai": 16
            },
            "tanggal": "2021-04-30"
          },
          {
            "kumulatif": {
              "suspect_diisolasi": -3408,
              "probable_meninggal": 29,
              "suspect_meninggal": 121,
              "closecontact_discarded": 15181,
              "closecontact_total": 0,
              "confirmation_meninggal": 43,
              "confirmation_selesai": 9037,
              "probable_total": 0,
              "probable_discarded": 0,
              "suspect_discarded": 3287,
              "closecontact_dikarantina": -15181,
              "probable_diisolasi": -29,
              "suspect_total": 0,
              "confirmation_diisolasi": 1107,
              "confirmation_total": 10187
            },
            "kode_kab": "3204",
            "nama_kab": "KAB. BANDUNG",
            "harian": {
              "suspect_diisolasi": 0,
              "probable_total": 0,
              "probable_meninggal": 0,
              "suspect_meninggal": 0,
              "closecontact_discarded": 0,
              "probable_ratarata": 0.0,
              "closecontact_ratarata": 0.0,
              "closecontact_total": 0,
              "suspect_ratarata": 0.0,
              "confirmation_meninggal": 0,
              "confirmation_total": 9,
              "confirmation_ratarata": 29.43,
              "probable_discarded": 0,
              "suspect_discarded": 0,
              "closecontact_dikarantina": 0,
              "probable_diisolasi": 0,
              "suspect_total": 0,
              "confirmation_diisolasi": 4,
              "confirmation_selesai": 5
            },
            "tanggal": "2021-05-01"
          },
          {
            "kumulatif": {
              "suspect_diisolasi": -3410,
              "probable_meninggal": 29,
              "suspect_meninggal": 121,
              "closecontact_discarded": 15181,
              "closecontact_total": 0,
              "confirmation_meninggal": 43,
              "confirmation_selesai": 9061,
              "probable_total": 0,
              "probable_discarded": 0,
              "suspect_discarded": 3289,
              "closecontact_dikarantina": -15181,
              "probable_diisolasi": -29,
              "suspect_total": 0,
              "confirmation_diisolasi": 1118,
              "confirmation_total": 10222
            },
            "kode_kab": "3204",
            "nama_kab": "KAB. BANDUNG",
            "harian": {
              "suspect_diisolasi": -2,
              "probable_total": 0,
              "probable_meninggal": 0,
              "suspect_meninggal": 0,
              "closecontact_discarded": 0,
              "probable_ratarata": 0.0,
              "closecontact_ratarata": 0.0,
              "closecontact_total": 0,
              "suspect_ratarata": 0.0,
              "confirmation_meninggal": 0,
              "confirmation_total": 35,
              "confirmation_ratarata": 34.43,
              "probable_discarded": 0,
              "suspect_discarded": 2,
              "closecontact_dikarantina": 0,
              "probable_diisolasi": 0,
              "suspect_total": 0,
              "confirmation_diisolasi": 11,
              "confirmation_selesai": 24
            },
            "tanggal": "2021-05-02"
          },
          {
            "kumulatif": {
              "suspect_diisolasi": -3410,
              "probable_meninggal": 29,
              "suspect_meninggal": 121,
              "closecontact_discarded": 15181,
              "closecontact_total": 0,
              "confirmation_meninggal": 43,
              "confirmation_selesai": 9067,
              "probable_total": 0,
              "probable_discarded": 0,
              "suspect_discarded": 3289,
              "closecontact_dikarantina": -15181,
              "probable_diisolasi": -29,
              "suspect_total": 0,
              "confirmation_diisolasi": 1137,
              "confirmation_total": 10247
            },
            "kode_kab": "3204",
            "nama_kab": "KAB. BANDUNG",
            "harian": {
              "suspect_diisolasi": 0,
              "probable_total": 0,
              "probable_meninggal": 0,
              "suspect_meninggal": 0,
              "closecontact_discarded": 0,
              "probable_ratarata": 0.0,
              "closecontact_ratarata": 0.0,
              "closecontact_total": 0,
              "suspect_ratarata": 0.0,
              "confirmation_meninggal": 0,
              "confirmation_total": 25,
              "confirmation_ratarata": 36.57,
              "probable_discarded": 0,
              "suspect_discarded": 0,
              "closecontact_dikarantina": 0,
              "probable_diisolasi": 0,
              "suspect_total": 0,
              "confirmation_diisolasi": 19,
              "confirmation_selesai": 6
            },
            "tanggal": "2021-05-03"
          },
          {
            "kumulatif": {
              "suspect_diisolasi": -3410,
              "probable_meninggal": 29,
              "suspect_meninggal": 121,
              "closecontact_discarded": 15181,
              "closecontact_total": 0,
              "confirmation_meninggal": 43,
              "confirmation_selesai": 9090,
              "probable_total": 0,
              "probable_discarded": 0,
              "suspect_discarded": 3289,
              "closecontact_dikarantina": -15181,
              "probable_diisolasi": -29,
              "suspect_total": 0,
              "confirmation_diisolasi": 1118,
              "confirmation_total": 10251
            },
            "kode_kab": "3204",
            "nama_kab": "KAB. BANDUNG",
            "harian": {
              "suspect_diisolasi": 0,
              "probable_total": 0,
              "probable_meninggal": 0,
              "suspect_meninggal": 0,
              "closecontact_discarded": 0,
              "probable_ratarata": 0.0,
              "closecontact_ratarata": 0.0,
              "closecontact_total": 0,
              "suspect_ratarata": 0.0,
              "confirmation_meninggal": 0,
              "confirmation_total": 4,
              "confirmation_ratarata": 28.14,
              "probable_discarded": 0,
              "suspect_discarded": 0,
              "closecontact_dikarantina": 0,
              "probable_diisolasi": 0,
              "suspect_total": 0,
              "confirmation_diisolasi": -19,
              "confirmation_selesai": 23
            },
            "tanggal": "2021-05-04"
          },
          {
            "kumulatif": {
              "suspect_diisolasi": -3410,
              "probable_meninggal": 29,
              "suspect_meninggal": 121,
              "closecontact_discarded": 15181,
              "closecontact_total": 0,
              "confirmation_meninggal": 43,
              "confirmation_selesai": 9090,
              "probable_total": 0,
              "probable_discarded": 0,
              "suspect_discarded": 3289,
              "closecontact_dikarantina": -15181,
              "probable_diisolasi": -29,
              "suspect_total": 0,
              "confirmation_diisolasi": 1118,
              "confirmation_total": 10251
            },
            "kode_kab": "3204",
            "nama_kab": "KAB. BANDUNG",
            "harian": {
              "suspect_diisolasi": 0,
              "probable_total": 0,
              "probable_meninggal": 0,
              "suspect_meninggal": 0,
              "closecontact_discarded": 0,
              "probable_ratarata": 0.0,
              "closecontact_ratarata": 0.0,
              "closecontact_total": 0,
              "suspect_ratarata": 0.0,
              "confirmation_meninggal": 0,
              "confirmation_total": 0,
              "confirmation_ratarata": 19.43,
              "probable_discarded": 0,
              "suspect_discarded": 0,
              "closecontact_dikarantina": 0,
              "probable_diisolasi": 0,
              "suspect_total": 0,
              "confirmation_diisolasi": 0,
              "confirmation_selesai": 0
            },
            "tanggal": "2021-05-05"
          },
          {
            "kumulatif": {
              "suspect_diisolasi": -3410,
              "probable_meninggal": 29,
              "suspect_meninggal": 121,
              "closecontact_discarded": 15181,
              "closecontact_total": 0,
              "confirmation_meninggal": 43,
              "confirmation_selesai": 9090,
              "probable_total": 0,
              "probable_discarded": 0,
              "suspect_discarded": 3289,
              "closecontact_dikarantina": -15181,
              "probable_diisolasi": -29,
              "suspect_total": 0,
              "confirmation_diisolasi": 1118,
              "confirmation_total": 10251
            },
            "kode_kab": "3204",
            "nama_kab": "KAB. BANDUNG",
            "harian": {
              "suspect_diisolasi": 0,
              "probable_total": 0,
              "probable_meninggal": 0,
              "suspect_meninggal": 0,
              "closecontact_discarded": 0,
              "probable_ratarata": 0.0,
              "closecontact_ratarata": 0.0,
              "closecontact_total": 0,
              "suspect_ratarata": 0.0,
              "confirmation_meninggal": 0,
              "confirmation_total": 0,
              "confirmation_ratarata": 12.71,
              "probable_discarded": 0,
              "suspect_discarded": 0,
              "closecontact_dikarantina": 0,
              "probable_diisolasi": 0,
              "suspect_total": 0,
              "confirmation_diisolasi": 0,
              "confirmation_selesai": 0
            },
            "tanggal": "2021-05-06"
          }
        ],
        "kode_kab": "3204",
        "nama_kab": "KAB. BANDUNG",
        "tren": {
          "confirmation_meninggal": {
            "conclusion": "Sama",
            "selisih": 0,
            "kemarin": 0,
            "sekarang": 0,
            "persentasi": 0.0
          },
          "confirmation_ratarata_minggu_kemarin": 4,
          "persentasi": -100.0,
          "conclusion": "Baik",
          "confirmation_total": {
            "conclusion": "Baik",
            "selisih": -4,
            "kemarin": 4,
            "sekarang": 0,
            "persentasi": -100.0
          },
          "selisih": -4,
          "confirmation_selesai": {
            "conclusion": "Sama",
            "selisih": 0,
            "kemarin": 23,
            "sekarang": 23,
            "persentasi": 0.0
          },
          "confirmation_diisolasi": {
            "conclusion": "Baik",
            "selisih": 19,
            "kemarin": -19,
            "sekarang": 0,
            "persentasi": -100.0
          },
          "confirmation_ratarata_minggu_ini": 0
        }
      }
    ]
  };

  Flushbar _flushbar;
  List<dynamic> filterData;
  @override
  void initState() {
    filterData = dataDummy['data'][0]['series']
        .where((element) => DateTime.parse(element['tanggal'])
            .isAfter(DateTime.now().add(Duration(days: -7))))
        .toList();
    print(filterData.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildChart();
  }

  Widget _buildIntroContent() {
    final Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      margin: const EdgeInsets.only(
          left: Dimens.padding,
          right: Dimens.padding,
          top: Dimens.homeCardMargin),
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
                onPressed: null)
          ],
        ),
      ),
    );
  }

  Widget buildChart() {
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
              Text(
                'Data Terkonfirmasi 26 Apr -2021 - 2 Mei 2021',
                style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: FontsFamily.roboto,
                    fontSize: 12),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Kota Bandung, Jawa barat',
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
                  xValueMapper: (dynamic, index) => DateFormat('dd MMM', 'id')
                      .format(DateTime.parse(filterData[index]['tanggal']))
                      .toString(),
                  yValueMapper: (dynamic, index) => double.parse(
                      filterData[index]['harian']['confirmation_total']
                          .toString()))
            ],
            margin: EdgeInsets.symmetric(horizontal: Dimens.contentPadding),
          ),
        ),
      ],
    );
  }
}
