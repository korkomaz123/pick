class ConditionEntity {
  String type;
  String attribute;
  String operator;
  String value;
  bool isValueProcessed;

  ConditionEntity({
    this.type,
    this.attribute,
    this.operator,
    this.value,
    this.isValueProcessed,
  });

  ConditionEntity.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        attribute = json['attribute'],
        operator = json['operator'],
        value = json['value'].toString(),
        isValueProcessed = json['is_value_processed'];
}
