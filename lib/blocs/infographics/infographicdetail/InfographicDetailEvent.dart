import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class InfoGraphicDetailEvent extends Equatable {
  const InfoGraphicDetailEvent();
}

class InfoGraphicDetailLoad extends InfoGraphicDetailEvent {
  final String infographicCollection;
  final String infographicId;

  const InfoGraphicDetailLoad(
      {@required this.infographicCollection, @required this.infographicId});

  @override
  List<Object> get props => <Object>[infographicCollection, infographicId];
}
