part of 'faqcatagories_bloc.dart';

abstract class FaqCatagoriesEvent extends Equatable {
  const FaqCatagoriesEvent();

  @override
  List<Object> get props => [];
}

class FaqCategoriesLoad extends FaqCatagoriesEvent {}
