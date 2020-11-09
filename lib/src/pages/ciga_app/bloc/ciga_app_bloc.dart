import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/cart_item_entity.dart';
import 'package:equatable/equatable.dart';

part 'ciga_app_event.dart';
part 'ciga_app_state.dart';

class CigaAppBloc extends Bloc<CigaAppEvent, CigaAppState> {
  CigaAppBloc() : super(CigaAppState().init());

  @override
  Stream<CigaAppState> mapEventToState(
    CigaAppEvent event,
  ) async* {
    if (event is CartItemCountIncremented) {
      yield CigaAppState().setCartCount(event.incrementedCount);
    } else if (event is CartItemCountDecremented) {
      yield CigaAppState().setCartCount(event.decrementedCount);
    } else if (event is CartItemCountSet) {
      yield CigaAppState().setCartCount(event.cartItemCount);
    } else if (event is CartItemCountUpdated) {
      List<CartItemEntity> cartItems = event.cartItems;
      int itemCount = 0;
      for (int i = 0; i < cartItems.length; i++) {
        itemCount += cartItems[i].itemCount;
      }
      yield CigaAppState().setCartCount(itemCount);
    }
  }
}
