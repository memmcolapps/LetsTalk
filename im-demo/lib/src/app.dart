import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
// import 'package:openim_demo/src/core/controller/amap_controller.dart';
import 'package:openim_demo/src/core/controller/cache_controller.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_pages.dart';
import 'package:openim_demo/src/utils/logger_util.dart';
import 'package:openim_demo/src/widgets/app_view.dart';
// import 'package:openim_demo/src/widgets/im_widget.dart';

import 'core/controller/im_controller.dart';
import 'core/controller/jpush_controller.dart';
import 'core/controller/permission_controller.dart';

class EnterpriseChatApp extends StatelessWidget {
  const EnterpriseChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppView(
      builder: (locale, builder) => GetMaterialApp(
        debugShowCheckedModeBanner: true,
        enableLog: true,
        builder: builder,
        logWriterCallback: Logger.print,
        translations: TranslationService(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          // DefaultCupertinoLocalizations.delegate,
        ],
        fallbackLocale: TranslationService.fallbackLocale,
        locale: locale,
        localeResolutionCallback: (locale, list) {
          Get.locale ??= locale;
          return locale;
        },
        supportedLocales: [
          const Locale('zh', 'CN'),
          const Locale('en', 'US'),
        ],
        getPages: AppPages.routes,
        initialBinding: InitBinding(),
        initialRoute: AppRoutes.SPLASH,
      ),
    );
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    /// 权限
    Get.put<PermissionController>(PermissionController());

    /// IM通讯
    Get.put<IMController>(IMController());
    // Get.put<CallController>(CallController());
    /// 极光推送
    Get.put<JPushController>(JPushController());
    // Get.put<PushController>(PushController());
    // Get.put<AmapController>(AmapController());
    Get.put<CacheController>(CacheController());
  }
}
