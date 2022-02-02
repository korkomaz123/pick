import 'package:badges/badges.dart';
import 'package:markaa/preload.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/change_notifier/my_cart_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondaryAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SecondaryAppBar({Key? key, this.title});

  final String? title;

  @override
  _SecondaryAppBarState createState() => _SecondaryAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50.h);
}

class _SecondaryAppBarState extends State<SecondaryAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: ScreenUtil().statusBarHeight),
          Container(
            width: 375.w,
            height: 50.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios, color: primaryColor, size: 26.sp),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 35.h,
                    child: TextFormField(
                      controller: TextEditingController(),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.sp),
                          borderSide: BorderSide(color: greyColor, width: 0.3.w),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.sp),
                          borderSide: BorderSide(color: greyColor, width: 0.3.w),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.sp),
                          borderSide: BorderSide(color: greyColor, width: 0.3.w),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'search_items'.tr(),
                        hintStyle: TextStyle(color: darkColor),
                        suffixIcon: Icon(
                          Icons.search,
                          color: greyDarkColor,
                          size: 25.sp,
                        ),
                      ),
                      readOnly: true,
                      onTap: () => Navigator.pushNamed(context, Routes.search),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, Routes.myCart),
                  icon: Center(
                    child: Consumer<MyCartChangeNotifier>(
                      builder: (_, model, __) {
                        return Badge(
                          badgeColor: badgeColor,
                          badgeContent: Text(
                            '${model.cartTotalCount}',
                            style: mediumTextStyle.copyWith(
                              fontSize: 8.sp,
                              color: Colors.white,
                            ),
                          ),
                          showBadge: model.cartItemCount > 0,
                          toAnimate: false,
                          animationDuration: Duration.zero,
                          position: Preload.languageCode == 'ar'
                              ? BadgePosition.topStart(start: 0, top: -2.h)
                              : BadgePosition.topEnd(end: 0, top: -2.h),
                          child: SvgPicture.asset(addCart1Icon),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
