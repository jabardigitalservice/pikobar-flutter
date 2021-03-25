import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/configs/SharedPreferences/LabelNew.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/models/LabelNewModel.dart';

import 'FormatDate.dart';

class LabelNew {
  List<LabelNewModel> dataLabel = [];
  DateTime currentDay = DateTime.now();
  DateTime yesterday = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
  LabelNewSharedPreference labelNewSharedPreference =
      LabelNewSharedPreference();

  ///Function for insert datalabel to shared preference
  insertDataLabel(var listData, String nameLabel) async {
    String label = await labelNewSharedPreference.getLabelNew(nameLabel);
    if (label != null) {
      dataLabel = LabelNewModel.decode(label);
    }
    listData.forEach((dataLabelNew) {
      var dataDate =
          DateTime.fromMillisecondsSinceEpoch(dataLabelNew is DocumentSnapshot
              ? dataLabelNew.data().containsKey('published_at')
                  ? dataLabelNew['published_at'].seconds * 1000
                  : dataLabelNew['published_date'].seconds * 1000
              : dataLabelNew.publishedAt * 1000);
      if (unixTimeStampToDateWithoutMultiplication(
                  dataDate.millisecondsSinceEpoch) ==
              unixTimeStampToDateWithoutMultiplication(
                  currentDay.millisecondsSinceEpoch) ||
          unixTimeStampToDateWithoutMultiplication(
                  dataDate.millisecondsSinceEpoch) ==
              unixTimeStampToDateWithoutMultiplication(
                  yesterday.millisecondsSinceEpoch)) {
        LabelNewModel labelNewModel = LabelNewModel(
            id: dataLabelNew.id.toString(),
            isRead: '0',
            date: dataLabelNew is DocumentSnapshot
                ? dataLabelNew.data().containsKey('published_at')
                    ? dataLabelNew['published_at'].seconds.toString()
                    : dataLabelNew['published_date'].seconds.toString()
                : dataLabelNew.publishedAt.toString());

        var data =
            dataLabel.where((test) => test.id.contains(labelNewModel.id));

        if (data.isEmpty) {
          dataLabel.add(labelNewModel);
        }
      }
    });

    String encodeData = LabelNewModel.encode(dataLabel);
    await labelNewSharedPreference.setLabelNew(encodeData, nameLabel);
  }

  ///Function for get data from shared preference
  Future<List<LabelNewModel>> getDataLabel(String nameLabel) async {
    String label = await labelNewSharedPreference.getLabelNew(nameLabel);
    if (label != null) {
      dataLabel = LabelNewModel.decode(label);
    }

    return dataLabel;
  }

  ///Function for get all data from shared preference
  Future<int> getAllUnreadDataLabel() async {
    List<String> listNameLabel = [
      Dictionary.labelInfoGraphic,
      Dictionary.labelNews,
      Dictionary.labelVideos,
      Dictionary.labelDocuments
    ];

    int totalUnreadData = 0;

    for (int i = 0; i < listNameLabel.length; i++) {
      String label =
          await labelNewSharedPreference.getLabelNew(listNameLabel[i]);
      if (label != null) {
        dataLabel = LabelNewModel.decode(label);
        dataLabel =
            dataLabel.where((test) => test.isRead.contains('0')).toList();
        totalUnreadData = totalUnreadData + dataLabel.length;
      }
    }

    return totalUnreadData;
  }

  ///Function for check data is new or not
  bool isLabelNew(String id, List<LabelNewModel> dataLabel) {
    var data = dataLabel.where((test) => test.id.contains(id));
    data = data.where((test) => test.isRead.contains('0'));
    return data.isNotEmpty;
  }

  ///Function for update data when read
  readNewInfo(String id, String date, List<LabelNewModel> dataLabel,
      String nameLabel) async {
    if (dataLabel.isNotEmpty) {
      dataLabel[dataLabel.indexWhere((element) => element.id == id)] =
          LabelNewModel(id: id, isRead: '1', date: date);
      String encodeData = LabelNewModel.encode(dataLabel);
      await labelNewSharedPreference.setLabelNew(encodeData, nameLabel);
    }
  }

  ///Function for remove outdate data
  removeData(String nameLabel) async {
    String label = await labelNewSharedPreference.getLabelNew(nameLabel);
    List<LabelNewModel> listDataLabel = [];
    if (label != null) {
      dataLabel = LabelNewModel.decode(label);
      listDataLabel = LabelNewModel.decode(label);

      listDataLabel.forEach((label) {
        var dataDate =
            DateTime.fromMillisecondsSinceEpoch(int.parse(label.date) * 1000);
        if (unixTimeStampToDateWithoutMultiplication(
                    dataDate.millisecondsSinceEpoch) !=
                unixTimeStampToDateWithoutMultiplication(
                    currentDay.millisecondsSinceEpoch) &&
            unixTimeStampToDateWithoutMultiplication(
                    dataDate.millisecondsSinceEpoch) !=
                unixTimeStampToDateWithoutMultiplication(
                    yesterday.millisecondsSinceEpoch)) {
          dataLabel.removeWhere((item) => item.id == label.id);
        }
      });

      String encodeData = LabelNewModel.encode(dataLabel);
      await labelNewSharedPreference.setLabelNew(encodeData, nameLabel);
    }
  }
}
