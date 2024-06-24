import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

import '../res/strings.dart';
import '../utils/data_persistence.dart';
import '../utils/navigator_utils.dart';
import 'common_webview.dart';

class ProtocolModel {
  late TapGestureRecognizer _registProtocolRecognizer;
  late TapGestureRecognizer _privacyProtocolRecognizer;

  ///用来显示 用户协议对话框
  Future<bool> showProtocolFunction(BuildContext context) async {
    //注册协议的手势
    _registProtocolRecognizer = TapGestureRecognizer();
    //隐私协议的手势
    _privacyProtocolRecognizer = TapGestureRecognizer();

    //苹果风格弹框
    bool isShow = await showCupertinoDialog(
      //上下文对象
      context: context,
      //对话框内容
      builder: (BuildContext context) {
        return cupertinoAlertDialog(context);
      },
    );

    ///销毁
    _registProtocolRecognizer.dispose();
    _privacyProtocolRecognizer.dispose();

    return Future.value(isShow);
  }

  CupertinoAlertDialog cupertinoAlertDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(StrRes.kindTips),
      content: Container(
        height: 300,
        padding: EdgeInsets.all(12),
        //可滑动布局
        child: SingleChildScrollView(
          child: buildContent(context),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          child: Text(StrRes.refuse),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        CupertinoDialogAction(
          child: Text(StrRes.approve),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }

  buildContent(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: StrRes.plsReadAgree,
          style: TextStyle(color: Colors.grey[600]),
          children: [
            TextSpan(
              text: StrRes.serviceAgreement,
              style: TextStyle(color: Colors.blue),
              //点击事件
              recognizer: _registProtocolRecognizer
                ..onTap = () {
                  //打开用户协议
                  openUserProtocol(context);
                },
            ),
            TextSpan(
              text: StrRes.and,
              style: TextStyle(color: Colors.grey[600]),
            ),
            TextSpan(
              text: StrRes.privacyPolicy,
              style: TextStyle(color: Colors.blue),
              //点击事件
              recognizer: _privacyProtocolRecognizer
                ..onTap = () {
                  //打开隐私协议
                  openPrivateProtocol(context);
                },
            ),
            TextSpan(
              text: StrRes.userPrivateProtocol,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ]),
    );
  }

  //查看用户协议
  void openUserProtocol(BuildContext context) {
    NavigatorUtils.pushPage(
      context: context,
      targPage: CommonWebViewPage(
        pageTitle: StrRes.serviceAgreement,
        htmlUrl: "https://www.letstalk.com.ng/agreement/" +
            getLocale()!.languageCode.toString() +
            "/agreement.html",
      ),
    );
  }

  //查看隐私协议
  void openPrivateProtocol(BuildContext context) {
    NavigatorUtils.pushPage(
      context: context,
      targPage: CommonWebViewPage(
        pageTitle: StrRes.privacyPolicy,
        htmlUrl: "https://www.letstalk.com.ng/agreement/" +
            getLocale()!.languageCode.toString() +
            "/privacy.html",
      ),
    );
  }

  Locale? getLocale() {
    var local = Get.locale;
    var index = DataPersistence.getLanguage() ?? 0;
    switch (index) {
      case 1:
        local = Locale('zh', 'CN');
        break;
      case 2:
        local = Locale('en', 'US');
        break;
    }
    return local;
  }
}
