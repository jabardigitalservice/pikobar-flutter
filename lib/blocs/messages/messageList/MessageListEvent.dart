import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/screens/home/IndexScreen.dart';

abstract class MessageListEvent extends Equatable {
  const MessageListEvent();

  @override
  List<Object> get props => <Object>[];
}

class MessageListLoad extends MessageListEvent {
  final String collection, tableName;
  final IndexScreenState indexScreenState;

  const MessageListLoad({
    @required this.collection,
    @required this.tableName,
    @required this.indexScreenState,
  });

  @override
  List<Object> get props => <Object>[collection, tableName, indexScreenState];
}
