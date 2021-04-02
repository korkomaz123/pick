import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/apis/firebase_path.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/order_entity.dart';
import 'package:markaa/src/utils/repositories/firebase_repository.dart';
import 'package:markaa/src/utils/repositories/order_repository.dart';

class OrderChangeNotifier extends ChangeNotifier {
  final OrderRepository orderRepository;
  final FirebaseRepository firebaseRepository;

  OrderChangeNotifier({this.orderRepository, this.firebaseRepository});

  Map<String, OrderEntity> ordersMap = {};
  List<String> keys = [];

  void initializeOrders() {
    ordersMap = {};
    keys = [];
    notifyListeners();
  }

  void setKeys() {
    keys = ordersMap.keys.toList();
    keys.sort((key1, key2) => int.parse(key2).compareTo(int.parse(key1)));
  }

  Future<void> loadOrderHistories(
    String token,
    String lang, [
    Function onSuccess,
  ]) async {
    final result = await orderRepository.getOrderHistory(token, lang);
    if (result['code'] == 'SUCCESS') {
      ordersMap = {};
      List<dynamic> ordersList = result['orders'];
      for (int i = 0; i < ordersList.length; i++) {
        final order = OrderEntity.fromJson(ordersList[i]);
        ordersMap[order.orderId] = order;
      }
      setKeys();
      notifyListeners();
      if (onSuccess != null) {
        onSuccess();
      }
    }
  }

  Future<void> submitOrder(
    Map<String, dynamic> orderDetails,
    String lang,
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  ) async {
    onProcess();
    try {
      final result = await orderRepository.placeOrder(orderDetails, lang);
      if (result['code'] == 'SUCCESS') {
        final newOrder = OrderEntity.fromJson(result['order']);
        ordersMap[newOrder.orderId] = newOrder;
        setKeys();
        notifyListeners();
        onSuccess(newOrder.orderNo);
      } else {
        onFailure(result['errorMessage']);
        reportOrderIssue(result, orderDetails);
      }
    } catch (e) {
      onFailure(e.toString());
      reportOrderIssue(e.toString(), orderDetails);
    }
  }

  Future<void> cancelOrder(
    String orderId,
    List<Map<String, dynamic>> items,
    String additionalInfo,
    String reason,
    Uint8List product,
    String imageName,
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  ) async {
    onProcess();
    try {
      final result = await orderRepository.cancelOrder(
          orderId, items, additionalInfo, reason, product, imageName);
      if (result['code'] == 'SUCCESS') {
        final canceledOrder = OrderEntity.fromJson(result['order']);
        ordersMap[orderId] = canceledOrder;
        notifyListeners();
        onSuccess();
      } else {
        onFailure(result['errorMessage']);
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  Future<void> returnOrder(
    String token,
    String orderId,
    List<Map<String, dynamic>> items,
    String additionalInfo,
    String reason,
    Uint8List product,
    String imageName,
    Function onProcess,
    Function onSuccess,
    Function onFailure,
  ) async {
    onProcess();
    try {
      final result = await orderRepository.returnOrder(
          token, orderId, items, additionalInfo, reason, product, imageName);
      if (result['code'] == 'SUCCESS') {
        onSuccess();
      } else {
        onFailure(result['errorMessage']);
      }
    } catch (e) {
      onFailure(e.toString());
    }
  }

  void reportOrderIssue(dynamic result, dynamic orderDetails) async {
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final reportData = {
      'result': result,
      'orderDetails': orderDetails,
      'customer': user?.token != null ? user.toJson() : 'guest',
      'createdAt': DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()),
      'appVersion': {
        'android': MarkaaVersion.androidVersion,
        'iOS': MarkaaVersion.iOSVersion
      },
      'platform': Platform.isAndroid ? 'Android' : 'IOS',
      'lang': lang
    };
    final path = FirebasePath.ORDER_ISSUE_COLL_PATH.replaceFirst('date', date);
    await firebaseRepository.addToCollection(reportData, path);
  }
}
