import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class DocumentsState extends Equatable {
  const DocumentsState();

  @override
  List<Object> get props => <Object>[];
}

class InitialDocumentsState extends DocumentsState {}

class DocumentsLoading extends DocumentsState {}

class DocumentsLoaded extends DocumentsState {
  final List<DocumentSnapshot> documents;

  const DocumentsLoaded(this.documents);

  @override
  List<Object> get props => <Object>[documents];
}