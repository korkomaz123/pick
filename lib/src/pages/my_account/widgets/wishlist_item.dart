import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/wishlist_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:markaa/src/utils/services/snackbar_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistItem extends StatefulWidget {
  final SnackBarService snackBarService;

  WishlistItem({this.snackBarService});

  @override
  _WishlistItemState createState() => _WishlistItemState();
}

class _WishlistItemState extends State<WishlistItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.wishlist),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 5.h),
        child: Row(
          children: [
            Container(
              width: 22.w,
              height: 22.h,
              child: SvgPicture.asset(wishlistCustomIcon),
            ),
            SizedBox(width: 10.w),
            Text(
              'account_wishlist_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 16.sp,
              ),
            ),
            Spacer(),
            Consumer<WishlistChangeNotifier>(
              builder: (_, model, __) {
                return Text(
                  'items'.tr().replaceFirst('0', '${model.wishlistItemsCount}'),
                  style: mediumTextStyle.copyWith(
                    fontSize: 16.sp,
                    color: primaryColor,
                  ),
                );
              },
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20.sp,
              color: greyDarkColor,
            ),
          ],
        ),
      ),
    );
  }
}
