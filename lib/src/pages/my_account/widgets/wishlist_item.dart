import 'package:markaa/src/pages/ciga_app/bloc/wishlist_item_count/wishlist_item_count_bloc.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:markaa/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
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
            BlocBuilder<WishlistItemCountBloc, WishlistItemCountState>(
              builder: (context, state) {
                return Text(
                  'items'.tr().replaceFirst('0', '${state.wishlistItemCount}'),
                  style: mediumTextStyle.copyWith(
                    fontSize: pageStyle.unitFontSize * 16,
                    color: primaryColor,
                  ),
                );
              },
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
