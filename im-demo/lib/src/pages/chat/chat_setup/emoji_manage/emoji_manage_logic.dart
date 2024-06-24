import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/cache_controller.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../../utils/data_persistence.dart';

class EmojiManageLogic extends GetxController {
  var cacheLogic = Get.find<CacheController>();
  var model = 0.obs;
  var selectedList = <String>[].obs;

  void addFavorite() async {
    var language = DataPersistence.getLanguage() ?? 0;
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: AssetPickerConfig(requestType: RequestType.image, textDelegate: language == 2  ? EnglishAssetPickerTextDelegate() : AssetPickerTextDelegate(),),
    );
    if (null != assets) {
      for (var asset in assets) {
        var path = (await asset.file)!.path;
        var width = asset.width;
        var height = asset.height;
        switch (asset.type) {
          case AssetType.image:
            cacheLogic.addFavoriteFromPath(path, width, height);
            break;
          default:
            break;
        }
      }
    }
  }

  void updateSelectedStatus(String url, bool selected) {
    if (selected) {
      selectedList.add(url);
    } else {
      selectedList.remove(url);
    }
  }

  void manage() {
    model.value = 1;
    selectedList.clear();
  }

  void completed() {
    model.value = 0;
    selectedList.clear();
  }

  void delete() {
    if (selectedList.isNotEmpty) {
      cacheLogic.delFavoriteList(selectedList);
      selectedList.clear();
    }
  }
}
