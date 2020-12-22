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


  ///Function for insert datalabel to shared preference
  insertDataLabel(List<DocumentSnapshot> listData, String nameLabel) async {
    String label = await LabelNewSharedPreference.getLabelNew(nameLabel);
    if (label != null) {
      dataLabel = LabelNewModel.decode(label);
    }
    listData.forEach((dataInfographic) {
      var dataDate = DateTime.fromMillisecondsSinceEpoch(
          dataInfographic['published_date'].seconds * 1000);
      if (unixTimeStampToDateWithoutMultiplication(
                  dataDate.millisecondsSinceEpoch) ==
              unixTimeStampToDateWithoutMultiplication(
                  currentDay.millisecondsSinceEpoch) ||
          unixTimeStampToDateWithoutMultiplication(
                  dataDate.millisecondsSinceEpoch) ==
              unixTimeStampToDateWithoutMultiplication(
                  yesterday.millisecondsSinceEpoch)) {
        LabelNewModel labelNewModel = LabelNewModel(
            id: dataInfographic.id.toString(),
            isRead: '0',
            date: dataInfographic['published_date'].seconds.toString());

        var data = dataLabel
            .where((test) => test.id.toLowerCase().contains(labelNewModel.id));

        if (data.isEmpty) {
          dataLabel.add(labelNewModel);
        }
      }
    });

    String encodeData = LabelNewModel.encode(dataLabel);
    await LabelNewSharedPreference.setLabelNew(encodeData, nameLabel);
  }

  ///Function for get data from shared preference
  Future<List<LabelNewModel>> getDataLabel(String nameLabel) async {
    String label = await LabelNewSharedPreference.getLabelNew(nameLabel);
    if (label != null) {
      dataLabel = LabelNewModel.decode(label);
    }

    return dataLabel;
  }

  ///Function for check data is new or not
  bool isLabelNew(String id, List<LabelNewModel> dataLabel) {
    var data = dataLabel.where((test) => test.id.toLowerCase().contains(id));
    data = data.where((test) => test.isRead.toLowerCase().contains('0'));
    return data.isNotEmpty;
  }

  ///Function for update data when read
  readNewInfo(String id, String date, List<LabelNewModel> dataLabel) async {
    if (dataLabel.isNotEmpty) {
      dataLabel[dataLabel.indexWhere((element) => element.id == id)] =
          LabelNewModel(id: id, isRead: '1', date: date);
      String encodeData = LabelNewModel.encode(dataLabel);
      await LabelNewSharedPreference.setLabelNew(
          encodeData, Dictionary.labelInfoGraphic);
    }
  }

  ///Function for remove outdate data
  removeData(String nameLabel) async {
    String label = await LabelNewSharedPreference.getLabelNew(nameLabel);
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
                    currentDay.millisecondsSinceEpoch) ||
            unixTimeStampToDateWithoutMultiplication(
                    dataDate.millisecondsSinceEpoch) !=
                unixTimeStampToDateWithoutMultiplication(
                    yesterday.millisecondsSinceEpoch)) {
          dataLabel.removeWhere((item) => item.id == label.id);
        }
      });

      String encodeData = LabelNewModel.encode(dataLabel);
      await LabelNewSharedPreference.setLabelNew(encodeData, nameLabel);
    }
  }
}
