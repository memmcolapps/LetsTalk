import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/button.dart';
import 'package:openim_demo/src/widgets/phone_input_box.dart';
import 'package:openim_demo/src/widgets/protocol_view.dart';
import 'package:openim_demo/src/widgets/radio_button.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';
import 'package:openim_demo/src/widgets/touch_close_keyboard.dart';

import 'register_logic.dart';

class RegisterPage extends StatelessWidget {
  final logic = Get.find<RegisterLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        backgroundColor: PageStyle.c_FFFFFF,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EnterpriseTitleBar.backButton(),
                Padding(
                  padding: EdgeInsets.only(left: 32.w, top: 49.h),
                  child: Text(
                    StrRes.newUserRegister,
                    style: PageStyle.ts_333333_20sp,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 32.w, top: 44.h, right: 32.w),
                  child: Obx(() => PhoneInputBox(
                        controller: logic.controller,
                        labelStyle: PageStyle.ts_003F38_14sp,
                        hintStyle: PageStyle.ts_333333_opacity40p_14sp,
                        textStyle: PageStyle.ts_000000_18sp,
                        codeStyle: PageStyle.ts_000000_18sp,
                        arrowColor: PageStyle.c_000000,
                        clearBtnColor: PageStyle.c_000000_opacity40p,
                        code: logic.areaCode.value,
                        onAreaCode: () => logic.openCountryCodePicker(),
                        showClearBtn: logic.showClearBtn.value,
                        inputWay: logic.isPhoneRegister
                            ? InputWay.phone
                            : InputWay.email,
                      )),
                ),
                Button(
                  onTap: () => logic.nextStep(),
                  textStyle: PageStyle.ts_FFFFFF_18sp,
                  margin: EdgeInsets.only(top: 59.h, left: 32.w, right: 32.w),
                  text: StrRes.nowRegister,
                  background: PageStyle.c_008000,
                ),
                Obx(() => ProtocolView(
                      isChecked: logic.agreedProtocol.value,
                      radioStyle: RadioStyle.BLUE,
                      onTap: () => logic.toggleProtocol(),
                      margin: EdgeInsets.only(top: 19.h),
                      style1: PageStyle.ts_333333_12sp,
                      style2: PageStyle.ts_003F38_12sp,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
