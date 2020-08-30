import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

class WishlistRemoveDialog extends StatelessWidget {
  final PageStyle pageStyle;

  WishlistRemoveDialog({this.pageStyle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: primaryColor,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: pageStyle.unitWidth * 15,
          vertical: pageStyle.unitHeight * 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are You Sure',
              style: bookTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 26,
                color: Colors.white,
              ),
            ),
            SizedBox(height: pageStyle.unitHeight * 6),
            Text(
              'You want to remove ths item from your wishlist?',
              style: bookTextStyle.copyWith(
                fontSize: pageStyle.unitFontSize * 15,
                color: Colors.white,
              ),
            ),
            SizedBox(height: pageStyle.unitHeight * 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () => Navigator.pop(context, 'yes'),
                  child: Text(
                    'YES',
                    style: bookTextStyle.copyWith(
                      fontSize: pageStyle.unitFontSize * 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  height: 24,
                  child: VerticalDivider(
                    thickness: 0.5,
                    color: Colors.white,
                  ),
                ),
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'NO',
                    style: bookTextStyle.copyWith(
                      fontSize: pageStyle.unitFontSize * 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
