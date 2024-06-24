import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

// import 'moments_logic.dart';

import 'interest_logic.dart';

class InterestPage extends StatelessWidget {
  final imLogic = Get.find<IMController>();
  final logic = Get.find<InterestLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.centerTitle(
        title: StrRes.interest,
      ),
      backgroundColor: PageStyle.c_FFFFFF,
      body: Column(
        children: [
          SizedBox(
            height: 5.h,
          ),
          _buildItemView(
              icon: ImageRes.ic_myInfo,
              label: StrRes.moments,
              onTap: () => logic.goMoments()),
          // _buildItemView(
          //   icon: ImageRes.ic_newsNotify,
          //   label: StrRes.newsNotify,
          // ),

          _buildLine(),
          _buildItemView(
              icon: ImageRes.ic_scan,
              label: StrRes.scan,
              onTap: () => logic.goScan()),
          _buildLine(),

          /// 暂时屏蔽附近的人
          // _buildItemView(
          //     icon: ImageRes.ic_PeopleNearby,
          //     label: StrRes.peopleNearby,
          //     onTap: () => logic.goPeopleNearby()),
          // _buildItemView(
          //   icon: ImageRes.ic_newsNotify,
          //   label: StrRes.newsNotify,
          // ),

          _buildLine(),
        ],
      ),
    );
  }

  Widget _buildLine() => Container(
        height: 0.5,
        color: PageStyle.c_999999_opacity40p,
      );

  Widget _buildItemView({
    required String icon,
    required String label,
    Function()? onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(icon, width: 22.w, height: 22.h),
              SizedBox(width: 13.w),
              Text(
                label,
                style: PageStyle.ts_333333_16sp,
              ),
              Spacer(),
              Image.asset(ImageRes.ic_next, width: 7.w, height: 13.h),
            ],
          ),
        ),
      );
}
