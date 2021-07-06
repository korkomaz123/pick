class Specification {
  final String label;
  final String value;
  final String code;

  Specification({this.label, this.value, this.code});

  Specification copyWith({label, value, code}) => Specification(label: label ?? this.label, code: code ?? this.code, value: value ?? this.value);

  Specification.fromJson(Map<String, dynamic> json)
      : label = json['label'],
        code = json['code'],
        value = json['value'];
}
