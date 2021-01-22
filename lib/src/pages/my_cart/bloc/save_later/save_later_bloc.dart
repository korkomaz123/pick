import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:meta/meta.dart';

import 'save_later_repository.dart';

part 'save_later_event.dart';
part 'save_later_state.dart';

class SaveLaterBloc extends Bloc<SaveLaterEvent, SaveLaterState> {
  SaveLaterBloc({@required SaveLaterRepository saveLaterRepository})
      : assert(saveLaterRepository != null),
        _saveLaterRepository = saveLaterRepository,
        super(SaveLaterInitial());

  final SaveLaterRepository _saveLaterRepository;

  @override
  Stream<SaveLaterState> mapEventToState(
    SaveLaterEvent event,
  ) async* {
    if (event is SaveLaterItemsLoaded) {
      yield* _mapSaveLaterItemsLoadedToState(event.token, event.lang);
    } else if (event is SaveLaterItemChanged) {
      yield* _mapSaveLaterItemChangedToState(
        event.token,
        event.productId,
        event.action,
        event.qty,
        event.product,
        event.itemId,
      );
    }
  }

  Stream<SaveLaterState> _mapSaveLaterItemsLoadedToState(
    String token,
    String lang,
  ) async* {
    yield SaveLaterItemsLoadedInProcess();
    try {
      final response =
          await _saveLaterRepository.getSaveForLaterItems(token, lang);
      if (response['code'] == 'SUCCESS') {
        yield SaveLaterItemsLoadedSuccess(items: response['items']);
      } else {
        yield SaveLaterItemsLoadedFailure(message: response['errMessage']);
      }
    } catch (e) {
      yield SaveLaterItemsLoadedFailure(message: e.toString());
    }
  }

  Stream<SaveLaterState> _mapSaveLaterItemChangedToState(
    String token,
    String productId,
    String action,
    int qty,
    ProductModel product,
    String itemId,
  ) async* {
    yield SaveLaterItemChangedInProcess();
    try {
      final response = await _saveLaterRepository.changeSaveForLaterItem(
          token, productId, action, qty);
      if (response['code'] == 'SUCCESS') {
        yield SaveLaterItemChangedSuccess(
          product: product,
          action: action,
          itemId: itemId,
        );
      } else {
        yield SaveLaterItemChangedFailure(
          message: response['errMessage'],
        );
      }
    } catch (e) {
      yield SaveLaterItemChangedFailure(
        message: e.toString(),
      );
    }
  }
}
