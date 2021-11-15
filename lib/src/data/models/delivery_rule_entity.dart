class DeliveryRuleEntity {
  final String title;
  final String content;

  DeliveryRuleEntity({required this.title, required this.content});

  DeliveryRuleEntity.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        content = json['content'];
}
