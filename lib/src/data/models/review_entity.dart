class ReviewEntity {
  final String title;
  final String detail;
  final String nickname;
  final String customerId;

  ReviewEntity({
    this.title,
    this.detail,
    this.nickname,
    this.customerId,
  });

  ReviewEntity.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        detail = json['detail'],
        nickname = json['nickname'],
        customerId = json['customer_id'];
}
