import 'dart:async';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/models/place_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PlaceChangeNotifier with ChangeNotifier {
  StreamController<PlaceEntity> locationController =
      StreamController<PlaceEntity>.broadcast();
  PlaceEntity locationSelect;
  PlaceEntity formLocation;
  List<PlaceEntity> listPlace;

  Stream get placeStream => locationController.stream;

  Future<List<PlaceEntity>> search(String query) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/textsearch/json?key=$apiKey&language=en&region=KW&query=" +
            Uri.encodeQueryComponent(query);
    Response response = await Dio().get(url);
    listPlace = PlaceEntity.parseLocationList(response.data);
    notifyListeners();
    return listPlace;
  }

  void locationSelected(PlaceEntity location) {
    locationController.sink.add(location);
  }

  Future<void> selectLocation(PlaceEntity location) async {
    notifyListeners();
    locationSelect = location;
    return locationSelect;
  }

  Future<void> getCurrentLocation(PlaceEntity location) async {
    notifyListeners();
    formLocation = location;
    return formLocation;
  }

  @override
  void dispose() {
    locationController.close();
    super.dispose();
  }
}
