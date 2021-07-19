import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class FaqListState extends Equatable {
  const FaqListState();

  @override
  List<Object> get props => <Object>[];
}

class InitialFaqListState extends FaqListState {}

class FaqListLoading extends FaqListState {}

@immutable
class FaqListLoaded extends FaqListState {
  final List<DocumentSnapshot> faqList;

  const FaqListLoaded(this.faqList);

  @override
  List<Object> get props => <Object>[faqList];
}
