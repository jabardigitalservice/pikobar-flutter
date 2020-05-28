import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class DocumentsState extends Equatable {
  const DocumentsState([List props = const <dynamic>[]]);
}

class InitialDocumentsState extends DocumentsState {
  @override
  List<Object> get props => [];
}

class DocumentsLoading extends DocumentsState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DocumentsLoaded extends DocumentsState {
  final List<DocumentSnapshot> documents;

  DocumentsLoaded(this.documents);

  @override
  List<Object> get props => [documents];

  @override
  String toString() => 'DocumentLoaded';
}