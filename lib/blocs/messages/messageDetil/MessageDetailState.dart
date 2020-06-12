import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/MessageModel.dart';

abstract class MessageDetailState extends Equatable {
  const MessageDetailState([List props = const <dynamic>[]]);
}

class InitialMessageDetailState extends MessageDetailState {
  @override
  List<Object> get props => [];
}

class MessageDetailLoading extends MessageDetailState {
  @override
  List<Object> get props => [];
}

class MessageDetailLoaded extends MessageDetailState {
  final MessageModel data;

  MessageDetailLoaded({this.data});

  @override
  List<Object> get props => [data];
}
