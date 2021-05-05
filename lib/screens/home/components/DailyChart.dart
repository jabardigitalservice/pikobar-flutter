import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pikobar_flutter/components/CustomAppBar.dart';
import 'package:pikobar_flutter/constants/Colors.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/constants/Dimens.dart';
import 'package:pikobar_flutter/constants/FontsFamily.dart';
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
    "status_code": 200,
    "data": {
      "metadata": {"last_update": null},
      "content": [
        {
          "tanggal": "2021-04-22",
          "kode_prov": "32",
          "nama_prov": "Jawa Barat",
          "SUSPECT": 542,
          "suspect_diisolasi": 37,
          "suspect_discarded": 505,
          "CLOSECONTACT": 1394,
          "closecontact_dikarantina": 69,
          "closecontact_discarded": 1325,
          "probable_discarded": 12,
          "probable_diisolasi": 0,
          "probable_meninggal": 1,
          "CONFIRMATION": 1358,
          "confirmation_diisolasi": 0,
          "confirmation_selesai": 1338,
          "confirmation_meninggal": 28,
          "suspect_meninggal_harian": 0,
          "closecontact_meninggal_harian": 0
        },
        {
          "tanggal": "2021-04-23",
          "kode_prov": "32",
          "nama_prov": "Jawa Barat",
          "SUSPECT": 414,
          "suspect_diisolasi": 48,
          "suspect_discarded": 366,
          "CLOSECONTACT": 368,
          "closecontact_dikarantina": 14,
          "closecontact_discarded": 354,
          "probable_discarded": 6,
          "probable_diisolasi": 0,
          "probable_meninggal": 1,
          "CONFIRMATION": 1066,
          "confirmation_diisolasi": 12,
          "confirmation_selesai": 1031,
          "confirmation_meninggal": 23,
          "suspect_meninggal_harian": 0,
          "closecontact_meninggal_harian": 0
        },
        {
          "tanggal": "2021-04-24",
          "kode_prov": "32",
          "nama_prov": "Jawa Barat",
          "SUSPECT": 0,
          "suspect_diisolasi": 0,
          "suspect_discarded": 0,
          "CLOSECONTACT": 0,
          "closecontact_dikarantina": 0,
          "closecontact_discarded": 0,
          "probable_discarded": 0,
          "probable_diisolasi": 0,
          "probable_meninggal": 0,
          "CONFIRMATION": 630,
          "confirmation_diisolasi": 0,
          "confirmation_selesai": 990,
          "confirmation_meninggal": 23,
          "suspect_meninggal_harian": 0,
          "closecontact_meninggal_harian": 0
        },
        {
          "tanggal": "2021-04-25",
          "kode_prov": "32",
          "nama_prov": "Jawa Barat",
          "SUSPECT": 274,
          "suspect_diisolasi": 21,
          "suspect_discarded": 253,
          "CLOSECONTACT": 1074,
          "closecontact_dikarantina": 126,
          "closecontact_discarded": 948,
          "probable_discarded": 13,
          "probable_diisolasi": 0,
          "probable_meninggal": 0,
          "CONFIRMATION": 683,
          "confirmation_diisolasi": 279,
          "confirmation_selesai": 397,
          "confirmation_meninggal": 7,
          "suspect_meninggal_harian": 0,
          "closecontact_meninggal_harian": 0
        },
        {
          "tanggal": "2021-04-26",
          "kode_prov": "32",
          "nama_prov": "Jawa Barat",
          "SUSPECT": 874,
          "suspect_diisolasi": 0,
          "suspect_discarded": 876,
          "CLOSECONTACT": 1308,
          "closecontact_dikarantina": 77,
          "closecontact_discarded": 1231,
          "probable_discarded": 7,
          "probable_diisolasi": 3,
          "probable_meninggal": 4,
          "CONFIRMATION": 1941,
          "confirmation_diisolasi": 1090,
          "confirmation_selesai": 835,
          "confirmation_meninggal": 16,
          "suspect_meninggal_harian": 0,
          "closecontact_meninggal_harian": 0
        },
        {
          "tanggal": "2021-04-27",
          "kode_prov": "32",
          "nama_prov": "Jawa Barat",
          "SUSPECT": 142,
          "suspect_diisolasi": 19,
          "suspect_discarded": 123,
          "CLOSECONTACT": 430,
          "closecontact_dikarantina": 0,
          "closecontact_discarded": 622,
          "probable_discarded": 5,
          "probable_diisolasi": 0,
          "probable_meninggal": 1,
          "CONFIRMATION": 1164,
          "confirmation_diisolasi": 301,
          "confirmation_selesai": 846,
          "confirmation_meninggal": 17,
          "suspect_meninggal_harian": 0,
          "closecontact_meninggal_harian": 0
        },
        {
          "tanggal": "2021-04-28",
          "kode_prov": "32",
          "nama_prov": "Jawa Barat",
          "SUSPECT": 319,
          "suspect_diisolasi": 205,
          "suspect_discarded": 114,
          "CLOSECONTACT": 725,
          "closecontact_dikarantina": 112,
          "closecontact_discarded": 613,
          "probable_discarded": 5,
          "probable_diisolasi": 0,
          "probable_meninggal": 1,
          "CONFIRMATION": 1354,
          "confirmation_diisolasi": 309,
          "confirmation_selesai": 1031,
          "confirmation_meninggal": 14,
          "suspect_meninggal_harian": 0,
          "closecontact_meninggal_harian": 0
        }
      ]
    }
  };

  @override
  Widget build(BuildContext context) {
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
                  dataSource: dataDummy['data']['content'],
                  xValueMapper: (dynamic, index) => DateFormat('dd MMM', 'id')
                      .format(DateTime.parse(
                          dataDummy['data']['content'][index]['tanggal']))
                      .toString(),
                  yValueMapper: (dynamic, index) => double.parse(
                      dataDummy['data']['content'][index]['CLOSECONTACT']
                          .toString()))
            ],
            margin: EdgeInsets.symmetric(horizontal: Dimens.contentPadding),
          ),
        ),
      ],
    );
  }
}
