import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/call_controller.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/core/controller/jpush_controller.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/utils/logger_util.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

import '../../widgets/protocol_model.dart';

class SplashLogic extends GetxController with ProtocolModel {
  final imLogic = Get.find<IMController>();
  // final callLogic = Get.find<CallController>();
  final jPushLogic = Get.find<JPushController>();

  var loginCertificate = DataPersistence.getLoginCertificate();

  bool get isExistLoginCertificate => loginCertificate != null;

  String? get uid => loginCertificate?.userID;

  String? get token => loginCertificate?.token;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    loginCertificate = DataPersistence.getLoginCertificate();
    // DataPersistence.removeAgrement();

    imLogic.initializedSubject.listen((value) async {
      print('---------------------initialized---------------------');
      if (isExistLoginCertificate) {
        initData(() => {_login()});
      } else {
        initData(() => {AppNavigator.startLogin()});
      }
    });

    super.onReady();
  }

  initData(Function()? function) async {
    //读取一下标识
    bool isAgrement = DataPersistence.getAgrement() ?? false;
    if (!isAgrement) {
      isAgrement = await showProtocolFunction(Get.context!);
    }
    if (isAgrement) {
      //同意 保存一下标识
      DataPersistence.putAgrement(true);
      // next();/
      function?.call();
    } else {
      closeApp();
    }
  }

  _login() async {
    try {
      print('---------login---------- uid: $uid, token: $token');
      await imLogic.login(uid!, token!);
      print('---------im login success-------');
      // await callLogic.login(uid!, token!);
      // print('---------ion login success------');
      jPushLogic.login(uid!);
      print('---------jpush login success----');
      AppNavigator.startMain();
    } catch (e) {
      IMWidget.showToast('异常信息：$e');
      // AppNavigator.startLogin();
    }
  }

  void closeApp() {
    exit(0);
  }

  void next() async {
    // _login();
    //判断是否第一次安装应用
    bool? isFirstInstall = DataPersistence.getIsFirstAPP();
    if (isFirstInstall == null) {
      //如果为null 则是第一次安装应用
    } else {}
  }
}
