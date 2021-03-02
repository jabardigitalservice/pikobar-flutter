import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class FaqListEvent extends Equatable {
  const FaqListEvent([List props = const <dynamic>[]]);
}

class FaqListLoad extends FaqListEvent {
  final String faqCollection;
  final String category;

  FaqListLoad({this.faqCollection, this.category});

  @override
  List<Object> get props => [faqCollection, category];
}

class FaqListUpdate extends FaqListEvent {
  final List<DocumentSnapshot> faqList;

  FaqListUpdate(this.faqList);

  @override
  List<Object> get props => [faqList];
}
