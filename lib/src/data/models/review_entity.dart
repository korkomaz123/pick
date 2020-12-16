class ReviewEntity {
  final String reviewId;
  final String createdAt;
  final String entityId;
  final String detailId;
  final String entityPkValue;
  final String title;
  final String detail;
  final String nickname;
  final String customerId;
  final String entityCode;
  final double ratingValue;

  ReviewEntity({
    this.reviewId,
    this.createdAt,
    this.entityId,
    this.detailId,
    this.entityPkValue,
    this.title,
    this.detail,
    this.nickname,
    this.customerId,
    this.entityCode,
    this.ratingValue,
  });

  ReviewEntity.fromJson(Map<String, dynamic> json)
      : reviewId = json['review_id'],
        createdAt = json['timestamp'],
        entityId = json['entity_id'],
        detailId = json['detail_id'],
        entityPkValue = json['entity_pk_value'],
        title = json['title'],
        detail = json['detail'],
        nickname = json['nickname'],
        customerId = json['customer_id'],
        entityCode = json['entity_code'],
        ratingValue = int.parse(json['rating_value']) + .0;
}
