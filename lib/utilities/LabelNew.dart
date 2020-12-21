import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:pikobar_flutter/configs/SharedPreferences/LabelNew.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/models/LabelNewModel.dart';

class LabelNew {
  DateTime currentDay = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 2);
  DateTime yesterday = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 3);
  List<LabelNewModel> dataLabel = [];

// DateTime currentDay = DateTime.now();
//   // DateTime yesterday = DateTime(
//   //     DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);

  insertDataLabel(List<DocumentSnapshot> listData, String nameLabel) async {
    String label = await LabelNewSharedPreference.getLabelNew(nameLabel);
    if (label != null) {
      dataLabel = LabelNewModel.decode(label);
    }
    listData.forEach((dataInfographic) {
      var dataDate = DateTime.fromMillisecondsSinceEpoch(
          dataInfographic['published_date'].seconds * 1000);
      if (dataDate.day == currentDay.day &&
              dataDate.month == currentDay.month &&
              dataDate.year == currentDay.year ||
          dataDate.day == yesterday.day &&
              dataDate.month == yesterday.month &&
              dataDate.year == yesterday.year) {
        LabelNewModel labelNewModel =
            LabelNewModel(id: dataInfographic.id.toString(), isRead: '0');

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

  Future<List<LabelNewModel>> getDataLabel(String nameLabel) async {
    String label = await LabelNewSharedPreference.getLabelNew(nameLabel);
    if (label != null) {
      dataLabel = LabelNewModel.decode(label);
    }

    return dataLabel;
  }

  bool isLabelNew(String id, List<LabelNewModel> dataLabel) {
    var data = dataLabel.where((test) => test.id.toLowerCase().contains(id));
    data = data.where((test) => test.isRead.toLowerCase().contains('0'));
    return data.isNotEmpty;
  }

  readNewInfo(String id, List<LabelNewModel> dataLabel) async {
    if (dataLabel.isNotEmpty) {
      for (int i = 0; i < dataLabel.length; i++) {
        if (dataLabel[i].id == id) {
          dataLabel[i] = LabelNewModel(id: id, isRead: '1');
        }
      }
      String encodeData = LabelNewModel.encode(dataLabel);
      await LabelNewSharedPreference.setLabelNew(
          encodeData, Dictionary.labelInfoGraphic);
    }
  }
}
