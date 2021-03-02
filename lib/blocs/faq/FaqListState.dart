import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class FaqListState extends Equatable {
  const FaqListState([List props = const <dynamic>[]]);
}

class InitialFaqListState extends FaqListState {
  @override
  List<Object> get props => [];
}

class FaqListLoading extends FaqListState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FaqListLoaded extends FaqListState {
  final List<DocumentSnapshot> faqList;

  FaqListLoaded(this.faqList);

  @override
  List<Object> get props => [faqList];

  @override
  String toString() => 'FaqListLoaded';
}
