import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:ciga/src/pages/wishlist/bloc/wishlist_repository.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
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
      yield* _mapWishlistLoadedToState(event.ids, event.token, event.lang);
    } else if (event is WishlistInitialized) {
      yield WishlistInitial();
    }
  }

  Stream<WishlistState> _mapWishlistLoadedToState(
    List<String> ids,
    String token,
    String lang,
  ) async* {
    yield WishlistLoadedInProcess();
    try {
      String key = 'wishlists-$lang';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        List<dynamic> wishlistList = await localStorageRepository.getItem(key);
        List<ProductModel> wishlists = [];
        for (int i = 0; i < wishlistList.length; i++) {
          wishlists.add(ProductModel.fromJson(wishlistList[i]));
        }
        yield WishlistLoadedSuccess(wishlists: wishlists);
      }
      final result = await _wishlistRepository.getWishlists(ids, token, lang);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['wishlists']);
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
}
