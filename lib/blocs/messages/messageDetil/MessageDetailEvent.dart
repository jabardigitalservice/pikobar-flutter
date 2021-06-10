import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MessageDetailEvent extends Equatable {
  const MessageDetailEvent();

  @override
  List<Object> get props => <Object>[];
}

class MessageDetailLoad extends MessageDetailEvent {
  final String messageId;

  const MessageDetailLoad({@required this.messageId});

  @override
  List<Object> get props => <Object>[messageId];
}
