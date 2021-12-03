import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class FaqListEvent extends Equatable {
  const FaqListEvent();
}

@immutable
class FaqListLoad extends FaqListEvent {
  final String faqCollection;
  final String category;

  FaqListLoad({required this.faqCollection, required this.category});

  @override
  List<Object> get props => <Object>[faqCollection, category];
}

@immutable
class FaqListUpdate extends FaqListEvent {
  final List<DocumentSnapshot> faqList;

  FaqListUpdate(this.faqList);

  @override
  List<Object> get props => <Object>[faqList];
}
