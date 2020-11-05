import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class WishlistItem extends StatefulWidget {
  final PageStyle pageStyle;
  final SnackBarService snackBarService;

  WishlistItem({this.pageStyle, this.snackBarService});

  @override
  _WishlistItemState createState() => _WishlistItemState();
}

class _WishlistItemState extends State<WishlistItem> {
  PageStyle pageStyle;
  SnackBarService snackBarService;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    snackBarService = widget.snackBarService;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.wishlist),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: pageStyle.unitHeight * 5),
        child: Row(
          children: [
            Container(
              width: pageStyle.unitWidth * 22,
              height: pageStyle.unitHeight * 22,
              child: SvgPicture.asset(wishlistIcon),
            ),
            SizedBox(width: pageStyle.unitWidth * 10),
            Text(
              'account_wishlist_title'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
              ),
            ),
            Spacer(),
            Text(
              '10 ' + 'items'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 16,
                color: primaryColor,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: pageStyle.unitFontSize * 20,
              color: greyDarkColor,
            ),
          ],
        ),
      ),
    );
  }
}
