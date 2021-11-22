part of 'faqcatagories_bloc.dart';

abstract class FaqCatagoriesState extends Equatable {
  const FaqCatagoriesState();

  @override
  List<Object> get props => [];
}

class FaqCatagoriesInitial extends FaqCatagoriesState {}

class FaqCatagoriesLoading extends FaqCatagoriesState {}

class FaqCatagoriesLoaded extends FaqCatagoriesState {
  final List<FaqCategoriesModel> categories;

  const FaqCatagoriesLoaded({@required this.categories});

  @override
  List<Object> get props => [categories];
}
