import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pikobar_flutter/repositories/DocumentsRepository.dart';
import './Bloc.dart';

class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  DocumentsRepository _repository = DocumentsRepository();
  StreamSubscription _subscription;

  @override
  DocumentsState get initialState => InitialDocumentsState();

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
          (data) => add(DocumentsUpdate(data)),
    );
  }

  Stream<DocumentsState> _mapUpdateInfoGraphicListToState(DocumentsUpdate event) async* {
    yield DocumentsLoaded(event.documents);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
