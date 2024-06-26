import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/radio_button.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'setup_language_logic.dart';

class SetupLanguagePage extends StatelessWidget {
  final logic = Get.find<SetupLanguageLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.languageSetup,
      ),
      body: Obx(() => ListView(
            children: [
              _buildItemView(
                label: StrRes.followSystem,
                checked: logic.isFollowSystem.value,
                onTap: () => logic.switchLanguage(0),
              ),
              _buildItemView(
                label: StrRes.chinese,
                checked: logic.isChinese.value,
                onTap: () => logic.switchLanguage(1),
              ),
              _buildItemView(
                label: StrRes.english,
                checked: logic.isEnglish.value,
                onTap: () => logic.switchLanguage(2),
              ),
              _buildItemView(
                label: StrRes.frenchLanguages,
                checked: false,
                onTap: () => logic.switchNotEnabled,
              ),
              _buildItemView(
                label: StrRes.germanLanguages,
                checked: false,
                onTap: () => logic.switchNotEnabled(),
              ),
              _buildItemView(
                label: StrRes.naijaLanguages,
                checked: false,
                onTap: () => logic.switchNotEnabled(),
              ),
              _buildItemView(
                label: StrRes.hausaLanguages,
                checked: false,
                onTap: () => logic.switchNotEnabled(),
              ),
              _buildItemView(
                label: StrRes.igboLanguages,
                checked: false,
                onTap: () => logic.switchNotEnabled(),
              ),
              _buildItemView(
                label: StrRes.yorubaLanguages,
                checked: false,
                onTap: () => logic.switchNotEnabled(),
              ),
              _buildItemView(
                label: StrRes.pidginLanguages,
                checked: false,
                onTap: () => logic.switchNotEnabled(),
              )
            ],
          )),
    );
  }

  Widget _buildItemView({
    required String label,
    Function()? onTap,
    bool checked = false,
  }) =>
      Ink(
        height: 58.h,
        color: PageStyle.c_FFFFFF,
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
                  style: PageStyle.ts_333333_18sp,
                ),
                Spacer(),
                RadioButton(
                  isChecked: checked,
                  style: RadioStyle.BLUE,
                )
              ],
            ),
          ),
        ),
      );
}
