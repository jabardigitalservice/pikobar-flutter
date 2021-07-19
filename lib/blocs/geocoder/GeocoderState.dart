import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GeocoderState extends Equatable {
  const GeocoderState();

  @override
  List<Object> get props => <Object>[];
}

class GeocoderStateInitial extends GeocoderState {}

class GeocoderLoading extends GeocoderState {}

class GeocoderLoaded extends GeocoderState {
  final String address;

  const GeocoderLoaded({this.address});

  @override
  List<Object> get props => <Object>[address];
}

class GeocoderFailure extends GeocoderState {
  final String error;

  const GeocoderFailure({@required this.error});

  @override
  String toString() => 'State GeocoderFailure{error: $error}';

  @override
  List<Object> get props => <Object>[error];
}
