// import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';

class HeaderView extends StatelessWidget {
  final imLogic = Get.find<IMController>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 320,
      color: Color(0XFFFEFFFE),
      child: Stack(
        children: <Widget>[
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 40,
              child: Image.asset(
                ImageRes.ic_header_bg,
                fit: BoxFit.fill,
              )),
          Positioned(
              right: 15,
              bottom: 20,
              child: Container(
                  width: 60,
                  height: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: AvatarView(
                        size: 100.h,
                        url: imLogic.userInfo.value.faceURL,
                        borderRadius: BorderRadius.circular(8)),
                  ))),
          Positioned(
            right: 100,
            bottom: 50,
            child: Text(
              "sunnytu",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))]),
            ),
          )
        ],
      ),
    );
  }
}
