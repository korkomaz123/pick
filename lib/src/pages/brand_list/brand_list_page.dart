import 'package:cached_network_image/cached_network_image.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/markaa_app_bar.dart';
import 'package:markaa/src/components/markaa_bottom_bar.dart';
import 'package:markaa/src/components/markaa_page_loading_kit.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/enum.dart';
import 'package:markaa/src/data/models/product_list_arguments.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandListPage extends StatefulWidget {
  @override
  _BrandListPageState createState() => _BrandListPageState();
}

class _BrandListPageState extends State<BrandListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _alphabetKey = GlobalKey();
  final _itemKey = GlobalKey();

  HomeChangeNotifier? _homeChangeNotifier;
  ScrollController _brandListScrollController = ScrollController();

  List<String> alphabetList = ['all'.tr()];
  List<String> nameCharList = [];
  int selectedIndex = 0;
  int brandIndex = 0;
  Map<String, int> brandIndexMap = {};

  @override
  void initState() {
    super.initState();
    if (Preload.language == 'en') {
      alphabetList.addAll(enAlphabetList);
    } else {
      alphabetList.addAll(arAlphabetList);
    }

    _homeChangeNotifier = context.read<HomeChangeNotifier>();
    _loadingData = _homeChangeNotifier!.getBrandsList('brand');

    _homeChangeNotifier!.addListener(() {
      if (_homeChangeNotifier!.sortedBrandList.isNotEmpty) {
        for (var item in _homeChangeNotifier!.sortedBrandList) {
          String char = item.brandLabel.substring(0, 1).toUpperCase();
          if (nameCharList.indexOf(char) < 0) {
            int idx = _homeChangeNotifier!.sortedBrandList.indexOf(item);
            brandIndexMap[char] = idx;
            nameCharList.add(char);
          }
        }
        print(nameCharList);
        if (mounted) setState(() {});
      }
    });
  }

  Future? _loadingData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: MarkaaAppBar(scaffoldKey: scaffoldKey, isCenter: false),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              children: alphabetList.map((value) {
                int index = alphabetList.indexOf(value);
                int half = (alphabetList.length / 2).ceil();
                int keyIndex = selectedIndex < half ? 0 : half;
                int nameIndex = nameCharList.indexOf(value);
                return InkWell(
                  key: index == keyIndex ? _alphabetKey : null,
                  onTap: () {
                    selectedIndex = index;
                    if (nameIndex >= 0) brandIndex = brandIndexMap[value]!;
                    setState(() {});
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      if (selectedIndex == 0) {
                        _brandListScrollController.animateTo(
                          0,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Scrollable.ensureVisible(_itemKey.currentContext!);
                      }
                    });
                  },
                  child: Container(
                    width: 30.w,
                    height: 20.w,
                    margin: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: index == selectedIndex ? primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(5.w),
                      border: Border.all(color: primaryColor),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      value,
                      textAlign: TextAlign.justify,
                      style: mediumTextStyle.copyWith(
                        fontSize: 12.sp,
                        color: index != selectedIndex ? primaryColor : Colors.white,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          FutureBuilder(
            future: _loadingData,
            builder: (_, model) {
              if (model.connectionState == ConnectionState.waiting) {
                return Expanded(child: Center(child: PulseLoadingSpinner()));
              }
              return Expanded(
                child: SingleChildScrollView(
                  controller: _brandListScrollController,
                  child: Column(
                    children: List.generate(
                      _homeChangeNotifier!.sortedBrandList.length,
                      (index) {
                        return _buildBrandCard(_homeChangeNotifier!, index);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: MarkaaBottomBar(activeItem: BottomEnum.store),
    );
  }

  Widget _buildBrandCard(HomeChangeNotifier _homeChangeNotifier, int index) {
    return InkWell(
      key: brandIndex == index ? _itemKey : null,
      onTap: () {
        ProductListArguments arguments = ProductListArguments(
          category: null,
          subCategory: [],
          brand: _homeChangeNotifier.sortedBrandList[index],
          selectedSubCategoryIndex: 0,
          isFromBrand: true,
        );
        Navigator.pushNamed(context, Routes.productList, arguments: arguments);
      },
      child: Container(
        width: 375.w,
        height: 58.h,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CachedNetworkImage(
              imageUrl: _homeChangeNotifier.sortedBrandList[index].brandImage ?? '',
              errorWidget: (context, url, error) => Icon(Icons.error),
              progressIndicatorBuilder: (_, __, ___) {
                return CachedNetworkImage(
                  imageUrl: _homeChangeNotifier.sortedBrandList[index].brandThumbnail ?? '',
                  errorWidget: (_, __, ___) => Center(child: Icon(Icons.image, size: 20)),
                );
              },
            ),
            Text(
              _homeChangeNotifier.sortedBrandList[index].brandLabel,
              style: mediumTextStyle.copyWith(color: darkColor, fontSize: 14.sp),
            ),
            Row(
              children: [
                Text(
                  'view_all'.tr(),
                  style: mediumTextStyle.copyWith(color: primaryColor, fontSize: 11.sp),
                ),
                Icon(Icons.arrow_forward_ios, size: 22, color: primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
