import 'package:equatable/equatable.dart';
import 'package:pikobar_flutter/models/MessageModel.dart';

abstract class MessageDetailState extends Equatable {
  const MessageDetailState();

  @override
  List<Object> get props => <Object>[];
}

class InitialMessageDetailState extends MessageDetailState {}

class MessageDetailLoading extends MessageDetailState {}

class MessageDetailLoaded extends MessageDetailState {
  final MessageModel data;

  const MessageDetailLoaded({required this.data});

  @override
  List<Object> get props => <Object>[data];
}
