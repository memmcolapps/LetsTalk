/**
 *  base_appbar.dart
 *
 *  Created by iotjin on 2020/03/10.
 *  description:  导航条
 */

import 'package:flutter/material.dart';
import 'package:openim_demo/src/res/styles.dart';

const Color _navbgColor = Color(0xFF3BB815);
const Color _titleColorWhite = Colors.white;
const Color _titleColorBlack = Colors.black;
const double _titleFontSize = 18.0;
const double _textFontSize = 16.0;
const double _itemSpace = 15.0; //右侧item内间距
const double _imgWH = 22.0; //右侧图片wh
const double _rightSpace = 5.0; //右侧item右间距
const Brightness _brightness = Brightness.dark;

const Color appbarStartColor = Color(0xFF2683BE); //渐变开始色
const Color appbarEndColor = Color(0xFF34CABE); //渐变结束色

/*带返回箭头导航条*/
backAppBar(BuildContext context, String title,
    {String? rightText,
    String? rightImgPath,
    Color backgroundColor = _navbgColor,
    Brightness brightness = _brightness,
    Function? rightLongCallBack,
    Function? rightItemCallBack,
    Function? backCallBack}) {
  return baseAppBar(
    context,
    title,
    isBack: true,
    rightText: rightText,
    rightImgPath: rightImgPath,
    rightLongCallBack: rightLongCallBack,
    rightItemCallBack: rightItemCallBack,
    leftItemCallBack: backCallBack,
    backgroundColor: backgroundColor,
    brightness: brightness,
  );
}

//baseAppBar
baseAppBar(
  BuildContext context,
  String title, {
  String? rightText,
  String? rightImgPath,
  Widget? leftItem,
  bool isBack: false,
  Color backgroundColor = _navbgColor,
  Brightness brightness = _brightness,
  double elevation: 0,
  PreferredSizeWidget? bottom,
  Function? rightItemCallBack,
  Function? rightLongCallBack,
  Function? leftItemCallBack,
}) {
  Color _color = (backgroundColor == Colors.transparent ||
          backgroundColor == Colors.white ||
          backgroundColor == PageStyle.kWeiXinBgColor)
      ? _titleColorBlack
      : _titleColorWhite;

  Widget rightItem = Text("");
  if (rightText != null) {
    rightItem = InkWell(
      child: Container(
          margin: EdgeInsets.all(_itemSpace),
          color: Colors.transparent,
          child: Center(
              child: Text(rightText,
                  style: TextStyle(fontSize: _textFontSize, color: _color)))),
      onTap: () {
        if (rightItemCallBack != null) {
          rightItemCallBack();
        }
      },
      onLongPress: () {
        if (rightLongCallBack != null) {
          rightLongCallBack();
        }
      },
    );
  }
  if (rightImgPath != null) {
    rightItem = InkWell(
        onLongPress: () {
          if (rightLongCallBack != null) {
            rightLongCallBack();
          }
        },
        child: Container(
            child: IconButton(
                icon: Image.asset(
                  rightImgPath,
                  width: _imgWH,
                  height: _imgWH,
                  color: _color,
                ),
                onPressed: () {
                  if (rightItemCallBack != null) {
                    rightItemCallBack();
                  }
                })));
  }
  return AppBar(
    title:
        Text(title, style: TextStyle(fontSize: _titleFontSize, color: _color)),
    centerTitle: true,
    backgroundColor: backgroundColor,
    brightness: brightness,
    bottom: bottom,
    elevation: elevation,
    leading: isBack == false
        ? leftItem
        : IconButton(
//      icon: Icon(Icons.arrow_back_ios,color: _color),
            icon: ImageIcon(
              AssetImage("assets/images/common/ic_nav_back_white.png"),
              color: _color,
            ),
            iconSize: 18,
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            onPressed: () {
              if (leftItemCallBack == null) {
                _popThis(context);
              } else {
                leftItemCallBack();
              }
            },
          ),
    actions: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          rightItem,
          SizedBox(width: _rightSpace),
        ],
      ),
    ],
  );
}

void _popThis(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}
