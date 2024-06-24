import 'package:get/get.dart';
import 'people_nearby_logic.dart';

class PeopleNearbyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PeopleNearbyLogic());
  }
}
