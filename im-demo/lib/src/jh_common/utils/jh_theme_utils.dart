import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openim_demo/src/res/styles.dart';

import 'jh_device_utils.dart';

class JhThemeUtils {
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color? getDarkColor(BuildContext context, Color darkColor) {
    return isDark(context) ? darkColor : null;
  }

  static ui.Color? getIconColor(BuildContext context) {
    return isDark(context) ? PageStyle.dark_text : null;
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static Color getDialogBackgroundColor(BuildContext context) {
    return Theme.of(context).canvasColor;
  }

  static Color getStickyHeaderColor(BuildContext context) {
    return isDark(context) ? PageStyle.dark_bg_gray_ : PageStyle.bg_gray_;
  }

  static Color getDialogTextFieldColor(BuildContext context) {
    return isDark(context) ? PageStyle.dark_bg_gray_ : PageStyle.bg_color;
  }

  static ui.Color? getKeyboardActionsColor(BuildContext context) {
    return isDark(context) ? PageStyle.dark_bg_color : Colors.grey[200];
  }

  /// 设置NavigationBar样式
  static void setSystemNavigationBarStyle(
      BuildContext context, ThemeMode mode) {
    /// 仅针对安卓
    if (JhDevice.isAndroid) {
      bool _isDark = false;
      final ui.Brightness platformBrightness =
          MediaQuery.platformBrightnessOf(context);
      print(platformBrightness);
      if (mode == ThemeMode.dark ||
          (mode == ThemeMode.system &&
              platformBrightness == ui.Brightness.dark)) {
        _isDark = true;
      }
      print(_isDark);
      final SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor:
            _isDark ? PageStyle.dark_bg_color : Colors.white,
        systemNavigationBarIconBrightness:
            _isDark ? Brightness.light : Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}
