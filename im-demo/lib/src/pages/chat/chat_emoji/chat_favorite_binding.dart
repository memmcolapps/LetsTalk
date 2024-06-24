import 'package:get/get.dart';

import 'chat_favorite_logic.dart';

class ChatFavoriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatFavoriteLogic());
  }
}
