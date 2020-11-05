import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/address_entity.dart';
import 'package:ciga/src/pages/my_account/shipping_address/bloc/shipping_address_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'shipping_address_event.dart';
part 'shipping_address_state.dart';

class ShippingAddressBloc
    extends Bloc<ShippingAddressEvent, ShippingAddressState> {
  ShippingAddressBloc({
    @required ShippingAddressRepository shippingAddressRepository,
  })  : assert(shippingAddressRepository != null),
        _shippingAddressRepository = shippingAddressRepository,
        super(ShippingAddressInitial());

  final ShippingAddressRepository _shippingAddressRepository;

  @override
  Stream<ShippingAddressState> mapEventToState(
    ShippingAddressEvent event,
  ) async* {
    if (event is ShippingAddressLoaded) {
      yield* _mapShippingAddressLoadedToState(event.token);
    } else if (event is ShippingAddressAdded) {
      yield* _mapShippingAddressAddedToState(
        event.token,
        event.firstName,
        event.lastName,
        event.countryId,
        event.region,
        event.city,
        event.streetName,
        event.zipCode,
        event.phone,
      );
    } else if (event is ShippingAddressUpdated) {
      yield* _mapShippingAddressUpdatedToState(
        event.token,
        event.addressId,
        event.firstName,
        event.lastName,
        event.countryId,
        event.region,
        event.city,
        event.streetName,
        event.zipCode,
        event.phone,
        event.isDefaultBilling,
        event.isDefaultShipping,
      );
    } else if (event is ShippingAddressRemoved) {
      yield* _mapShippingAddressRemovedToState(event.token, event.addressId);
    }
  }

  Stream<ShippingAddressState> _mapShippingAddressLoadedToState(
    String token,
  ) async* {
    yield ShippingAddressLoadedInProcess();
    try {
      final result =
          await _shippingAddressRepository.getShippingAddresses(token);
      print(result);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> shippingAddressesList = result['addresses'];
        List<AddressEntity> addresses = [];
        for (int i = 0; i < shippingAddressesList.length; i++) {
          addresses.add(AddressEntity.fromJson(shippingAddressesList[i]));
        }
        yield ShippingAddressLoadedSuccess(addresses: addresses);
      } else {
        yield ShippingAddressLoadedFailure(message: result['errorMessage']);
      }
    } catch (e) {
      yield ShippingAddressLoadedFailure(message: e.toString());
    }
  }

  Stream<ShippingAddressState> _mapShippingAddressAddedToState(
    String token,
    String firstName,
    String lastName,
    String countryId,
    String region,
    String city,
    String streetName,
    String zipCode,
    String phoneNumber,
  ) async* {
    yield ShippingAddressAddedInProcess();
    try {
      await _shippingAddressRepository.addShippingAddress(
        token,
        firstName,
        lastName,
        countryId,
        region,
        city,
        streetName,
        zipCode,
        phoneNumber,
      );
      yield ShippingAddressAddedSuccess();
    } catch (e) {
      yield ShippingAddressAddedFailure(message: e.toString());
    }
  }

  Stream<ShippingAddressState> _mapShippingAddressUpdatedToState(
    String token,
    String addressId,
    String firstName,
    String lastName,
    String countryId,
    String region,
    String city,
    String streetName,
    String zipCode,
    String phoneNumber,
    String isDefaultBilling,
    String isDefaultShipping,
  ) async* {
    yield ShippingAddressUpdatedInProcess();
    try {
      await _shippingAddressRepository.updateShippingAddress(
        token,
        addressId,
        firstName,
        lastName,
        countryId,
        region,
        city,
        streetName,
        zipCode,
        phoneNumber,
        isDefaultBilling,
        isDefaultShipping,
      );
      yield ShippingAddressUpdatedSuccess();
    } catch (e) {
      yield ShippingAddressUpdatedFailure(message: e.toString());
    }
  }

  Stream<ShippingAddressState> _mapShippingAddressRemovedToState(
    String token,
    String addressId,
  ) async* {
    yield ShippingAddressRemovedInProcess();
    try {
      await _shippingAddressRepository.deleteShippingAddress(token, addressId);
      yield ShippingAddressRemovedSuccess();
    } catch (e) {
      yield ShippingAddressRemovedFailure(message: e.toString());
    }
  }
}
