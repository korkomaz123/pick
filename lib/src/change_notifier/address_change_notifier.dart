import 'dart:io';

import 'package:flutter/material.dart';
import 'package:markaa/env.dart';
import 'package:markaa/slack.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/address_entity.dart';
import 'package:markaa/src/utils/repositories/local_db_repository.dart';
import 'package:markaa/src/utils/repositories/shipping_address_repository.dart';

class AddressChangeNotifier extends ChangeNotifier {
  final LocalDBRepository localDB;

  AddressChangeNotifier({required this.localDB});

  ShippingAddressRepository addressRepository = ShippingAddressRepository();

  late Map<String, AddressEntity> customerAddressesMap;
  late List<String> customerAddressKeys;
  AddressEntity? customerDefaultAddress;

  late Map<int, AddressEntity> guestAddressesMap;
  late List<int> guestAddressKeys;
  AddressEntity? guestDefaultAddress;

  void initialize() {
    guestAddressesMap = {};
    guestAddressKeys = [];
    guestDefaultAddress = null;
    customerAddressesMap = {};
    customerAddressKeys = [];
    customerDefaultAddress = null;
  }

  Future<void> loadGuestAddresses() async {
    try {
      final list = await localDB.getAddress();
      if (list.isNotEmpty) {
        for (var item in list) {
          AddressEntity address = AddressEntity.fromJson(item);
          guestAddressesMap[address.id] = address;
          if (address.defaultShippingAddress == 1) {
            guestDefaultAddress = address;
          }
        }
      }
      guestAddressKeys = guestAddressesMap.keys.toList();
      guestAddressKeys.sort((key1, key2) => key2.compareTo(key1));
      notifyListeners();
    } catch (e) {
      SlackChannels.send(
        '$env GUEST ADRESS LOAD ERROR: [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] [error] => $e \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
        SlackChannels.logAddressError,
      );
    }
  }

  Future<void> changeGuestAddress(
    bool isNew,
    Map<String, dynamic> data, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (isNew) {
      await addGuestAddress(
        data,
        onProcess: onProcess,
        onSuccess: onSuccess,
        onFailure: onFailure,
      );
    } else {
      await updateGuestAddress(
        data,
        onProcess: onProcess,
        onSuccess: onSuccess,
        onFailure: onFailure,
      );
    }
  }

  Future<void> addGuestAddress(
    Map<String, dynamic> data, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      int id = await localDB.addAddress(data);
      data['id'] = id;
      AddressEntity address = AddressEntity.fromJson(data);
      guestAddressesMap[address.id] = address;
      guestAddressKeys = guestAddressesMap.keys.toList();
      guestAddressKeys.sort((key1, key2) => key2.compareTo(key1));
      notifyListeners();
      if (onSuccess != null) onSuccess();
      setGuestDefaultAddress(address);
    } catch (e) {
      SlackChannels.send(
        '$env GUEST ADRESS ADD ERROR: [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] [error] => $e \r\n [data] => ${data.toString()}  \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
        SlackChannels.logAddressError,
      );
      if (onFailure != null) onFailure('connection_error');
    }
  }

  Future<void> updateGuestAddress(
    Map<String, dynamic> data, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      bool updated = await localDB.updateAddress(data);
      if (updated) {
        AddressEntity address = AddressEntity.fromJson(data);
        guestAddressesMap[address.id] = address;
        if (address.defaultShippingAddress == 1) guestDefaultAddress = address;
        notifyListeners();
      }
      if (onSuccess != null) onSuccess();
    } catch (e) {
      SlackChannels.send(
        '$env GUEST ADRESS UPDATE ERROR: [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] [error] => $e \r\n [data] => ${data.toString()} \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
        SlackChannels.logAddressError,
      );
      if (onFailure != null) onFailure('connection_error');
    }
  }

  Future<void> removeGuestAddress(
    int id, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (onProcess != null) onProcess();
    try {
      bool removed = await localDB.removeAddress(id);
      if (removed) {
        AddressEntity address = guestAddressesMap[id]!;
        guestAddressesMap.remove(id);
        guestAddressKeys = guestAddressesMap.keys.toList();
        guestAddressKeys.sort((key1, key2) => key2.compareTo(key1));
        notifyListeners();
        if (onSuccess != null) onSuccess();

        if (address.defaultShippingAddress == 1) {
          guestDefaultAddress = null;
          if (guestAddressKeys.isNotEmpty) {
            setGuestDefaultAddress(guestAddressesMap[guestAddressKeys[0]]!);
          }
        }
      } else {
        SlackChannels.send(
          '$env GUEST ADRESS REMOVE ERROR: [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [data] => ${guestAddressesMap[id]?.toJson() ?? {}} \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
          SlackChannels.logAddressError,
        );
        if (onFailure != null) onFailure('connection_error');
      }
    } catch (e) {
      SlackChannels.send(
        '$env GUEST ADRESS REMOVE ERROR: [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] [error] => $e \r\n [data] => ${guestAddressesMap[id]?.toJson() ?? {}} \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
        SlackChannels.logAddressError,
      );
      if (onFailure != null) onFailure('connection_error');
    }
  }

  void setGuestDefaultAddress(AddressEntity address) {
    guestDefaultAddress = address;
    notifyListeners();
    address.defaultBillingAddress = 1;
    address.defaultShippingAddress = 1;
    updateGuestAddress(address.toJson());
  }

  void setDefaultAddress(AddressEntity address) {
    customerDefaultAddress = address;
    notifyListeners();
    address.defaultBillingAddress = 1;
    address.defaultShippingAddress = 1;
    updateCustomerAddress(user!.token, address);
  }

  setCustomerAddressList(List<AddressEntity> list) {
    for (var item in list) {
      customerAddressesMap[item.addressId!] = item;
      if (item.defaultShippingAddress == 1) {
        customerDefaultAddress = item;
      }
    }
    customerAddressKeys = customerAddressesMap.keys.toList();
    customerAddressKeys.sort((key1, key2) => int.parse(key2).compareTo(int.parse(key1)));
    notifyListeners();
  }

  Future<void> loadCustomerAddresses(
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
          customerAddressesMap[address.addressId!] = address;
          if (address.defaultShippingAddress == 1) {
            customerDefaultAddress = address;
          }
        }
        customerAddressKeys = customerAddressesMap.keys.toList();
        customerAddressKeys.sort((key1, key2) => int.parse(key2).compareTo(int.parse(key1)));
        notifyListeners();
        if (onSuccess != null) onSuccess();
      } else {
        SlackChannels.send(
          '$env CUSTOMER ADRESS LOAD ERROR: [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [customer_info => ${user?.toJson() ?? 'Guest'}] \r\n [error] => ${result['errorMessage']} \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
          SlackChannels.logAddressError,
        );
        if (onFailure != null) onFailure();
      }
    } catch (e) {
      SlackChannels.send(
        '$env CUSTOMER ADRESS LOAD ERROR: [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [customer_info => ${user?.toJson() ?? 'Guest'}] \r\n [error] => $e \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
        SlackChannels.logAddressError,
      );
      if (onFailure != null) onFailure();
    }
  }

  Future<void> changeCustomerAddress(
    bool isNew,
    String token,
    AddressEntity address, {
    Function? onProcess,
    Function? onSuccess,
    Function? onFailure,
  }) async {
    if (isNew) {
      await addCustomerAddress(
        token,
        address,
        onProcess: onProcess,
        onSuccess: onSuccess,
        onFailure: onFailure,
      );
    } else {
      await updateCustomerAddress(
        token,
        address,
        onProcess: onProcess,
        onSuccess: onSuccess,
        onFailure: onFailure,
      );
    }
  }

  Future<void> addCustomerAddress(
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
        customerAddressesMap[newAddress.addressId!] = newAddress;
        customerAddressKeys = customerAddressesMap.keys.toList();
        customerAddressKeys.sort((key1, key2) => int.parse(key2).compareTo(int.parse(key1)));
        notifyListeners();
        if (onSuccess != null) onSuccess();

        setDefaultAddress(newAddress);
      } else {
        SlackChannels.send(
          '$env CUSTOMER ADRESS ADD ERROR: [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [customer_info => ${user?.toJson() ?? 'Guest'}] \r\n [error] => ${result['errorMessage']} \r\n [data] => ${newAddress.toJson()} \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
          SlackChannels.logAddressError,
        );
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      SlackChannels.send(
        '$env CUSTOMER ADRESS ADD ERROR: [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [customer_info => ${user?.toJson() ?? 'Guest'}] \r\n [error] => $e \r\n [data] => ${newAddress.toJson()} \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
        SlackChannels.logAddressError,
      );
      if (onFailure != null) onFailure('connection_error');
    }
  }

  Future<void> updateCustomerAddress(
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
        customerAddressesMap[address.addressId!] = address;
        if (address.defaultShippingAddress == 1) {
          customerDefaultAddress = address;
        }
        notifyListeners();
        if (onSuccess != null) onSuccess();
      } else {
        SlackChannels.send(
          '$env CUSTOMER ADRESS UPDATE ERROR: [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [customer_info => ${user?.toJson() ?? 'Guest'}] \r\n [error] => ${result['errorMessage']} \r\n [data] => ${address.toJson()} \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
          SlackChannels.logAddressError,
        );
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      SlackChannels.send(
        '$env CUSTOMER ADRESS UPDATE ERROR: [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [customer_info => ${user?.toJson() ?? 'Guest'}] \r\n [error] => $e \r\n [data] => ${address.toJson()} \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
        SlackChannels.logAddressError,
      );
      if (onFailure != null) onFailure('connection_error');
    }
  }

  Future<void> deleteCustomerAddress(
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
        final address = customerAddressesMap[addressId];
        customerAddressesMap.remove(addressId);
        customerAddressKeys = customerAddressesMap.keys.toList();
        customerAddressKeys.sort((key1, key2) => int.parse(key2).compareTo(int.parse(key1)));
        notifyListeners();
        if (onSuccess != null) onSuccess();

        if (address!.defaultShippingAddress == 1) {
          customerDefaultAddress = null;
          if (customerAddressKeys.isNotEmpty) {
            setDefaultAddress(customerAddressesMap[customerAddressKeys[0]]!);
          }
        }
      } else {
        SlackChannels.send(
          '$env CUSTOMER ADRESS REMOVE ERROR: [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [customer_info => ${user?.toJson() ?? 'Guest'}] \r\n [error] => ${result['errorMessage']} [data] => $addressId \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
          SlackChannels.logAddressError,
        );
        if (onFailure != null) onFailure(result['errorMessage']);
      }
    } catch (e) {
      SlackChannels.send(
        '$env CUSTOMER ADRESS REMOVE ERROR: [${Platform.isAndroid ? 'Android => ${MarkaaVersion.androidVersion}' : 'iOS => ${MarkaaVersion.iOSVersion}'}] \r\n [customer_info => ${user?.toJson() ?? 'Guest'}] \r\n [error] => $e [data] => $addressId \r\n [DashboardVisitorUrl => $gDashboardVisitorUrl] [DashboardSessionUrl => $gDashboardSessionUrl]',
        SlackChannels.logAddressError,
      );
      if (onFailure != null) onFailure('connection_error');
    }
  }
}
