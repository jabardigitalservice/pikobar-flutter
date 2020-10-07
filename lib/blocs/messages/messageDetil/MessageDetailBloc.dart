import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/models/MessageModel.dart';
import 'package:pikobar_flutter/repositories/MessageRepository.dart';

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

      DocumentSnapshot snapshot =
          await messageRepository.getDetail(event.messageId);

      MessageModel data = MessageModel(
          id: snapshot.documentID,
          backLink: snapshot.data['backlink'],
          content: snapshot.data['content'],
          title: snapshot.data['title'],
          actionTitle: snapshot.data['action_title'],
          actionUrl: snapshot.data['action_url'],
          publishedAt: snapshot.data['published_at'].seconds,
          readAt: 100);

      await MessageRepository().updateData(data);

      yield MessageDetailLoaded(data: data);
    }
  }
}
