part of 'brand_bloc.dart';

abstract class BrandState extends Equatable {
  const BrandState();

  @override
  List<Object> get props => [];
}

class BrandInitial extends BrandState {}

class BrandListLoadedInProcess extends BrandState {}

class BrandListLoadedSuccess extends BrandState {
  final List<BrandEntity> brands;

  BrandListLoadedSuccess({this.brands});

  @override
  List<Object> get props => [brands];
}

class BrandListLoadedFailure extends BrandState {
  final String message;

  BrandListLoadedFailure({this.message});

  @override
  List<Object> get props => [message];
}
