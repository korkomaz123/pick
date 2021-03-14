import 'package:markaa/src/change_notifier/home_change_notifier.dart';
import 'package:markaa/src/components/product_v_card.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/data/models/product_model.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/local_storage_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class HomeRecent extends StatefulWidget {
  final PageStyle pageStyle;

  HomeRecent({this.pageStyle});

  @override
  _HomeRecentState createState() => _HomeRecentState();
}

class _HomeRecentState extends State<HomeRecent> {
  HomeChangeNotifier homeChangeNotifier;
  LocalStorageRepository localStorageRepository;
  List<ProductModel> recentlyViews = [];

  @override
  void initState() {
    super.initState();
    localStorageRepository = context.read<LocalStorageRepository>();
    homeChangeNotifier = context.read<HomeChangeNotifier>();
    if (user?.token != null) {
      print('customer');
      homeChangeNotifier.loadRecentlyViewedCustomer(user.token, lang);
    } else {
      print('guest');
      _loadGuestViewed();
    }
  }

  void _loadGuestViewed() async {
    List<String> ids = await localStorageRepository.getRecentlyViewedIds();
    homeChangeNotifier.loadRecentlyViewedGuest(ids, lang);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeChangeNotifier>(
      builder: (_, model, __) {
        recentlyViews = model.recentlyViewedProducts;
        if (recentlyViews.isNotEmpty) {
          return Container(
            width: widget.pageStyle.deviceWidth,
            height: widget.pageStyle.unitHeight * 370,
            padding: EdgeInsets.all(widget.pageStyle.unitWidth * 8),
            margin: EdgeInsets.only(bottom: widget.pageStyle.unitHeight * 10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'home_recently_view'.tr(),
                  style: mediumTextStyle.copyWith(
                    fontSize: widget.pageStyle.unitFontSize * 23,
                    color: greyDarkColor,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      recentlyViews.length > 20 ? 20 : recentlyViews.length,
                      (index) {
                        return Row(
                          children: [
                            ProductVCard(
                              cardWidth: widget.pageStyle.unitWidth * 175,
                              cardHeight: widget.pageStyle.unitHeight * 300,
                              product: recentlyViews[index],
                              pageStyle: widget.pageStyle,
                              isShoppingCart: true,
                              isWishlist: true,
                              isShare: true,
                            ),
                            if (index < recentlyViews.length - 1) ...[
                              Container(
                                height: widget.pageStyle.unitHeight * 300,
                                padding: EdgeInsets.only(
                                  left: widget.pageStyle.unitWidth * 10,
                                  right: widget.pageStyle.unitWidth * 10,
                                  bottom: widget.pageStyle.unitHeight * 50,
                                ),
                                child: VerticalDivider(
                                  width: widget.pageStyle.unitWidth * 4,
                                  thickness: widget.pageStyle.unitWidth * 1,
                                  color: greyColor.withOpacity(0.4),
                                ),
                              )
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
