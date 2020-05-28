import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class DocumentsEvent extends Equatable {
  const DocumentsEvent([List props = const <dynamic>[]]);
}

class DocumentsLoad extends DocumentsEvent {
  final int limit;

  DocumentsLoad({this.limit});

  @override
  List<Object> get props => [limit];
}

class DocumentsUpdate extends DocumentsEvent {
  final List<DocumentSnapshot> documents;

  DocumentsUpdate(this.documents);

  @override
  List<Object> get props => [documents];
}