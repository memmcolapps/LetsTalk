import 'dart:convert';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/models/call_records.dart';
import 'package:openim_demo/src/models/people_nearby.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

class PeopleNearbyLogic extends GetxController {
  var sex = 0.obs;
  var list = <PeopleNearbyUser>[].obs;
  var _needUpdate = false;
  final imLogic = Get.find<IMController>();

  @override
  void onInit() {
    this.getPeopleNearby();
    // list.addAll(DataPersistence.getPeopleNearbyRecords() ?? []);
    // list.forEach((element) {
    //   if (!element.success) {
    //     missedList.add(element);
    //   }
    // });
    print(
        'list----${DateTime.now().millisecondsSinceEpoch}---${json.encode(list)}');
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getPeopleNearby() async{
    var result = await Apis.getPeopleNearby(
      uid: imLogic.userInfo.value.userID!
    );
    List<PeopleNearbyUser> tempList = result.map<PeopleNearbyUser>((item) => PeopleNearbyUser.fromJson(item)).toList();
    list.addAll(tempList);
    if(list.length <= 0){
      IMWidget.showToast(StrRes.nullPeopleNearby);
    }
  }



  void switchTab(index) {
    // this.index.value = index;
  }

  openUser(PeopleNearbyUser peopleNearbyUser) async {
    // IMWidget.showToast(peopleNearbyUser.name);
    AppNavigator.startFriendInfo2(info: UserInfo(userID: peopleNearbyUser.userId));
  }
}
