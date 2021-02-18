import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class InfoGraphicDetailEvent extends Equatable {
  const InfoGraphicDetailEvent([List props = const <dynamic>[]]);
}

class InfoGraphicDetailLoad extends InfoGraphicDetailEvent {
  final String infographicCollection;
  final String infographicId;

  InfoGraphicDetailLoad(
      {@required this.infographicCollection, @required this.infographicId});

  @override
  // TODO: implement props
  List<Object> get props => [infographicCollection, infographicId];
}
