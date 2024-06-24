import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';

import 'splash_logic.dart';

class SplashPage extends StatelessWidget {
  final logic = Get.find<SplashLogic>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              ImageRes.launchApp,
              fit: BoxFit.cover,
            ),
          ),

          // Positioned(
          //   top: 0.h,
          //   width: 400,
          //   height: 1024,
          //   child: Center(
          //     child: Image.asset(
          //     ImageRes.launchApp,
          //     fit: BoxFit.fill,
          //   ),
          //   ),
          // ),
          // Positioned(
          //   top: 673.h,
          //   width: 375.w,
          //   child: Center(
          //     child: Text(
          //       StrRes.welcomeHint,
          //       style: PageStyle.ts_333333_18sp,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
