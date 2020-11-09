import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/cart_item_entity.dart';
import 'package:ciga/src/data/models/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'my_cart_repository.dart';

part 'my_cart_event.dart';
part 'my_cart_state.dart';

class MyCartBloc extends Bloc<MyCartEvent, MyCartState> {
  MyCartBloc({@required MyCartRepository myCartRepository})
      : assert(myCartRepository != null),
        _myCartRepository = myCartRepository,
        super(MyCartInitial());

  final MyCartRepository _myCartRepository;

  @override
  Stream<MyCartState> mapEventToState(
    MyCartEvent event,
  ) async* {
    if (event is MyCartCreated) {
      yield* _mapMyCartCreatedToState();
    } else if (event is MyCartItemsLoaded) {
      yield* _mapMyCartItemsLoadedToState(event.cartId);
    } else if (event is MyCartItemAdded) {
      yield* _mapMyCartItemAddedToState(
        event.cartId,
        event.productId,
        event.qty,
      );
    } else if (event is MyCartItemUpdated) {
      yield* _mapMyCartItemUpdatedToState(
        event.cartId,
        event.itemId,
        event.qty,
      );
    } else if (event is MyCartItemRemoved) {
      yield* _mapMyCartItemRemovedToState(event.cartId, event.itemId);
    } else if (event is MyCartItemsCleared) {
      yield* _mapMyCartItemsClearedToState(event.cartId);
    }
  }

  Stream<MyCartState> _mapMyCartCreatedToState() async* {
    yield MyCartCreatedInProcess();
    try {
      final result = await _myCartRepository.createCart();
      if (result['code'] == 'SUCCESS') {
        yield MyCartCreatedSuccess(cartId: result['cartId']);
      } else {
        yield MyCartCreatedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield MyCartCreatedFailure(message: e.toString());
    }
  }

  Stream<MyCartState> _mapMyCartItemsLoadedToState(String cartId) async* {
    yield MyCartItemsLoadedInProcess();
    try {
      final result = await _myCartRepository.getCartItems(cartId);

      if (result['code'] == 'SUCCESS') {
        List<dynamic> cartList = result['cart'];
        List<CartItemEntity> cartItems = [];
        for (int i = 0; i < cartList.length; i++) {
          Map<String, dynamic> cartItemJson = {};
          cartItemJson['product'] =
              ProductModel.fromJson(cartList[i]['product']);
          cartItemJson['qty'] = cartList[i]['qty'];
          cartItemJson['row_price'] = cartList[i]['row_price'];
          cartItemJson['item_id'] = cartList[i]['itemid'];
          cartItems.add(CartItemEntity.fromJson(cartItemJson));
        }
        yield MyCartItemsLoadedSuccess(cartItems: cartItems);
      } else {
        yield MyCartItemsLoadedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield MyCartItemsLoadedFailure(message: e.toString());
    }
  }

  Stream<MyCartState> _mapMyCartItemAddedToState(
    String cartId,
    String productId,
    String qty,
  ) async* {
    yield MyCartItemAddedInProcess();
    try {
      final result =
          await _myCartRepository.addCartItem(cartId, productId, qty);
      if (result['code'] == 'SUCCESS') {
        yield MyCartItemAddedSuccess();
      } else {
        yield MyCartItemAddedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield MyCartItemAddedFailure(message: e.toString());
    }
  }

  Stream<MyCartState> _mapMyCartItemUpdatedToState(
    String cartId,
    String itemId,
    String qty,
  ) async* {
    yield MyCartItemUpdatedInProcess();
    try {
      final result =
          await _myCartRepository.updateCartItem(cartId, itemId, qty);
      if (result['code'] == 'SUCCESS') {
        yield MyCartItemUpdatedSuccess();
      } else {
        yield MyCartItemUpdatedFailure(message: result['errMessage']);
      }
    } catch (e) {
      print(e.toString());
      yield MyCartItemUpdatedFailure(message: e.toString());
    }
  }

  Stream<MyCartState> _mapMyCartItemRemovedToState(
    String cartId,
    String itemId,
  ) async* {
    yield MyCartItemRemovedInProcess();
    try {
      final result = await _myCartRepository.deleteCartItem(cartId, itemId);
      if (result['code'] == 'SUCCESS') {
        yield MyCartItemRemovedSuccess();
      } else {
        yield MyCartItemRemovedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield MyCartItemRemovedFailure(message: e.toString());
    }
  }

  Stream<MyCartState> _mapMyCartItemsClearedToState(String cartId) async* {
    yield MyCartItemsClearedInProcess();
    try {
      final result = await _myCartRepository.clearCartItems(cartId);
      if (result['code'] == 'SUCCESS') {
        yield MyCartItemsClearedSuccess();
      } else {
        print(result['errMessage']);
        yield MyCartItemsClearedFailure(message: result['errMessage']);
      }
    } catch (e) {
      print(e.toString());
      yield MyCartItemsClearedFailure(message: e.toString());
    }
  }
}
