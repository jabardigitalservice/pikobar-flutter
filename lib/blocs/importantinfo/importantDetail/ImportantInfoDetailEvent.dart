import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ImportantInfoDetailEvent extends Equatable {
  const ImportantInfoDetailEvent();
}

class ImportantInfoDetailLoad extends ImportantInfoDetailEvent {

  final String importantInfoId;

  const ImportantInfoDetailLoad({ @required this.importantInfoId});

  @override
  List<Object> get props => <Object>[ importantInfoId];

}
