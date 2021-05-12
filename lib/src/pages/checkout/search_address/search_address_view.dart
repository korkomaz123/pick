import 'dart:async';
import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/change_notifier/place_change_notifier.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/data/models/address_entity.dart';
import 'package:markaa/src/data/models/formatted_address_entity.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:markaa/src/utils/services/flushbar_service.dart';

class SearchAddressView extends StatefulWidget {
  final PlaceChangeNotifier placeChangeNotifier;
  SearchAddressView({this.placeChangeNotifier});

  @override
  _SearchAddressViewState createState() => _SearchAddressViewState();
}

class _SearchAddressViewState extends State<SearchAddressView> {
  String valueFrom, valueTo;
  bool checkAutoFocus = false, inputFrom = false, inputTo = false;
  FocusNode searchNode = FocusNode();
  String formLocation;
  String toLocation;
  List<FormattedAddressEntity> formattedAddresses = [];
  FlushBarService flushBarService;

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    formLocation = widget?.placeChangeNotifier?.formLocation?.name;
    flushBarService = FlushBarService(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: (latlng) {
              final selectedPosition = CameraPosition(target: latlng, zoom: 14);
              _updatePosition(selectedPosition);
            },
          ),
          _buildForm(widget?.placeChangeNotifier),
          _buildUseMyLocationButton(),
          widget?.placeChangeNotifier?.listPlace != null && searchNode.hasFocus
              ? _buildSearchedAddressList()
              : Container(),
          formattedAddresses.isNotEmpty && !searchNode.hasFocus
              ? _buildFormattedAddressList()
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildForm(PlaceChangeNotifier placeChangeNotifier) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      color: Colors.white.withOpacity(0.8),
      child: Form(
        child: TextField(
          style: mediumTextStyle,
          autofocus: true,
          focusNode: searchNode,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "checkout_search_address_title".tr(),
            hintStyle: TextStyle(color: greyColor, fontSize: 14),
            contentPadding: EdgeInsets.only(top: 15.0),
            prefixIcon: Icon(Icons.location_on, color: dangerColor),
          ),
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: toLocation != null ? toLocation : '',
              selection: TextSelection.collapsed(
                offset: toLocation != null ? toLocation?.length : 0,
              ),
            ),
          ),
          onChanged: (String value) async {
            toLocation = value;
            await placeChangeNotifier?.search(value);
          },
          onTap: () {
            setState(() {
              inputTo = true;
              inputFrom = false;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSearchedAddressList() {
    return Container(
      height: 300,
      margin: EdgeInsets.only(top: 60),
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: widget?.placeChangeNotifier?.listPlace?.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              widget?.placeChangeNotifier?.listPlace[index]?.name,
            ),
            subtitle: Text(
              widget?.placeChangeNotifier?.listPlace[index]?.formattedAddress ??
                  '',
            ),
            onTap: () {
              widget?.placeChangeNotifier
                  ?.selectLocation(
                      widget?.placeChangeNotifier?.listPlace[index])
                  ?.then((_) {
                toLocation = widget?.placeChangeNotifier?.locationSelect?.name;
                FocusScope.of(context).requestFocus(searchNode);
                final newPosition = CameraPosition(
                  target: LatLng(
                    widget.placeChangeNotifier.locationSelect.lat,
                    widget.placeChangeNotifier.locationSelect.lng,
                  ),
                  zoom: 14,
                );
                _updatePosition(newPosition);
              });
            },
          );
        },
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: greyColor.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildFormattedAddressList() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: formattedAddresses.map((address) {
              return Column(
                children: [
                  InkWell(
                    onTap: () => _onSelectAddress(address),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: greyColor, size: 18),
                          SizedBox(width: 4),
                          Expanded(child: Text(address.formattedAddress)),
                        ],
                      ),
                    ),
                  ),
                  formattedAddresses.indexOf(address) <
                          (formattedAddresses.length - 1)
                      ? Divider()
                      : SizedBox.shrink(),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildUseMyLocationButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: MaterialButton(
        onPressed: () => _onCurrentLocation(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.my_location, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Current Location',
              style: mediumTextStyle.copyWith(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
        color: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  void _onCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      flushBarService.showErrorMessage(
        'Location services are disabled.',
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      flushBarService.showErrorMessage(
        'Location permissions are permantly denied, we cannot request permissions.',
      );
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        flushBarService.showErrorMessage(
          'Location permissions are denied (actual value: $permission).',
        );
      }
    }
    flushBarService.showInformMessage('Fetching the location');
    Position position = await Geolocator.getCurrentPosition(
      forceAndroidLocationManager: true,
      desiredAccuracy: LocationAccuracy.high,
    );
    print(position.latitude);
    print(position.longitude);
    CameraPosition myPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14,
    );
    _updatePosition(myPosition);
  }

  void _updatePosition(CameraPosition newPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
    double lat = newPosition.target.latitude;
    double lng = newPosition.target.longitude;
    final response = await Api.getMethod(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');
    print(response);
    List<dynamic> addressList = response['results'];
    formattedAddresses = addressList.map((address) {
      Map<String, dynamic> formattedJson = {};
      List<dynamic> componentAddresses = address['address_components'];
      for (int i = 0; i < componentAddresses.length; i++) {
        List<dynamic> componentTypes = componentAddresses[i]['types'];
        if (componentTypes.contains('country')) {
          formattedJson['country'] = componentAddresses[i]['long_name'];
          formattedJson['country_code'] = componentAddresses[i]['short_name'];
        } else if (componentTypes.contains('administrative_area_level_1')) {
          formattedJson['city'] = componentAddresses[i]['long_name'];
        } else if (componentTypes.contains('street_number')) {
          formattedJson['street'] = componentAddresses[i]['long_name'];
        } else if (componentTypes.contains('route')) {
          formattedJson['street'] = componentAddresses[i]['long_name'];
        } else if (componentTypes.contains('administrative_area_level_2')) {
          if (formattedJson['street'] != null) {
            formattedJson['street'] += ' ';
            formattedJson['street'] += componentAddresses[i]['long_name'];
          } else {
            formattedJson['street'] = componentAddresses[i]['long_name'];
          }
        } else if (componentTypes.contains('administrative_area_level_3')) {
          formattedJson['street'] = componentAddresses[i]['long_name'];
        } else if (componentTypes.contains('postal_code')) {
          formattedJson['postal_code'] = componentAddresses[i]['long_name'];
        } else if (componentTypes.contains('locality')) {
          formattedJson['state'] = componentAddresses[i]['state'];
        }
      }
      formattedJson['formatted_address'] = address['formatted_address'];
      return FormattedAddressEntity.fromJson(formattedJson);
    }).toList();
    searchNode.unfocus();
    setState(() {});
  }

  void _onSelectAddress(FormattedAddressEntity address) {
    AddressEntity addressEntity = AddressEntity(
      country: address.country,
      countryId: address.countryCode,
      region: address.state,
      city: address.city,
      street: address.street,
      postCode: address.postalCode,
    );
    Navigator.pop(context, addressEntity);
  }
}
