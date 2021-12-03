import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pikobar_flutter/repositories/FaqRepository.dart';
import 'package:pikobar_flutter/utilities/LabelNew.dart';
import 'Bloc.dart';

class FaqListBloc extends Bloc<FaqListEvent, FaqListState> {
  final FaqRepository _repository = FaqRepository();
  LabelNew labelNew = LabelNew();
  late StreamSubscription<Object> _subscription;

  FaqListBloc() : super(InitialFaqListState());

  @override
  Stream<FaqListState> mapEventToState(
    FaqListEvent event,
  ) async* {
    if (event is FaqListLoad) {
      yield* _mapLoadFaqListToState(
          faqCollection: event.faqCollection, category: event.category);
    } else if (event is FaqListUpdate) {
      yield* _mapUpdateFaqListToState(event);
    }
  }

  Stream<FaqListState> _mapLoadFaqListToState(
      {required String faqCollection, required String category}) async* {
    yield FaqListLoading();
    await _subscription.cancel();
    _subscription = _repository
        .getFaq(faqCollection: faqCollection, category: category)
        .listen(
      (List<DocumentSnapshot> data) {
        add(FaqListUpdate(data));
      },
    );
  }

  Stream<FaqListState> _mapUpdateFaqListToState(FaqListUpdate event) async* {
    yield FaqListLoaded(event.faqList);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
