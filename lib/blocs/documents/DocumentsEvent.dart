import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class DocumentsEvent extends Equatable {
  const DocumentsEvent();
}

class DocumentsLoad extends DocumentsEvent {
  final int limit;

  const DocumentsLoad({required this.limit});

  @override
  List<Object> get props => <Object>[limit];
}

class DocumentsUpdate extends DocumentsEvent {
  final List<DocumentSnapshot> documents;

  const DocumentsUpdate(this.documents);

  @override
  List<Object> get props => <Object>[documents];
}
