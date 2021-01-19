import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:markaa/src/data/models/cart_item_entity.dart';
import 'package:equatable/equatable.dart';

part 'cart_item_count_event.dart';
part 'cart_item_count_state.dart';

class CartItemCountBloc extends Bloc<CartItemCountEvent, CartItemCountState> {
  CartItemCountBloc() : super(CartItemCountState().init());

  @override
  Stream<CartItemCountState> mapEventToState(
    CartItemCountEvent event,
  ) async* {
    if (event is CartItemCountIncremented) {
      yield CartItemCountState().setCartCount(event.incrementedCount);
    } else if (event is CartItemCountDecremented) {
      yield CartItemCountState().setCartCount(event.decrementedCount);
    } else if (event is CartItemCountSet) {
      yield CartItemCountState().setCartCount(event.cartItemCount);
    } else if (event is CartItemCountUpdated) {
      List<CartItemEntity> cartItems = event.cartItems;
      int itemCount = 0;
      for (int i = 0; i < cartItems.length; i++) {
        itemCount += cartItems[i].itemCount;
      }
      yield CartItemCountState().setCartCount(itemCount);
    }
  }
}
