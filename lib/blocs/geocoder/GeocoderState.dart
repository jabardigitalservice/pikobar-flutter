import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class GeocoderState extends Equatable {
  GeocoderState([List props = const <dynamic>[]]);
}

class GeocoderStateInitial extends GeocoderState {
  @override
  List<Object> get props => [];
}

class GeocoderLoading extends GeocoderState {
  @override
  String toString() => 'State GeocoderLoading';

  @override
  List<Object> get props => [];
}

class GeocoderLoaded extends GeocoderState {
  final String address;

  GeocoderLoaded({this.address});

  @override
  String toString() => 'State GeocoderLoaded';

  @override
  List<Object> get props => [address];
}

class GeocoderFailure extends GeocoderState {
  final String error;

  GeocoderFailure({@required this.error});

  @override
  String toString() => 'State GeocoderFailure{error: $error}';

  @override
  List<Object> get props => [error];
}
