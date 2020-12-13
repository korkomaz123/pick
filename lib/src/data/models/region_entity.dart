class RegionEntity {
  final String regionId;
  final String countryId;
  final String defaultName;
  final String name;

  RegionEntity({
    this.regionId,
    this.countryId,
    this.defaultName,
    this.name,
  });

  RegionEntity.fromJson(Map<String, dynamic> json)
      : regionId = json['value'],
        countryId = json['country_id'],
        defaultName = json['label'],
        name = json['title'];
}
