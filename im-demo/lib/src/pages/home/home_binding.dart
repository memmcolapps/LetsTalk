import 'package:get/get.dart';
import 'package:openim_demo/src/pages/contacts/contacts_logic.dart';
import 'package:openim_demo/src/pages/conversation/conversation_logic.dart';
import 'package:openim_demo/src/pages/mine/mine_logic.dart';
import 'package:openim_demo/src/pages/interest/interest_logic.dart';

import '../workbench/workbench_logic.dart';
import 'home_logic.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLogic());
    Get.lazyPut(() => InterestLogic());
    Get.lazyPut(() => ConversationLogic());
    Get.lazyPut(() => ContactsLogic());
    Get.lazyPut(() => MineLogic());
    Get.lazyPut(() => WorkbenchLogic());
  }
}
