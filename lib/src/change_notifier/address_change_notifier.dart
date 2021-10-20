import 'package:flutter/material.dart';
import 'package:markaa/src/data/models/address_entity.dart';
import 'package:markaa/src/utils/repositories/local_storage_repository.dart';
import 'package:markaa/src/utils/repositories/shipping_address_repository.dart';

class AddressChangeNotifier extends ChangeNotifier {
  ShippingAddressRepository addressRepository = ShippingAddressRepository();
  LocalStorageRepository localStorageRepository = LocalStorageRepository();

  Map<String, AddressEntity>? addressesMap;
  AddressEntity? defaultAddress;
  List<String>? keys;

  AddressEntity? guestAddress;

  void initialize() {
    addressesMap = {};
    keys = [];
    defaultAddress = null;
    guestAddress = null;
  }

  Future<void> loadGuestAddress() async {
    final exist = await localStorageRepository.existItem('guest_address');
    if (exist) {
      final address = await localStorageRepository.getItem('guest_address');
      guestAddress = AddressEntity.fromJson(address);
    }
    notifyListeners();
  }

  Future<void> updateGuestAddress(
    Map<String, dynamic> data, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      await localStorageRepository.setItem('guest_address', data);
      guestAddress = AddressEntity.fromJson(data);
      notifyListeners();
      if (onSuccess != null) onSuccess();
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
    }
  }

  void setDefaultAddress(AddressEntity address) {
    defaultAddress = address;
    notifyListeners();
  }

  Future<void> loadAddresses(
    String token, [
    Function? onSuccess,
    Function? onFailure,
  ]) async {
    try {
      final result = await addressRepository.getAddresses(token);
      if (result['code'] == 'SUCCESS') {
        List<dynamic> shippingAddressesList = result['addresses'];
        for (int i = 0; i < shippingAddressesList.length; i++) {
          final address = AddressEntity.fromJson(shippingAddressesList[i]);
          addressesMap![address.addressId!] = address;
          if (address.defaultShippingAddress == 1) {
            defaultAddress = address;
          }
        }
        keys = addressesMap!.keys.toList();
        keys!.sort((key1, key2) => int.parse(key2).compareTo(int.parse(key1)));
        notifyListeners();
        if (onSuccess != null) onSuccess();
      } else {
        if (onFailure != null) onFailure();
      }
    } catch (e) {
      print('LOAD ADDRESS CATCH ERROR: $e');
      if (onFailure != null) onFailure();
    }
  }

  Future<void> addAddress(
    String token,
    AddressEntity newAddress, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      final result = await addressRepository.addAddress(token, newAddress);
      if (result['code'] == 'SUCCESS') {
        newAddress.addressId = result['address'];
        addressesMap![newAddress.addressId!] = newAddress;
        if (newAddress.defaultShippingAddress == 1) {
          defaultAddress = newAddress;
        }
        keys = addressesMap!.keys.toList();
        keys!.sort((key1, key2) => int.parse(key2).compareTo(int.parse(key1)));
        notifyListeners();
        if (onSuccess != null) onSuccess();
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
    }
  }

  Future<void> updateAddress(
    String token,
    AddressEntity address, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      final result = await addressRepository.updateAddress(token, address);
      if (result['code'] == 'SUCCESS') {
        addressesMap![address.addressId!] = address;
        if (address.defaultShippingAddress == 1) {
          defaultAddress = address;
        }
        notifyListeners();
        if (onSuccess != null) onSuccess();
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
    }
  }

  Future<void> deleteAddress(
    String token,
    String addressId,
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  ) async {
    if (onProcess != null) onProcess();
    try {
      final result = await addressRepository.deleteAddress(token, addressId);
      if (result['code'] == 'SUCCESS') {
        final address = addressesMap![addressId];
        addressesMap!.remove(addressId);
        if (address!.defaultShippingAddress == 1) {
          defaultAddress = null;
        }
        keys = addressesMap!.keys.toList();
        keys!.sort((key1, key2) => int.parse(key2).compareTo(int.parse(key1)));
        notifyListeners();
        if (onSuccess != null) onSuccess();
      } else {
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      if (onFailure != null) onFailure('connection_error');
    }
  }
}
