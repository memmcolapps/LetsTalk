import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import '../../../utils/data_persistence.dart';
import '../../../utils/navigator_utils.dart';
import '../../../widgets/common_webview.dart';
import 'about_us_logic.dart';

class AboutUsPage extends StatelessWidget {
  final logic = Get.find<AboutUsLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.aboutUs,
      ),
      backgroundColor: PageStyle.c_F8F8F8,
      body: Column(
        children: [
          SizedBox(
            height: 24.h,
          ),
          Image.asset(
            ImageRes.ic_app,
            width: 74.h,
            height: 74.h,
          ),
          SizedBox(
            height: 16.h,
          ),
          Obx(() => Text(
                'V${logic.version.value}',
                style: PageStyle.ts_333333_20sp,
              )),
          SizedBox(
            height: 24.h,
          ),
          _buildItemView(
            label: StrRes.goToRate,
            onTap: () => {openWebsite(context)},
          ),
          // _buildItemView(
          //   label: StrRes.checkVersion,
          //   onTap: logic.checkUpdate,
          // ),
          _buildItemView(
            label: StrRes.newFuncIntroduction,
            onTap: () => {openWebsite(context)},
          ),
          _buildItemView(
            label: StrRes.appServiceAgreement,
            onTap: () => {openUserProtocol(context)},
          ),
          _buildItemView(
              label: StrRes.appPrivacyPolicy,
              onTap: () => {openPrivateProtocol(context)}),
          _buildItemView(
            label: StrRes.copyrightInformation,
            onTap: () => {openWebsite(context)},
          ),
        ],
      ),
    );
  }

  Widget _buildItemView({required String label, Function()? onTap}) => Ink(
        color: PageStyle.c_FFFFFF,
        height: 58.h,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            decoration: BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(
                  color: PageStyle.c_999999_opacity40p,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  label,
                  style: PageStyle.ts_333333_14sp,
                ),
                Spacer(),
                Image.asset(
                  ImageRes.ic_next,
                  width: 10.w,
                  height: 18.h,
                )
              ],
            ),
          ),
        ),
      );

  // 打开官网
  void openWebsite(BuildContext context) {
    NavigatorUtils.pushPage(
      context: context,
      targPage: CommonWebViewPage(
          pageTitle: "website", htmlUrl: "https://www.letstalk.com.ng"),
    );
  }

  //查看用户协议
  void openUserProtocol(BuildContext context) {
    NavigatorUtils.pushPage(
      context: context,
      targPage: CommonWebViewPage(
        pageTitle: StrRes.serviceAgreement,
        htmlUrl: "https://www.letstalk.com.ng/agreement/" +
            getLocale()!.languageCode.toString() +
            "/agreement.html",
      ),
    );
  }

  //查看隐私协议
  void openPrivateProtocol(BuildContext context) {
    NavigatorUtils.pushPage(
      context: context,
      targPage: CommonWebViewPage(
        pageTitle: StrRes.privacyPolicy,
        htmlUrl: "https://www.letstalk.com.ng/agreement/" +
            getLocale()!.languageCode.toString() +
            "/privacy.html",
      ),
    );
  }

  Locale? getLocale() {
    var local = Get.locale;
    var index = DataPersistence.getLanguage() ?? 0;
    switch (index) {
      case 1:
        local = Locale('zh', 'CN');
        break;
      case 2:
        local = Locale('en', 'US');
        break;
    }
    return local;
  }
}
