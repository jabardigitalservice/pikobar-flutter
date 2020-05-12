import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MessageDetailEvent extends Equatable {
  const MessageDetailEvent([List props = const <dynamic>[]]);
}

class MessageDetailLoad extends MessageDetailEvent {
  final messageId;

  MessageDetailLoad({@required this.messageId});

  @override
  // TODO: implement props
  List<Object> get props => [messageId];
}
