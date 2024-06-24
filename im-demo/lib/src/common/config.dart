import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/utils/http_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sp_util/sp_util.dart';

class Config {
  //初始化全局信息
  static Future init(Function() runApp) async {
    WidgetsFlutterBinding.ensureInitialized();
    cachePath = (await getApplicationDocumentsDirectory()).path;
    await SpUtil.getInstance();
    await Hive.initFlutter(cachePath);
    // await SpeechToTextUtil.instance.initSpeech();
    HttpUtil.init();
    runApp();
    // 设置屏幕方向
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // 状态栏透明（Android）
    var brightness = Platform.isAndroid ? Brightness.dark : Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ));
    //TODO 设置配置为中文
    DataPersistence.putLanguage(2);
    Get.updateLocale(Locale('en', 'US'));

    // FlutterBugly.init(androidAppId: "2687d5a8d4", iOSAppId: "65a10f8cd4");
  }

  static late String cachePath;

  static const UI_W = 375.0;
  static const UI_H = 820.0;

  /// 秘钥
  static const secret = 'tuoyun';

  /// ip
  static const defaultIp = "192.168.1.16";
    // static const defaultIp = "app-ng.letstalk.com.ng";

  /// 服务器IP
  static String serverIp() {
    var ip;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      ip = server['serverIP'];
      print('缓存serverIP: $ip');
    }
    return ip ?? defaultIp;
  }

  /// 登录注册手机验 证服务器地址
  static String appAuthUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['authUrl'];
      print('缓存authUrl: $url');
    }
    return url ?? "http://$defaultIp/demo";
    // return url ?? "http://$defaultIp/10004";
  }

  /// IM sdk api地址
  static String imApiUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['apiUrl'];
      print('缓存apiUrl: $url');
    }
    return url ?? 'http://$defaultIp/api';
    // return url ?? 'http://$defaultIp:10002';
  }

  /// IM ws 地址
  static String imWsUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['wsUrl'];
      print('缓存wsUrl: $url');
    }
    return url ?? 'ws://$defaultIp/msg_gateway';
    // return url ?? 'ws://$defaultIp:10001';
  }

  /// 音视频通话地址
  static String callUrl() {
    var url;
    var server = DataPersistence.getServerConfig();
    if (null != server) {
      url = server['callUrl'];
      print('缓存callUrl: $url');
    }
    return url ?? 'http://$defaultIp/rtc';
  }

  /// 朋友圈接口
  static String apiUrl() {
    // var url;
    // var server = DataPersistence.getServerConfig();
    // if (null != server) {
    //   url = server['callUrl'];
    //   print('缓存callUrl: $url');
    // }
    return 'http://192.168.1.17/';
    // return 'http://moments-ng.letstalk.com.ng/';
  }
}
