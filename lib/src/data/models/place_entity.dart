class PlaceEntity {
  String name;
  String formattedAddress;
  double lat;
  double lng;

  PlaceEntity({this.name, this.formattedAddress, this.lat, this.lng});

  factory PlaceEntity.fromJson(Map<String, dynamic> map) {
    return PlaceEntity(
      name: map['name'],
      formattedAddress: map['formatted_address'],
      lat: map['geometry']['location']['lat'],
      lng: map['geometry']['location']['lng'],
    );
  }

  static List<PlaceEntity> parseLocationList(map) {
    var list = map['results'] as List;
    return list.map((movie) => PlaceEntity.fromJson(movie)).toList();
  }
}
