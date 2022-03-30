import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/MessageModel.dart';

abstract class MessageListState extends Equatable {
  const MessageListState();

  @override
  List<Object> get props => <Object>[];
}

class InitialMessageListState extends MessageListState {}

class MessageListLoading extends MessageListState {}

class MessageListLoaded extends MessageListState {
  final List<MessageModel> data;

  const MessageListLoaded({this.data});

  @override
  List<Object> get props => <Object>[data];
}
