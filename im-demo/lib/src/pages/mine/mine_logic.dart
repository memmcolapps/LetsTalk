import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/core/controller/jpush_controller.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/utils/im_util.dart';
import 'package:openim_demo/src/widgets/custom_dialog.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:openim_demo/src/widgets/loading_view.dart';

import '../../utils/navigator_utils.dart';
import '../../widgets/common_webview.dart';

class MineLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final jPushLogic = Get.find<JPushController>();

  bool isInit = false;
  // Rx<UserInfo>? userInfo;

  // void getMyInfo() async {
  //   var info = await OpenIM.iMManager.getLoginUserInfo();
  //   userInfo?.value = info;
  // }

  void viewMyQrcode() {
    AppNavigator.startMyQrcode();
    // Get.toNamed(AppRoutes.MY_QRCODE /*, arguments: imLogic.loginUserInfo*/);
  }

  void viewMyInfo() {
    AppNavigator.startMyInfo();
    // Get.toNamed(AppRoutes.MY_INFO /*, arguments: userInfo*/);
  }

  void copyID() {
    IMUtil.copy(text: 'text');
  }

  void accountSetup() {
    AppNavigator.startAccountSetup();
    // Get.toNamed(AppRoutes.ACCOUNT_SETUP);
  }

  void aboutUs() {
    AppNavigator.startAboutUs();
    // Get.toNamed(AppRoutes.ABOUT_US);
  }

  void helpFqa(BuildContext context) {
    NavigatorUtils.pushPage(
      context: context,
      targPage: CommonWebViewPage(
          pageTitle: "Help",
          htmlUrl: "https://www.letstalk.com.ng/letstalk_fqa.pdf"),
    );
  }

  void logout() async {
    var confirm = await Get.dialog(CustomDialog(
      title: StrRes.confirmLogout,
    ));
    if (confirm == true) {
      try {
        await LoadingView.singleton.wrap(asyncFunction: () async {
          await imLogic.logout();
          await DataPersistence.removeLoginCertificate();
          await jPushLogic.logout();
        });
        AppNavigator.startLogin();
      } catch (e) {
        await DataPersistence.removeLoginCertificate();
        AppNavigator.startLogin();
        // AppNavigator.startLogin();
        // IMWidget.showToast('e:$e');
      }
    }
  }

  void kickedOffline() async {
    await DataPersistence.removeLoginCertificate();
    await jPushLogic.logout();
    AppNavigator.startLogin();
  }

  @override
  void onInit() {
    // imLogic.selfInfoUpdatedSubject.listen((value) {
    //   userInfo?.value = value;
    // });
    /// TODO 暂时屏蔽
    imLogic.onKickedOfflineSubject.listen((value) {
      if (isInit) {
        print("登陆失败：" + value);
        Get.snackbar(StrRes.accountWarn, StrRes.accountException);
        kickedOffline();
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    // getMyInfo();
    Future.delayed(Duration(milliseconds: 1000 * 10), () {
      isInit = true;
    });
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
