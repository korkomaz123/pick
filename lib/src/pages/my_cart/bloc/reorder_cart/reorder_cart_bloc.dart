import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:markaa/src/data/models/cart_item_entity.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../my_cart_repository.dart';

part 'reorder_cart_event.dart';
part 'reorder_cart_state.dart';

class ReorderCartBloc extends Bloc<ReorderCartEvent, ReorderCartState> {
  ReorderCartBloc({@required MyCartRepository myCartRepository})
      : assert(myCartRepository != null),
        _myCartRepository = myCartRepository,
        super(ReorderCartInitial());

  final MyCartRepository _myCartRepository;

  @override
  Stream<ReorderCartState> mapEventToState(
    ReorderCartEvent event,
  ) async* {
    if (event is ReorderCartItemsLoaded) {
      yield* _mapReorderCartItemsLoadedToState(event.reorderCartId, event.lang);
    } else if (event is ReorderCartItemRemoved) {
      yield* _mapReorderCartItemRemovedToState(event.cartId, event.itemId);
    } else if (event is ReorderCartItemsInitialized) {
      yield ReorderCartItemsInitializedSuccess();
    }
  }

  Stream<ReorderCartState> _mapReorderCartItemsLoadedToState(
    String cartId,
    String lang,
  ) async* {
    yield ReorderCartItemsLoadedInProcess();
    try {
      final result = await _myCartRepository.getCartItems(cartId, lang);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> cartList = result['cart'];
        List<CartItemEntity> cartItems = [];
        for (int i = 0; i < cartList.length; i++) {
          Map<String, dynamic> cartItemJson = {};
          cartItemJson['product'] =
              ProductModel.fromJson(cartList[i]['product']);
          cartItemJson['itemCount'] = cartList[i]['itemCount'];
          cartItemJson['rowPrice'] = cartList[i]['row_price'];
          cartItemJson['itemId'] = cartList[i]['itemid'];
          cartItemJson['availableCount'] = cartList[i]['availableCount'];
          cartItems.add(CartItemEntity.fromJson(cartItemJson));
        }
        yield ReorderCartItemsLoadedSuccess(cartItems: cartItems);
      } else {
        yield ReorderCartItemsLoadedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield ReorderCartItemsLoadedFailure(message: e.toString());
    }
  }

  Stream<ReorderCartState> _mapReorderCartItemRemovedToState(
    String cartId,
    String itemId,
  ) async* {
    yield ReorderCartItemRemovedInProcess();
    try {
      final result = await _myCartRepository.deleteCartItem(cartId, itemId);
      if (result['code'] == 'SUCCESS') {
        yield ReorderCartItemRemovedSuccess();
      } else {
        yield ReorderCartItemRemovedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield ReorderCartItemRemovedFailure(message: e.toString());
    }
  }
}
