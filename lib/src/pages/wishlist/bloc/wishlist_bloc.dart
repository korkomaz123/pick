import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/pages/wishlist/bloc/wishlist_repository.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc({@required WishlistRepository wishlistRepository})
      : assert(wishlistRepository != null),
        _wishlistRepository = wishlistRepository,
        super(WishlistInitial());

  final WishlistRepository _wishlistRepository;
  final localStorageRepository = LocalStorageRepository();

  @override
  Stream<WishlistState> mapEventToState(
    WishlistEvent event,
  ) async* {
    if (event is WishlistLoaded) {
      yield* _mapWishlistLoadedToState(event.token, event.lang);
    } else if (event is WishlistInitialized) {
      yield WishlistInitial();
    } else if (event is WishlistAdded) {
      yield* _mapWishlistAddedToState(event.token, event.productId);
    } else if (event is WishlistRemoved) {
      yield* _mapWishlistRemovedToState(event.token, event.productId);
    }
  }

  Stream<WishlistState> _mapWishlistLoadedToState(
    String token,
    String lang,
  ) async* {
    yield WishlistLoadedInProcess();
    try {
      final result = await _wishlistRepository.getWishlists(token, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> wishlistList = result['wishlists'];
        List<ProductModel> wishlists = [];
        for (int i = 0; i < wishlistList.length; i++) {
          wishlists.add(ProductModel.fromJson(wishlistList[i]));
        }
        yield WishlistLoadedSuccess(wishlists: wishlists);
      } else {
        yield WishlistLoadedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield WishlistLoadedFailure(message: e.toString());
    }
  }

  Stream<WishlistState> _mapWishlistAddedToState(
    String token,
    String productId,
  ) async* {
    yield WishlistAddedInProcess();
    try {
      bool succeed = await _wishlistRepository.changeWishlist(token, productId, 'add');
      if (succeed) {
        yield WishlistAddedSuccess();
      } else {
        yield WishlistAddedFailure(message: 'Something went wrong');
      }
    } catch (e) {
      print('catch error');
      print(e.toString());
      yield WishlistAddedFailure(message: e.toString());
    }
  }

  Stream<WishlistState> _mapWishlistRemovedToState(
    String token,
    String productId,
  ) async* {
    yield WishlistRemovedInProcess();
    try {
      final result = await _wishlistRepository.changeWishlist(token, productId, 'delete');
      if (result) {
        yield WishlistRemovedSuccess();
      } else {
        yield WishlistRemovedFailure(message: 'Something went wrong');
      }
    } catch (e) {
      yield WishlistRemovedFailure(message: e.toString());
    }
  }
}
