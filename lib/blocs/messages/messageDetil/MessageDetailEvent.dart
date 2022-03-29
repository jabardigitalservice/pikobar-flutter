import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class MessageDetailEvent extends Equatable {
  const MessageDetailEvent();

  @override
  List<Object> get props => <Object>[];
}

class MessageDetailLoad extends MessageDetailEvent {
  final String messageId, collection, tableName;

  const MessageDetailLoad(
      {@required this.messageId,
      @required this.collection,
      @required this.tableName});

  @override
  List<Object> get props => <Object>[messageId, collection, tableName];
}
