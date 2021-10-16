class ConditionEntity {
  String type;
  String attribute;
  String operator;
  String value;
  bool isValueProcessed;

  ConditionEntity({
    required this.type,
    required this.attribute,
    required this.operator,
    required this.value,
    required this.isValueProcessed,
  });

  ConditionEntity.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        attribute = json['attribute'],
        operator = json['operator'],
        value = json['value'].toString(),
        isValueProcessed = json['is_value_processed'];
}
