import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'wishlist_item_count_event.dart';
part 'wishlist_item_count_state.dart';

class WishlistItemCountBloc
    extends Bloc<WishlistItemCountEvent, WishlistItemCountState> {
  WishlistItemCountBloc() : super(WishlistItemCountState().init());

  @override
  Stream<WishlistItemCountState> mapEventToState(
    WishlistItemCountEvent event,
  ) async* {
    if (event is WishlistItemCountSet) {
      yield WishlistItemCountState().update(event.wishlistItemCount);
    }
  }
}
