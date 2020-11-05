import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/cart_item_entity.dart';
import 'package:equatable/equatable.dart';

part 'my_cart_event.dart';
part 'my_cart_state.dart';

class MyCartBloc extends Bloc<MyCartEvent, MyCartState> {
  MyCartBloc() : super(MyCartInitial());

  @override
  Stream<MyCartState> mapEventToState(
    MyCartEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
