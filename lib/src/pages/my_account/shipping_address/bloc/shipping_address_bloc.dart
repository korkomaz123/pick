import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ciga/src/data/models/address_entity.dart';
import 'package:ciga/src/pages/my_account/shipping_address/bloc/shipping_address_repository.dart';
import 'package:ciga/src/utils/local_storage_repository.dart';
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
  final localStorageRepository = LocalStorageRepository();

  @override
  Stream<ShippingAddressState> mapEventToState(
    ShippingAddressEvent event,
  ) async* {
    if (event is ShippingAddressLoaded) {
      yield* _mapShippingAddressLoadedToState(event.token);
    } else if (event is ShippingAddressAdded) {
      yield* _mapShippingAddressAddedToState(
        event.token,
        event.title,
        event.firstName,
        event.lastName,
        event.countryId,
        event.region,
        event.city,
        event.streetName,
        event.zipCode,
        event.phone,
        event.company,
        event.email,
      );
    } else if (event is ShippingAddressUpdated) {
      yield* _mapShippingAddressUpdatedToState(
        event.token,
        event.title,
        event.addressId,
        event.firstName,
        event.lastName,
        event.countryId,
        event.region,
        event.city,
        event.streetName,
        event.zipCode,
        event.phone,
        event.company,
        event.email,
        event.isDefaultBilling,
        event.isDefaultShipping,
      );
    } else if (event is DefaultShippingAddressUpdated) {
      yield* _mapDefaultShippingAddressUpdatedToState(
        event.token,
        event.title,
        event.addressId,
        event.firstName,
        event.lastName,
        event.countryId,
        event.region,
        event.city,
        event.streetName,
        event.zipCode,
        event.phone,
        event.company,
        event.email,
        event.isDefaultBilling,
        event.isDefaultShipping,
      );
    } else if (event is ShippingAddressRemoved) {
      yield* _mapShippingAddressRemovedToState(event.token, event.addressId);
    } else if (event is ShippingAddressInitialized) {
      yield ShippingAddressInitial();
    }
  }

  Stream<ShippingAddressState> _mapShippingAddressLoadedToState(
    String token,
  ) async* {
    yield ShippingAddressLoadedInProcess();
    try {
      String key = '$token-shippingaddress';
      final exist = await localStorageRepository.existItem(key);
      if (exist) {
        List<dynamic> shippingAddressesList =
            await localStorageRepository.getItem(key);
        List<AddressEntity> addresses = [];
        for (int i = 0; i < shippingAddressesList.length; i++) {
          addresses.add(AddressEntity.fromJson(shippingAddressesList[i]));
        }
        yield ShippingAddressLoadedSuccess(addresses: addresses);
      }
      final result =
          await _shippingAddressRepository.getShippingAddresses(token);
      if (result['code'] == 'SUCCESS') {
        await localStorageRepository.setItem(key, result['addresses']);
        List<dynamic> shippingAddressesList = result['addresses'];
        List<AddressEntity> addresses = [];
        for (int i = 0; i < shippingAddressesList.length; i++) {
          addresses.add(AddressEntity.fromJson(shippingAddressesList[i]));
        }
        yield ShippingAddressLoadedSuccess(addresses: addresses);
      } else {
        yield ShippingAddressLoadedFailure(message: result['errMessage']);
      }
    } catch (e) {
      yield ShippingAddressLoadedFailure(message: e.toString());
    }
  }

  Stream<ShippingAddressState> _mapShippingAddressAddedToState(
    String token,
    String title,
    String firstName,
    String lastName,
    String countryId,
    String region,
    String city,
    String streetName,
    String zipCode,
    String phoneNumber,
    String company,
    String email,
  ) async* {
    yield ShippingAddressAddedInProcess();
    try {
      final result = await _shippingAddressRepository.addShippingAddress(
        token,
        title,
        firstName,
        lastName,
        countryId,
        region,
        city,
        streetName,
        zipCode,
        phoneNumber,
        company,
        email,
      );
      if (result['code'] == 'SUCCESS') {
        yield ShippingAddressAddedSuccess();
      } else {
        yield ShippingAddressAddedFailure(message: result['errorMessage']);
      }
    } catch (e) {
      yield ShippingAddressAddedFailure(message: e.toString());
    }
  }

  Stream<ShippingAddressState> _mapShippingAddressUpdatedToState(
    String token,
    String title,
    String addressId,
    String firstName,
    String lastName,
    String countryId,
    String region,
    String city,
    String streetName,
    String zipCode,
    String phoneNumber,
    String company,
    String email,
    String isDefaultBilling,
    String isDefaultShipping,
  ) async* {
    yield ShippingAddressUpdatedInProcess();
    try {
      final result = await _shippingAddressRepository.updateShippingAddress(
        token,
        title,
        addressId,
        firstName,
        lastName,
        countryId,
        region,
        city,
        streetName,
        zipCode,
        phoneNumber,
        company,
        email,
        isDefaultBilling,
        isDefaultShipping,
      );
      if (result['code'] == 'SUCCESS') {
        yield ShippingAddressUpdatedSuccess();
      } else {
        yield ShippingAddressUpdatedFailure(message: result['errorMessage']);
      }
    } catch (e) {
      yield ShippingAddressUpdatedFailure(message: e.toString());
    }
  }

  Stream<ShippingAddressState> _mapDefaultShippingAddressUpdatedToState(
    String token,
    String title,
    String addressId,
    String firstName,
    String lastName,
    String countryId,
    String region,
    String city,
    String streetName,
    String zipCode,
    String phoneNumber,
    String company,
    String email,
    String isDefaultBilling,
    String isDefaultShipping,
  ) async* {
    yield DefaultShippingAddressUpdatedInProcess();
    try {
      final result = await _shippingAddressRepository.updateShippingAddress(
        token,
        title,
        addressId,
        firstName,
        lastName,
        countryId,
        region,
        city,
        streetName,
        zipCode,
        phoneNumber,
        company,
        email,
        isDefaultBilling,
        isDefaultShipping,
      );
      if (result['code'] == 'SUCCESS') {
        yield DefaultShippingAddressUpdatedSuccess();
      } else {
        yield DefaultShippingAddressUpdatedFailure(
            message: result['errorMessage']);
      }
    } catch (e) {
      yield DefaultShippingAddressUpdatedFailure(message: e.toString());
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
