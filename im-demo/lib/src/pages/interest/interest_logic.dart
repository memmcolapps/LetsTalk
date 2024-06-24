import 'dart:async';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/core/controller/amap_controller.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/widgets/custom_dialog.dart';

class InterestLogic extends GetxController {
  // final ampLogic = Get.find<AmapController>();
  late Rx<UserInfo> info;
  Map<String, Object>? _locationResult;
  final imLogic = Get.find<IMController>();

  StreamSubscription<Map<String, Object>>? _locationListener;
  AMapFlutterLocation _locationPlugin = AMapFlutterLocation();

  @override
  void onInit() {
    super.onInit();
    // _locationResult = ampLogic.getLocationResult();
    // IMWidget.showToast(_locationResult.toString());
    _locationListener = _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      _locationResult = result;
      print('------_locationResult:${_locationResult}------');
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void goMoments() {
    // IMWidget.showToast('点击了关于');
    AppNavigator.startMoments();
  }

  void goScan() {
    AppNavigator.startScanQrcode();
  }

  void goPeopleNearby() async {
    var latitude;
    var longitude;
    // _locationResult = ampLogic.getLocationResult();
    // _locationResult?.forEach((key, value) {
    //   print("$key: $value");
    //   if (key == "latitude") {
    //     latitude = value;
    //   } else if (key == "longitude") {
    //     longitude = value;
    //   }
    // });
    var confirm = await Get.dialog(CustomDialog(
      title: StrRes.areYouSureOpenPeopleNearby,
      rightText: StrRes.sure,
    ));
    if (confirm == true) {
      var result = await Apis.openPeopleNearby(
        uid: imLogic.userInfo.value.userID!,
        latitude: latitude,
        longitude: longitude,
      );
      if (result != null) {
        AppNavigator.startPeopleNearby();
      } else {}
      // print('result:$result');
    }
  }
}
