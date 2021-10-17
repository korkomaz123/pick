import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:markaa/src/components/markaa_text_icon_button.dart';
import 'package:markaa/src/config/config.dart';
import 'package:markaa/src/pages/my_wallet/gift/send_gift_page.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/icons.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'widgets/my_wallet_details_header.dart';
import 'widgets/my_wallet_details_form.dart';
import 'widgets/my_wallet_details_transactions.dart';

class MyWalletDetailsPage extends StatefulWidget {
  final double? amount;

  MyWalletDetailsPage({this.amount});

  @override
  _MyWalletDetailsPageState createState() => _MyWalletDetailsPageState();
}

class _MyWalletDetailsPageState extends State<MyWalletDetailsPage>
    with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController _controller = ScrollController();

  ScrollDirection prevDirection = ScrollDirection.forward;

  @override
  void initState() {
    super.initState();

    _controller.addListener(_onScroll);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _scaffoldKey.currentState!
          .showBottomSheet((context) => _buildBottomSheet());
    });
  }

  _onScroll() {
    if (prevDirection != _controller.position.userScrollDirection) {
      if (prevDirection == ScrollDirection.forward) {
        _scaffoldKey.currentState!
            .showBottomSheet((context) => SizedBox.shrink());
      } else if (prevDirection == ScrollDirection.reverse) {
        _scaffoldKey.currentState!
            .showBottomSheet((context) => _buildBottomSheet());
      }
    }
    prevDirection = _controller.position.userScrollDirection;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        String router =
            widget.amount != null ? Routes.checkout : Routes.account;
        Navigator.popUntil(context, (route) => route.settings.name == router);
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MyWalletDetailsHeader(fromCheckout: widget.amount != null),
        body: Column(
          children: [
            MyWalletDetailsForm(amount: widget.amount),
            Expanded(
              child: SingleChildScrollView(
                controller: _controller,
                child: MyWalletDetailsTransactions(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      width: designWidth.w,
      height: 60.h,
      child: MarkaaTextIconButton(
        title: 'send_gift_title'.tr(),
        titleSize: 20.sp,
        titleColor: primaryColor,
        buttonColor: Colors.white,
        borderColor: Colors.transparent,
        icon: SvgPicture.asset(giftIcon),
        onPressed: _onSendGift,
      ),
    );
  }

  void _onSendGift() {
    showSlidingBottomSheet(
      context,
      builder: (_) {
        return SlidingSheetDialog(
          color: Colors.white,
          elevation: 2,
          cornerRadius: 10.sp,
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [0.5, 1],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          duration: Duration(milliseconds: 500),
          builder: (context, state) {
            return SendGiftPage(fromCheckout: widget.amount != null);
          },
        );
      },
    );
  }
}
