import 'package:ciga/src/data/mock/mock.dart';
import 'package:ciga/src/pages/sign_in/bloc/sign_in_bloc.dart';
import 'package:ciga/src/routes/routes.dart';
import 'package:ciga/src/theme/icons.dart';
import 'package:ciga/src/theme/styles.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:ciga/src/utils/progress_service.dart';
import 'package:ciga/src/utils/snackbar_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:isco_custom_widgets/isco_custom_widgets.dart';

import 'logout_confirm_dialog.dart';

class LogoutItem extends StatefulWidget {
  final PageStyle pageStyle;
  final SnackBarService snackBarService;
  final ProgressService progressService;

  LogoutItem({this.pageStyle, this.snackBarService, this.progressService});

  @override
  _LogoutItemState createState() => _LogoutItemState();
}

class _LogoutItemState extends State<LogoutItem> {
  PageStyle pageStyle;
  SnackBarService snackBarService;
  ProgressService progressService;
  SignInBloc signInBloc;

  @override
  void initState() {
    super.initState();
    pageStyle = widget.pageStyle;
    snackBarService = widget.snackBarService;
    progressService = widget.progressService;
    signInBloc = context.bloc<SignInBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignOutSubmittedInProcess) {
          progressService.showProgress();
        }
        if (state is SignOutSubmittedSuccess) {
          progressService.hideProgress();
          user = null;
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.home,
            (route) => false,
          );
        }
        if (state is SignOutSubmittedFailure) {
          progressService.hideProgress();
          snackBarService.showErrorSnackBar(state.message);
        }
      },
      builder: (context, state) {
        return InkWell(
          onTap: () => _logout(),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: pageStyle.unitHeight * 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: pageStyle.unitWidth * 22,
                      height: pageStyle.unitHeight * 22,
                      child: SvgPicture.asset(logoutIcon),
                    ),
                    SizedBox(width: pageStyle.unitWidth * 10),
                    Text(
                      'account_logout'.tr(),
                      style: mediumTextStyle.copyWith(
                        fontSize: pageStyle.unitFontSize * 16,
                      ),
                    ),
                  ],
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
      },
    );
  }

  void _logout() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return LogoutConfirmDialog(pageStyle: pageStyle);
      },
    );
    if (result != null) {
      signInBloc.add(SignOutSubmitted(token: user.token));
    }
  }
}
