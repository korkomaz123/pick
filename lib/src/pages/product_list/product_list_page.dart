import 'dart:async';
import 'package:ciga/src/components/ciga_side_menu.dart';
import 'package:ciga/src/components/product_v_card.dart';
import 'package:ciga/src/components/ciga_app_bar.dart';
import 'package:ciga/src/components/ciga_bottom_bar.dart';
import 'package:ciga/src/components/ciga_page_loading_kit.dart';
import 'package:ciga/src/config/config.dart';
import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/data/models/enum.dart';
import 'package:ciga/src/data/models/index.dart';
import 'package:ciga/src/data/models/product_list_arguments.dart';
import 'package:ciga/src/pages/filter/filter_page.dart';
import 'package:ciga/src/pages/product_list/widgets/product_no_available.dart';
import 'package:ciga/src/pages/product_list/widgets/product_sort_by_dialog.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class ProductListPage extends StatefulWidget {
  final ProductListArguments arguments;

  ProductListPage({this.arguments});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  PageStyle pageStyle;
  ProductListArguments arguments;
  CategoryEntity category;
  List<CategoryEntity> subCategories;
  StoreEntity store;
  int activeSubcategoryIndex;
  bool isFromStore;
  String selectedCategory;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    arguments = widget.arguments;
    category = arguments.category;
    subCategories = arguments.subCategory;
    store = arguments.store;
    activeSubcategoryIndex = arguments.selectedSubCategoryIndex;
    isFromStore = arguments.isFromStore;
    selectedCategory = subCategories[activeSubcategoryIndex].name;
    Timer.periodic(Duration(seconds: 3), (timer) {
      timer.cancel();
      isLoading = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    pageStyle = PageStyle(context, designWidth, designHeight);
    pageStyle.initializePageStyles();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CigaAppBar(pageStyle: pageStyle, scaffoldKey: scaffoldKey),
      drawer: CigaSideMenu(pageStyle: pageStyle),
      body: Column(
        children: [
          _buildAppBar(),
          isLoading
              ? Expanded(
                  child: Center(
                    child: RippleLoadingSpinner(),
                  ),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        isFromStore ? _buildStoreBar() : SizedBox.shrink(),
                        _buildCategoryBar(),
                        selectedCategory == 'Sub1'
                            ? ProductNoAvailable(pageStyle: pageStyle)
                            : _buildProductList(),
                        SizedBox(height: pageStyle.unitHeight * 10),
                      ],
                    ),
                  ),
                ),
        ],
      ),
      bottomNavigationBar: CigaBottomBar(
        pageStyle: pageStyle,
        activeItem: BottomEnum.category,
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 60,
      color: primarySwatchColor,
      padding: EdgeInsets.symmetric(horizontal: pageStyle.unitWidth * 10),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: pageStyle.unitFontSize * 20,
                ),
                onTap: () => Navigator.pop(context),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _onSortBy(),
                    icon: Icon(
                      Icons.sort,
                      color: Colors.white,
                      size: pageStyle.unitFontSize * 25,
                    ),
                  ),
                  InkWell(
                    onTap: () => _showFilterDialog(),
                    child: Container(
                      width: pageStyle.unitWidth * 20,
                      height: pageStyle.unitHeight * 17,
                      child: SvgPicture.asset(filterIcon),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              isFromStore ? store.name : category.name,
              style: boldTextStyle.copyWith(
                color: Colors.white,
                fontSize: pageStyle.unitFontSize * 17,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStoreBar() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 80,
      margin: EdgeInsets.only(bottom: pageStyle.unitHeight * 8),
      alignment: Alignment.center,
      color: Colors.white,
      child: Image.asset(
        store.imageUrl,
        width: pageStyle.unitWidth * 120,
        height: pageStyle.unitHeight * 60,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCategoryBar() {
    return Container(
      width: pageStyle.deviceWidth,
      height: pageStyle.unitHeight * 50,
      color: backgroundColor,
      child: SelectOptionCustomCustom(
        items: subCategories.map((e) => e.name).toList(),
        value: selectedCategory,
        titleSize: pageStyle.unitFontSize * 14,
        itemSpace: pageStyle.unitWidth * 0,
        radius: pageStyle.unitWidth * 20,
        selectedColor: primaryColor,
        unSelectedColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        unSelectedBorderColor: primaryColor,
        selectedTitleColor: Colors.white,
        unSelectedTitleColor: greyColor,
        listStyle: true,
        onTap: (value) {
          if (selectedCategory != value) {
            setState(() {
              selectedCategory = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildProductList() {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: List.generate(
        20,
        (index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                right: index % 2 == 0
                    ? BorderSide(
                        color: greyColor,
                        width: pageStyle.unitWidth * 0.5,
                      )
                    : BorderSide.none,
                bottom: BorderSide(
                  color: greyColor,
                  width: pageStyle.unitWidth * 0.5,
                ),
              ),
            ),
            child: ProductVCard(
              pageStyle: pageStyle,
              product: homeCategories[0].products[1],
              cardWidth: pageStyle.unitWidth * 186,
              cardHeight: pageStyle.unitHeight * 253,
              isShoppingCart: true,
              isWishlist: true,
              isShare: true,
            ),
          );
        },
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) {
        return FilterPage();
      },
    );
  }

  void _onSortBy() async {
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 10,
        snapSpec: SnapSpec(
          snap: true,
          snappings: [0.8],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        duration: Duration(milliseconds: 300),
        builder: (context, state) {
          return ProductSortByDialog(pageStyle: pageStyle);
        },
      );
    });
  }
}
