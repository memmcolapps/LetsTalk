import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/app_controller.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsLogic extends GetxController {
  var version = "".obs;
  var appLogic = Get.find<AppController>();

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    // String buildNumber = packageInfo.buildNumber;
    version.value = packageInfo.version;
  }

  void test() {
    EasyLoading.showToast("等待测试");
  }

  void checkUpdate() {
    EasyLoading.showToast("已经是最新");
    // appLogic.checkUpdate();
  }

  @override
  void onReady() {
    getPackageInfo();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
