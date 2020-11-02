import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/product/bloc/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({@required ProductRepository productRepository})
      : assert(productRepository != null),
        _productRepository = productRepository,
        super(ProductInitial());

  final ProductRepository _productRepository;

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    if (event is ProductListLoaded) {
      yield* _mapProductListLoadedToState(event.subCategoryId, event.lang);
    }
  }

  Stream<ProductState> _mapProductListLoadedToState(
    String subCategoryId,
    String lang,
  ) async* {}
}
