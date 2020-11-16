import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/ImportantinfoModel.dart';

abstract class ImportantInfoListEvent extends Equatable {
  const ImportantInfoListEvent([List props = const <dynamic>[]]);
}

class ImportantInfoListLoad extends ImportantInfoListEvent {
  final String importantInfoCollection;

  ImportantInfoListLoad(this.importantInfoCollection);

  @override
  String toString() {
    return 'Event ImportantInfoListLoad $importantInfoCollection';
  }

  @override
  List<Object> get props => [importantInfoCollection];

}

class ImportantInfoListUpdate extends ImportantInfoListEvent {

  final List<ImportantInfoModel> importantInfoList;

  ImportantInfoListUpdate(this.importantInfoList);

  @override
  String toString() => 'Event ImportantInfoListUpdate';

  @override
  List<Object> get props => [importantInfoList];
}
