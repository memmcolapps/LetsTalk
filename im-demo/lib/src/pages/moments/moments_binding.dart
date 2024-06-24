import 'package:get/get.dart';

import 'moments_logic.dart';

class MomentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MomentsLogic());
  }
}
