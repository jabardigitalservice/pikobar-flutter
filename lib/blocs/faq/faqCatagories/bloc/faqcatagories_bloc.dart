import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pikobar_flutter/repositories/FaqRepository.dart';

part 'faqcatagories_event.dart';
part 'faqcatagories_state.dart';

class FaqCatagoriesBloc extends Bloc<FaqCatagoriesEvent, FaqCatagoriesState> {
  FaqCatagoriesBloc() : super(FaqCatagoriesInitial());

  final FaqRepository _repository = FaqRepository();

  @override
  Stream<FaqCatagoriesState> mapEventToState(FaqCatagoriesEvent event) async* {
    if (event is FaqCategoriesLoad) {
      yield FaqCatagoriesLoading();
      final categories = await _repository.getFaqCategories();
      yield FaqCatagoriesLoaded(categories: categories);
    }
  }
}
