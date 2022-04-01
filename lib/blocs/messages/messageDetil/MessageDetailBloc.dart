import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/models/MessageModel.dart';
import 'package:pikobar_flutter/repositories/AuthRepository.dart';
import 'package:pikobar_flutter/repositories/MessageRepository.dart';
import 'package:pikobar_flutter/utilities/FirestoreHelper.dart';

import './Bloc.dart';

class MessageDetailBloc extends Bloc<MessageDetailEvent, MessageDetailState> {
  final MessageRepository messageRepository = MessageRepository();

  MessageDetailBloc() : super(InitialMessageDetailState());

  @override
  Stream<MessageDetailState> mapEventToState(
    MessageDetailEvent event,
  ) async* {
    if (event is MessageDetailLoad) {
      yield MessageDetailLoading();
      String userId = await AuthRepository().getToken();

      DocumentSnapshot snapshot = await messageRepository.getDetail(
          event.messageId, event.collection, userId);

      MessageModel data = MessageModel(
          id: snapshot.id,
          backLink: getField(snapshot, 'backlink'),
          content: getField(snapshot, 'content'),
          title: getField(snapshot, 'title'),
          actionTitle: getField(snapshot, 'action_title'),
          actionUrl: getField(snapshot, 'action_url'),
          publishedAt: snapshot.get('published_at').seconds,
          readAt: 100);

      await MessageRepository().updateData(data, event.tableName);

      yield MessageDetailLoaded(data: data);
    }
  }
}
