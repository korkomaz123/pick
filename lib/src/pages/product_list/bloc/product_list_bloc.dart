import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/product/bloc/product_repository.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc({@required ProductRepository productRepository})
      : assert(productRepository != null),
        _productRepository = productRepository,
        super(ProductListInitial());

  final ProductRepository _productRepository;
  final LocalStorageRepository localStorageRepository =
      LocalStorageRepository();

  @override
  Stream<ProductListState> mapEventToState(
    ProductListEvent event,
  ) async* {
    if (event is ProductListLoaded) {
      yield* _mapProductListLoadedToState(
        event.categoryId,
        event.lang,
      );
    } else if (event is ProductListSorted) {
      yield* _mapProductListSortedToState(
        event.categoryId,
        event.lang,
        event.sortItem,
      );
    } else if (event is BrandProductListLoaded) {
      yield* _mapBrandProductListLoadedToState(
        event.brandId,
        event.categoryId,
        event.lang,
      );
    } else if (event is ProductListInitialized) {
      yield ProductListInitial();
    }
  }

  Stream<ProductListState> _mapProductListLoadedToState(
    String categoryId,
    String lang,
  ) async* {
    yield ProductListLoadedInProcess();
    try {
      String key = 'cat-products-$categoryId-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        List<dynamic> productList = await localStorageRepository.getItem(key);
        List<ProductModel> products = [];
        for (int i = 0; i < productList.length; i++) {
          products.add(ProductModel.fromJson(productList[i]));
        }
        yield ProductListLoadedSuccess(
          products: products,
          categoryId: categoryId,
        );
      }
      final result = await _productRepository.getProducts(categoryId, lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['products']);
        List<dynamic> productList = result['products'];
        List<ProductModel> products = [];
        for (int i = 0; i < productList.length; i++) {
          products.add(ProductModel.fromJson(productList[i]));
        }
        yield ProductListLoadedSuccess(
          products: products,
          categoryId: categoryId,
        );
      } else {
        yield ProductListLoadedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield ProductListLoadedFailure(message: e.toString());
    }
  }

  Stream<ProductListState> _mapProductListSortedToState(
    String categoryId,
    String lang,
    String sortItem,
  ) async* {
    yield ProductListLoadedInProcess();
    try {
      final result =
          await _productRepository.sortProducts(categoryId, sortItem, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> productList = result['products'];
        List<ProductModel> products = [];
        for (int i = 0; i < productList.length; i++) {
          products.add(ProductModel.fromJson(productList[i]));
        }
        yield ProductListLoadedSuccess(
          products: products,
          categoryId: categoryId,
        );
      } else {
        yield ProductListLoadedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield ProductListLoadedFailure(message: e.toString());
    }
  }

  Stream<ProductListState> _mapBrandProductListLoadedToState(
    String brandId,
    String categoryId,
    String lang,
  ) async* {
    yield ProductListLoadedInProcess();
    try {
      String key = 'brand-products-$brandId-$categoryId-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        List<dynamic> productList = await localStorageRepository.getItem(key);
        List<ProductModel> products = [];
        for (int i = 0; i < productList.length; i++) {
          products.add(ProductModel.fromJson(productList[i]));
        }
        yield ProductListLoadedSuccess(
          products: products,
          categoryId: categoryId,
        );
      }
      final result =
          await _productRepository.getBrandProducts(brandId, categoryId, lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['products']);
        List<dynamic> productList = result['products'];
        List<ProductModel> products = [];
        for (int i = 0; i < productList.length; i++) {
          products.add(ProductModel.fromJson(productList[i]));
        }
        yield ProductListLoadedSuccess(
          products: products,
          categoryId: categoryId,
        );
      } else {
        yield ProductListLoadedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield ProductListLoadedFailure(message: e.toString());
    }
  }
}
