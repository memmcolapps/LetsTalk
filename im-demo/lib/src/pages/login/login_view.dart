import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/button.dart';
import 'package:openim_demo/src/widgets/debounce_button.dart';
import 'package:openim_demo/src/widgets/phone_email_input_box.dart';
import 'package:openim_demo/src/widgets/protocol_view.dart';
import 'package:openim_demo/src/widgets/pwd_input_box.dart';
import 'package:openim_demo/src/widgets/radio_button.dart';
import 'package:openim_demo/src/widgets/touch_close_keyboard.dart';

import '../../res/images.dart';
import 'login_logic.dart';

class LoginPage extends StatelessWidget {
  final logic = Get.find<LoginLogic>();

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(229, 229, 229, 1),
                  Color.fromRGBO(229, 229, 229, 0.1),
                ],
              ),
              // image: DecorationImage(
              //   image: AssetImage(ImageRes.ic_loginBg),
              //   fit: BoxFit.cover,
              // ),
            ),
            height: 1.sh,
            child: Stack(
              children: [
                Positioned(
                  top: 80.w,
                  left: 0.w,
                  width: MediaQuery.of(context).size.width,
                  child: GestureDetector(
                      // onDoubleTap: () => logic.toServerConfig(),
                      behavior: HitTestBehavior.translucent,
                      child: Center(
                        child: Image.asset(
                          ImageRes.ic_appPng,
                          width: 120.h,
                          height: 120.h,
                        ),
                      )),
                ),
                Positioned(
                  top: 249.h,
                  left: 40.w,
                  width: 295.w,
                  child: Obx(() => PhoneEmailInputBox(
                        index: logic.index.value,
                        onChanged: (i) => logic.switchTab(i),
                        onAreaCode: () => logic.openCountryCodePicker(),
                        phoneController: logic.phoneCtrl,
                        emailController: logic.emailCtrl,
                        emailFocusNode: logic.emailFocusNode,
                        phoneFocusNode: logic.phoneFocusNode,
                        labelStyle: PageStyle.ts_333333_14sp,
                        labelSelectedStyle: PageStyle.ts_003F38_14sp,
                        hintStyle: PageStyle.ts_333333_opacity40p_14sp,
                        textStyle: PageStyle.ts_666666_14sp,
                        codeStyle: PageStyle.ts_333333_14sp,
                        code: logic.areaCode.value,
                        showClearBtn: logic.showAccountClearBtn.value,
                        arrowColor: PageStyle.c_898989,
                        clearBtnColor: PageStyle.c_333333,
                        indicatorColor: PageStyle.c_008000,
                      )),
                ),
                Positioned(
                  top: 363.h,
                  left: 40.w,
                  width: 295.w,
                  child: Obx(() => PwdInputBox(
                        controller: logic.pwdCtrl,
                        labelStyle: PageStyle.ts_333333_14sp,
                        hintStyle: PageStyle.ts_333333_opacity40p_14sp,
                        textStyle: PageStyle.ts_666666_18sp,
                        showClearBtn: logic.showPwdClearBtn.value,
                        obscureText: logic.obscureText.value,
                        onClickEyesBtn: () => logic.toggleEye(),
                        clearBtnColor: PageStyle.c_333333,
                        eyesBtnColor: PageStyle.c_333333,
                      )),
                ),
                Positioned(
                  top: 465.h,
                  left: 40.w,
                  child: GestureDetector(
                    onTap: logic.forgetPassword,
                    behavior: HitTestBehavior.translucent,
                    child: Text(
                      StrRes.forgetPwd,
                      style: PageStyle.ts_333333_14sp,
                    ),
                  ),
                ),
                Positioned(
                  top: 465.h,
                  right: 40.w,
                  child: GestureDetector(
                    onTap: () => logic.register(),
                    behavior: HitTestBehavior.translucent,
                    child: Obx(() => Text(
                          logic.index.value == 0
                              ? StrRes.phoneRegister
                              : StrRes.emailRegister,
                          style: PageStyle.ts_003F38_14sp,
                        )),
                  ),
                ),
                Positioned(
                  top: 520.h,
                  left: 40.w,
                  width: 295.w,
                  child: DebounceButton(
                    onTap: () async => await logic.login(),
                    // your tap handler moved here
                    builder: (context, onTap) {
                      return Obx(() => Button(
                            textStyle: logic.enabledLoginButton.value
                                ? PageStyle.ts_FFFFFF_18sp
                                : PageStyle.ts_FFFFFF_opacity40p_18sp,
                            text: StrRes.login,
                            background: logic.enabledLoginButton.value
                                ? PageStyle.c_008000
                                : Color.fromRGBO(0, 128, 0, 0.8),
                            onTap:
                                logic.enabledLoginButton.value ? onTap : null,
                          ));
                    },
                  ),
                  // child: Obx(() => Button(
                  //       textStyle: logic.enabledLoginButton.value
                  //           ? PageStyle.ts_FFFFFF_18sp
                  //           : PageStyle.ts_898989_18sp,
                  //       text: StrRes.login,
                  //       background: logic.enabledLoginButton.value
                  //           ? PageStyle.c_1D6BED
                  //           : PageStyle.c_D8D8D8,
                  //       onTap: logic.enabledLoginButton.value
                  //           ? () => logic.login()
                  //           : null,
                  //     )),
                ),
                Positioned(
                  top: 583.h,
                  width: 375.w,
                  // left: 48.w,
                  // width: 295.w,
                  child: Obx(() => ProtocolView(
                        isChecked: logic.agreedProtocol.value,
                        radioStyle: RadioStyle.BLUE,
                        onTap: () => logic.toggleProtocol(),
                        margin: EdgeInsets.only(top: 20.h),
                        style1: PageStyle.ts_333333_12sp,
                        style2: PageStyle.ts_003F38_12sp,
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
