import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ImportantInfoDetailEvent extends Equatable {
  const ImportantInfoDetailEvent([List props = const <dynamic>[]]);
}

class ImportantInfoDetailLoad extends ImportantInfoDetailEvent {

  final String importantInfoId;

  ImportantInfoDetailLoad({ @required this.importantInfoId});

  @override
  // TODO: implement props
  List<Object> get props => [ importantInfoId];

}
