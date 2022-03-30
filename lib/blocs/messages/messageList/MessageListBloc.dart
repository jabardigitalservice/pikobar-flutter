import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/models/MessageModel.dart';
import 'package:pikobar_flutter/repositories/MessageRepository.dart';

import './Bloc.dart';

class MessageListBloc extends Bloc<MessageListEvent, MessageListState> {
  final MessageRepository messageRepository = MessageRepository();

  MessageListBloc() : super(InitialMessageListState());

  @override
  Stream<MessageListState> mapEventToState(
    MessageListEvent event,
  ) async* {
    if (event is MessageListLoad) {
      yield MessageListLoading();

      QuerySnapshot snapshot =
          await messageRepository.getListFromCollection(event.collection);

      List<MessageModel> data = await messageRepository.getListFromDatabase(
          snapshot, event.tableName, event.indexScreenState);

      yield MessageListLoaded(data: data);
    }
  }
}
