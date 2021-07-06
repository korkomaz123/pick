// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:markaa/src/components/product_vv_card.dart';
// import 'package:markaa/src/config/config.dart';
// import 'package:markaa/src/data/models/brand_entity.dart';
// import 'package:markaa/src/data/models/category_entity.dart';
// import 'package:markaa/src/data/models/product_list_arguments.dart';
// import 'package:markaa/src/data/models/product_model.dart';
// import 'package:markaa/src/data/models/slider_image_entity.dart';
// import 'package:markaa/src/routes/routes.dart';
// import 'package:markaa/src/change_notifier/home_change_notifier.dart';
// import 'package:markaa/src/utils/repositories/product_repository.dart';

// import '../../../../preload.dart';

// class HomeBestWatches extends StatelessWidget {
//   final HomeChangeNotifier homeChangeNotifier;

//   HomeBestWatches({@required this.homeChangeNotifier});

//   final ProductRepository productRepository = ProductRepository();

//   Widget build(BuildContext context) {
//     return Container(
//       width: designWidth.w,
//       child: Column(
//         children: [
//           if (homeChangeNotifier.bestWatchesBanner != null) ...[
//             _buildBanner(homeChangeNotifier.bestWatchesBanner)
//           ],
//           if (homeChangeNotifier.bestWatchesItems.isNotEmpty) ...[
//             _buildProducts(homeChangeNotifier.bestWatchesItems)
//           ]
//         ],
//       ),
//     );
//   }

//   Widget _buildBanner(SliderImageEntity banner) {
//     return InkWell(
//       onTap: () async {
//         if (banner.categoryId != null) {
//           final arguments = ProductListArguments(
//             category: CategoryEntity(
//               id: banner.categoryId,
//               name: banner.categoryName,
//             ),
//             brand: BrandEntity(),
//             subCategory: [],
//             selectedSubCategoryIndex: 0,
//             isFromBrand: false,
//           );
//           Navigator.pushNamed(
//             Preload.navigatorKey.currentContext,
//             Routes.productList,
//             arguments: arguments,
//           );
//         } else if (banner?.brand?.optionId != null) {
//           final arguments = ProductListArguments(
//             category: CategoryEntity(),
//             brand: banner.brand,
//             subCategory: [],
//             selectedSubCategoryIndex: 0,
//             isFromBrand: true,
//           );
//           Navigator.pushNamed(
//             Preload.navigatorKey.currentContext,
//             Routes.productList,
//             arguments: arguments,
//           );
//         } else if (banner?.productId != null) {
//           final product = await productRepository.getProduct(banner.productId);
//           Navigator.pushNamedAndRemoveUntil(
//             Preload.navigatorKey.currentContext,
//             Routes.product,
//             (route) => route.settings.name == Routes.home,
//             arguments: product,
//           );
//         }
//       },
//       child: CachedNetworkImage(
//         imageUrl: banner.bannerImage,
//         errorWidget: (context, url, error) =>
//             Center(child: Icon(Icons.image, size: 20.sp)),
//       ),
//     );
//   }

//   Widget _buildProducts(List<ProductModel> list) {
//     return Container(
//       padding: EdgeInsets.only(top: 15.h, bottom: 10.h),
//       height: 350.h,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: list.length,
//         itemBuilder: (context, index) => Container(
//           margin: EdgeInsets.only(left: 5.w),
//           child: ProductVVCard(
//             cardWidth: 170.w,
//             cardHeight: 330.h,
//             product: list[index],
//             isShoppingCart: true,
//             isLine: false,
//             isMinor: true,
//             isWishlist: true,
//             isShare: false,
//           ),
//         ),
//       ),
//     );
//   }
// }
