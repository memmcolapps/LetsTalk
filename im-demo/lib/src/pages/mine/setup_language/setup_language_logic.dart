import 'dart:ui';

import 'package:get/get.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

class SetupLanguageLogic extends GetxController {
  var isFollowSystem = false.obs;
  var isChinese = false.obs;
  var isEnglish = false.obs;

  @override
  void onInit() {
    _initLanguageSetting();
    super.onInit();
  }

  void _initLanguageSetting() {
    var language = DataPersistence.getLanguage() ?? 0;
    switch (language) {
      case 1:
        isFollowSystem.value = false;
        isChinese.value = true;
        isEnglish.value = false;
        break;
      case 2:
        isFollowSystem.value = false;
        isChinese.value = false;
        isEnglish.value = true;
        break;
      default:
        isFollowSystem.value = true;
        isChinese.value = false;
        isEnglish.value = false;
        break;
    }
  }

  void switchNotEnabled() async {
    IMWidget.showToast(StrRes.notEnabledLanguages);
  }

  void switchLanguage(index) async {
    await DataPersistence.putLanguage(index);
    switch (index) {
      case 1:
        isFollowSystem.value = false;
        isChinese.value = true;
        isEnglish.value = false;
        Get.updateLocale(Locale('zh', 'CN'));
        break;
      case 2:
        isFollowSystem.value = false;
        isChinese.value = false;
        isEnglish.value = true;
        Get.updateLocale(Locale('en', 'US'));
        break;
      default:
        isFollowSystem.value = true;
        isChinese.value = false;
        isEnglish.value = false;
        Get.updateLocale(window.locale);
        break;
    }
  }
}
