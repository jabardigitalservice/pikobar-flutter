import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/NewsModel.dart';

abstract class ImportantInfoListEvent extends Equatable {
  const ImportantInfoListEvent();
}

class ImportantInfoListLoad extends ImportantInfoListEvent {
  final String importantInfoCollection;

  const ImportantInfoListLoad(this.importantInfoCollection);

  @override
  List<Object> get props => <Object>[importantInfoCollection];

}

class ImportantInfoListUpdate extends ImportantInfoListEvent {

  final List<NewsModel> importantInfoList;

  ImportantInfoListUpdate(this.importantInfoList);

  @override
  List<Object> get props => [importantInfoList];
}
