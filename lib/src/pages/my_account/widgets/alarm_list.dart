import 'package:markaa/src/apis/api.dart';
import 'package:markaa/src/apis/endpoints.dart';
import 'package:markaa/src/data/mock/mock.dart';
import 'package:markaa/src/routes/routes.dart';
import 'package:markaa/src/theme/styles.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlarmList extends StatefulWidget {
  @override
  _AlarmListState createState() => _AlarmListState();
}

class _AlarmListState extends State<AlarmList> {
  Future<dynamic>? future;

  @override
  void initState() {
    super.initState();
    future = Api.getMethod(
      EndPoints.getAlarmItems,
      data: {"lang": lang, "email": user!.email},
      extra: {"refresh": true},
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.alarmList),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          children: [
            Container(
              width: 22.w,
              height: 22.h,
              child: Icon(Icons.alarm, color: primaryColor),
            ),
            SizedBox(width: 10.w),
            Text(
              'alarm_list'.tr(),
              style: mediumTextStyle.copyWith(
                fontSize: 16.sp,
              ),
            ),
            Spacer(),
            FutureBuilder<dynamic>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.waiting &&
                    snapshot.hasData) {
                  return Text(
                    'items'.tr().replaceFirst(
                          '0',
                          '${snapshot.data['items']?.length ?? 0}',
                        ),
                    style: mediumTextStyle.copyWith(
                      fontSize: 16.sp,
                      color: primaryColor,
                    ),
                  );
                }
                return Container();
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
