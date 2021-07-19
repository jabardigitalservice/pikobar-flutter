import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/constants/Dictionary.dart';
import 'package:pikobar_flutter/repositories/DocumentsRepository.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';
import './Bloc.dart';

class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  DocumentsRepository _repository = DocumentsRepository();
  StreamSubscription<Object> _subscription;
  LabelNew labelNew = LabelNew();

  DocumentsBloc() : super(InitialDocumentsState());

  @override
  Stream<DocumentsState> mapEventToState(
    DocumentsEvent event,
  ) async* {
    if (event is DocumentsLoad) {
      yield* _mapLoadDocumentsToState(limit: event.limit);
    } else if (event is DocumentsUpdate) {
      yield* _mapUpdateInfoGraphicListToState(event);
    }
  }

  Stream<DocumentsState> _mapLoadDocumentsToState({int limit}) async* {
    yield DocumentsLoading();
    _subscription?.cancel();
    _subscription = _repository.getDocuments(limit: limit).listen(
      (List<DocumentSnapshot> data) {
        labelNew.insertDataLabel(data, Dictionary.labelDocuments);
        add(DocumentsUpdate(data));
      },
    );
  }

  Stream<DocumentsState> _mapUpdateInfoGraphicListToState(
      DocumentsUpdate event) async* {
    yield DocumentsLoaded(event.documents);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
