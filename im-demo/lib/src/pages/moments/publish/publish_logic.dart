import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/pages/moments/moments_logic.dart';

import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:rxdart/rxdart.dart' as rx;
import '../../../models/image.dart';
import '../../../utils/http_util.dart';
import '../../../widgets/loading_view.dart';

class PublishLogic extends GetxController {
  var imLogic = Get.find<IMController>();
  var momLogic = Get.find<MomentsLogic>();
  // var friendApplicationList = <UserInfo>[];

  var inputCtrl = TextEditingController();
  final momentSubject = rx.PublishSubject<bool>();
  bool isLoad = false;

  @override
  void onInit() {

    super.onInit();
  }

  void publish(String type, List<ImageBean?> imgList) async {
    try {
      if (isLoad) {
        return;
      }
      IMWidget.showToast(StrRes.plsWaiting);
      await LoadingView.singleton.wrap(asyncFunction: () async {
        var list = [];
        if (type == "text") {
          if (inputCtrl.value.text.length == 0) {
            IMWidget.showToast(StrRes.publishText);
            return;
          }
        } else if (type == "image") {
          if (imgList.length <= 0) {
            IMWidget.showToast(StrRes.publishImages);
            return;
          }
          for (int i = 0; i < imgList.length; i++) {
            var path = imgList[i]!.thumbPath;
            var url = await HttpUtil.uploadImage(path: path!);
            // IMWidget.showToast(url);
            list.add(url);
          }
        }
        var data = Apis.publishMoment(
            uid: imLogic.userInfo.value.userID.toString(),
            content: inputCtrl.value.text,
            images: list.join(","));
        print({data, '发布朋友圈'});

        isLoad = false;
        //TODO: 刷新最新数据
        // momentSubject.addSafely(true);
        // momLogic.reloadData();
        Get.back();
        IMWidget.showToast(StrRes.momentsDone);
      });
    } catch (e) {
      IMWidget.showToast('e:$e');
      isLoad = false;
    }
  }

  @override
  void onReady() {
    // getFrequentContacts();
    super.onReady();
  }

  @override
  void onClose() {
    momentSubject.close();
    super.onClose();
  }

  local() {}
}
