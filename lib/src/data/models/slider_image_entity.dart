import 'dart:io';

import 'brand_entity.dart';

class SliderImageEntity {
  final String? bannerId;
  final String? bannerTitle;
  final String? bannerDescription;
  final String? bannerImage;
  final String? bannerVideo;
  final String? bannerYoutube;
  final String? bannerVideoAutoPlay;
  final String? startDate;
  final String? endDate;
  final String? labelButtonText;
  final String? position;
  final String? isActive;
  final String? categoryId;
  final String? categoryName;
  final BrandEntity? brand;
  final String? productId;
  File? bannerImageFile;

  SliderImageEntity({
    this.bannerId,
    this.bannerTitle,
    this.bannerDescription,
    this.bannerImage,
    this.bannerVideo,
    this.bannerYoutube,
    this.bannerVideoAutoPlay,
    this.startDate,
    this.endDate,
    this.labelButtonText,
    this.position,
    this.isActive,
    this.categoryId,
    this.categoryName,
    this.brand,
    this.productId,
    this.bannerImageFile,
  });

  SliderImageEntity.fromJson(Map<String, dynamic> json)
      : bannerId = json['banner_id'],
        bannerTitle = json['banner_title'],
        bannerDescription = json['banner_description'],
        bannerImage = json['banner_image'],
        bannerVideo = json['banner_video'],
        bannerYoutube = json['banner_youtube'],
        bannerVideoAutoPlay = json['banner_video_autoplay'],
        startDate = json['start_date'],
        endDate = json['end_date'],
        labelButtonText = json['label_button_text'],
        position = json['position'],
        isActive = json['is_active'],
        categoryId = json['category_id'],
        categoryName = json['category_name'],
        brand = json.containsKey('brand_id') && json['brand_id'] != null
            ? BrandEntity(
                optionId: json['brand_id'],
                brandThumbnail: json['brand_thumbnail'],
                brandLabel: json['brand_label'],
                brandImage: json['brand_thumbnail'],
              )
            : null,
        productId = json.containsKey('product_id') ? json['product_id'] : null,
        bannerImageFile = json.containsKey('banner_image_file') ? json['banner_image_file'] : null;
}
