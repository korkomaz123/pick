import 'package:flutter/material.dart';
import 'package:markaa/src/data/models/order_entity.dart';

class OrderChangeNotifier extends ChangeNotifier {
  List<OrderEntity> orders = [];
}
