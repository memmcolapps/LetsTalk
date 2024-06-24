import 'dart:convert';
import 'dart:io';

import 'package:flutter_luban/flutter_luban.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/widgets/bottom_sheet_view.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../../utils/im_util.dart';
import 'moments_view.dart';

class MomentsLogic extends GetxController {
  var imLogic = Get.find<IMController>();
  // var friendApplicationList = <UserInfo>[];
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    // getFrequentContacts();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // 刷新朋友圈数据
  void reloadData() {

  }

  //点击cell
  void clickCell(text) {
    // IMWidget.showToast('点击 ${text}');
  }

  void clickPublish() {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          SheetItem(
            label: StrRes.album,
            borderRadius: null,
            onTap: () {
              PermissionUtil.storage(() async {
                var language = DataPersistence.getLanguage() ?? 0;
                final List<AssetEntity>? assets =
                    await AssetPicker.pickAssets(Get.context!,
                      pickerConfig: AssetPickerConfig(
                          requestType: RequestType.common,
                          textDelegate: language == 2  ? EnglishAssetPickerTextDelegate() : AssetPickerTextDelegate(),
                          specialPickerType: SpecialPickerType.wechatMoment,
                          filterOptions: FilterOptionGroup(),
                        ),
                        //   ..setOption(
                        //     AssetType.image,
                        //     const FilterOption(
                        //       durationConstraint: DurationConstraint(
                        //         max: Duration(minutes: 1),
                        //       ),
                        //     ),
                        //   ),
                        );
                List<String> imgs = [];
                if (null != assets) {
                  print(assets.first.file);
                  if (assets.length > 0) {
                    for (var asset in assets) {
                      File? file = await asset.file;
                      File? image = file;
                      if (image == null) {
                        return;
                      }
                      // IMWidget.showToast(file!.path + '真实路径');
                      // imgs.add(image.path);
                      // File? newImg = await IMUtil.compressAndGetPic(image);
                      File? newImg =
                          await IMUtil.compressAndGetPic(image, 1920, 1680, 80);
                      // var name =
                      // file!.path.substring(file.path.lastIndexOf("/"));
                      // var targetPath = await IMUtil.createTempFile(
                      //     fileName: name, dir: 'pic');
                      var path = (Platform.isIOS
                              ? await getTemporaryDirectory()
                              : await getExternalStorageDirectory())
                          ?.path;

                      imgs.add(newImg!.path);
                      // image.path
                      // CompressObject compressObject = CompressObject(
                      //     imageFile: image, //image
                      //     path: '$path/pic/',
                      //     quality: 70 //compress to path
                      //     );
                      // await Luban.compressImage(compressObject)
                      //     .then((_path) async {
                      //   // IMWidget.showToast(_path.toString());
                      //   imgs.add(_path!);
                      // }).catchError((onError) => {print(onError)});
                    }
                    // IMWidget.showToast(imgs.toString());
                    AppNavigator.startPublish(type: 'image', url: imgs);
                  } else {
                    IMWidget.showToast('null images');
                  }
                }
              });
            },
          ),
          SheetItem(
            label: StrRes.camera,
            onTap: () {
              PermissionUtil.camera(() async {
                var language = DataPersistence.getLanguage() ?? 0;
                final AssetEntity? entity = await CameraPicker.pickFromCamera(
                  Get.context!,
                    pickerConfig: CameraPickerConfig(
                      enableRecording: false,
                      textDelegate: language == 2  ? EnglishCameraPickerTextDelegate() : CameraPickerTextDelegate(),
                    )
                );
                _handleAssets(entity);
              });
            },
          ),
        ],
      ),
    );
  }

  void _handleAssets(AssetEntity? asset) async {
    if (null != asset) {
      File? file = await asset.file;
      var img = await IMUtil.compressAndGetPic(file!, 1920, 1680, 80);
      print('--------assets type-----${asset.type}');
      var _path = img!.path;
      print('--------assets path-----$_path');
      switch (asset.type) {
        case AssetType.image:
          AppNavigator.startPublish(type: 'image', url: [_path]);
          //如果图片
          // sendPicture(path: path);
          break;
        default:
          break;
      }
    }
  }

  void clickNav(context) {
    IMWidget.openPickMultiSheet(
        isAvatar: false,
        onData: (url) {
          if (url != null && url.length >= 1) {
            // IMWidget.showToast(url);
            // OpenIM.iMManager.setSelfInfo(icon: url);
            AppNavigator.startPublish(type: 'image', url: []);
          }
        },
        crop: false);
  }

  void jumpInfo() {
    //跳转个人信息页 跳转传递model

    // ContactsModel model = ContactsModel(tagIndex: '');
    // model.id = 123;
    // model.name = '小于';
    // model.namePinyin = '小于';
    // model.phone = '17372826674';
    // model.sex = '0';
    // model.region = '淮北市';
    // model.label = '';
    // model.color = '#c579f2';
    // model.avatarUrl = 'https://gitee.com/iotjh/Picture/raw/master/lufei.png';
    // model.isStar = false;

    // String jsonStr = Uri.encodeComponent(jsonEncode(model));
    // AppNavigator.startMoments(
    //     uid: model.id.toString(),
    //     name: model.name.toString(),
    //     userInfo: jsonStr);
    // IMWidget.showToast('点击自己的朋友圈');
    // NavigatorUtils.pushNamed(
    // context, '${"WxUserInfoPage"}?passValue=${jsonStr}');
  }
}
