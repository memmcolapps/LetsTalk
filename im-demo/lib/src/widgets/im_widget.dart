import 'dart:io';

import 'dart:async';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:openim_demo/src/pages/register/select_avatar/select_avatar_view.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/utils/http_util.dart';
import 'package:openim_demo/src/utils/im_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sprintf/sprintf.dart';

import '../core/controller/call_controller.dart';
import '../pages/chat/group_setup/group_member_manager/member_list/member_list_logic.dart';
import '../routes/app_navigator.dart';
import 'bottom_sheet_view.dart';
import 'call_view.dart';

class IMWidget {
  static final ImagePicker _picker = ImagePicker();

  static void openPhotoSheet({
    Function(String path, String? url)? onData,
    bool crop = true,
    bool toUrl = true,
    bool isAvatar = false,
    bool fromGallery = true,
    bool fromCamera = true,
    Function(int? index)? onIndexAvatar,
  }) {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          if (isAvatar)
            SheetItem(
              label: StrRes.defaultAvatar,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              onTap: () async {
                var index = await Get.to(() => SelectAvatarPage());
                onIndexAvatar?.call(index);
              },
            ),
          if (fromGallery)
            SheetItem(
              label: StrRes.album,
              borderRadius: isAvatar
                  ? null
                  : BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
              onTap: () {
                PermissionUtil.storage(() async {
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (null != image?.path) {
                    var map = await _uCropPic(
                      image!.path,
                      crop: crop,
                      toUrl: toUrl,
                    );
                    onData?.call(map['path'], map['url']);
                  }
                });
              },
            ),
          if (fromCamera)
            SheetItem(
              label: StrRes.camera,
              onTap: () {
                PermissionUtil.camera(() async {
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (null != image?.path) {
                    var map = await _uCropPic(
                      image!.path,
                      crop: crop,
                      toUrl: toUrl,
                    );
                    onData?.call(map['path'], map['url']);
                  }
                });
              },
            ),
        ],
      ),
    );
  }

  static Future<Map<String, dynamic>> _uCropPic(
    String path, {
    bool crop = true,
    bool toUrl = true,
  }) async {
    CroppedFile? cropFile;
    String? url;
    if (crop) {
      cropFile = await IMUtil.uCrop(path);
      if (cropFile == null) {
        // 放弃选择
        return {'path': cropFile?.path ?? path, 'url': url};
      }
    }

    if (toUrl) {
      if (null != cropFile) {
        print('-----------crop path: ${cropFile.path}');
        url = await HttpUtil.uploadImage(path: cropFile.path);
      } else {
        print('-----------source path: $path');
        url = await HttpUtil.uploadImage(path: path);
      }
      print('url:$url');
    }
    return {'path': cropFile?.path ?? path, 'url': url};
  }

  static void showToast(String msg) {
    if (msg.trim().isNotEmpty) EasyLoading.showToast(msg);
  }

  static void openIMCallSheet({
    required String uid,
    required String name,
    String? icon,
  }) {
    Get.bottomSheet(
      BottomSheetView(
        itemBgColor: PageStyle.c_FFFFFF,
        items: [
          SheetItem(
            label: sprintf(StrRes.callX, [name]),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            textStyle: PageStyle.ts_666666_16sp,
            height: 53.h,
          ),
          SheetItem(
            label: StrRes.callVoice,
            icon: ImageRes.ic_callVoice,
            alignment: MainAxisAlignment.start,
            onTap: () {
              // IMCallView.call(
              //   uid: uid,
              //   name: name,
              //   icon: icon,
              //   state: CallState.CALL,
              //   type: 'voice',
              // );
            },
          ),
          SheetItem(
            label: StrRes.callVideo,
            icon: ImageRes.ic_callVideo,
            alignment: MainAxisAlignment.start,
            onTap: () {
              // IMCallView.call(
              //   uid: uid,
              //   name: name,
              //   icon: icon,
              //   state: CallState.CALL,
              //   type: 'video',
              // );
            },
          ),
        ],
      ),
      // barrierColor: Colors.transparent,
    );
  }

  // static void openIMGroupCallSheet({
  //   required String groupID,
  //   required Function(int index, List<String> inviteeUserIDList) onTap,
  // }) {
  //   Get.bottomSheet(
  //     BottomSheetView(
  //       itemBgColor: PageStyle.c_FFFFFF,
  //       items: [
  //         SheetItem(
  //           label: StrRes.callVoice,
  //           icon: ImageRes.ic_callVoice,
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(30),
  //             topRight: Radius.circular(30),
  //           ),
  //           alignment: MainAxisAlignment.start,
  //           onTap: () => _groupCall(gid, 'voice'),
  //         ),
  //         SheetItem(
  //           label: StrRes.callVideo,
  //           icon: ImageRes.ic_callVideo,
  //           alignment: MainAxisAlignment.start,
  //           onTap: () => _groupCall(gid, 'video'),
  //         ),
  //       ],
  //     ),
  //     // barrierColor: Colors.transparent,
  //   );
  // }

  // static _groupCall(String gid, String streamType) async {
  //   var result = await AppNavigator.startGroupMemberList(
  //     gid: gid,
  //     defaultCheckedUidList: [OpenIM.iMManager.uid],
  //     action: OpAction.GROUP_CALL,
  //   );
  //   if (result != null) {
  //     List<String> uidList = result;
  //     AppNavigator.startGroupCall(
  //       gid: gid,
  //       senderUid: OpenIM.iMManager.uid,
  //       receiverIds: uidList,
  //       type: streamType,
  //       state: CallState.CALL,
  //     );
  //   }
  // }


  static Future<String?> showCountryCodePicker() async {
    Completer<String> completer = Completer();
    showCountryPicker(
      context: Get.context!,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 16.sp, color: Colors.blueGrey),
        bottomSheetHeight: 500.h,
        // Optional. Country list modal height
        //Optional. Sets the border radius for the bottomsheet.
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0.r),
          topRight: Radius.circular(8.0.r),
        ),
        //Optional. Styles the search field.
        inputDecoration: InputDecoration(
          labelText: StrRes.search,
          // hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        completer.complete("+" + country.phoneCode);
      },
    );
    return completer.future;
  }

  static void openPickMultiSheet({
    Function(List<String>? url)? onData,
    bool crop = false,
    bool toUrl = true,
    bool isAvatar = false,
    Function(int? index)? onIndexAvatar,
  }) {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          if (isAvatar)
            SheetItem(
              label: StrRes.defaultAvatar,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              onTap: () async {
                var index = await Get.to(() => SelectAvatarPage());
                onIndexAvatar?.call(index);
              },
            ),
          SheetItem(
            label: StrRes.album,
            borderRadius: isAvatar
                ? null
                : BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
            onTap: () {
              PermissionUtil.storage(() async {
                var image = await _picker.pickMultiImage();
                if (image != null && image.length != 0) {
                  List<String> list = [];
                  for (var item in image) {
                    var map = await _uCropPic(
                      item.path,
                      crop: crop,
                      toUrl: toUrl,
                    );
                    list.add(map['url']);
                  }
                  onData?.call(list);
                  // IMWidget.showToast(item.path);
                } else {
                  // IMWidget.showToast('至少选择一张图片');
                  return;
                }
              });
            },
          ),
          SheetItem(
            label: StrRes.camera,
            onTap: () {
              PermissionUtil.camera(() async {
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                List<String> list = [];
                if (null != image?.path) {
                  var map = await _uCropPic(
                    image!.path,
                    crop: crop,
                    toUrl: toUrl,
                  );
                  list.add(map['url']);
                  onData?.call(list);
                }
              });
            },
          ),
        ],
      ),
    );
  }

  static void openNoDisturbSettingSheet(
      {bool isGroup = false, Function(int index)? onTap}) {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          SheetItem(
            label: StrRes.receiveMessageButNotPrompt,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            onTap: () => onTap?.call(0),
          ),
          SheetItem(
            label: isGroup ? StrRes.blockGroupMessages : StrRes.blockFriends,
            onTap: () => onTap?.call(1),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter() => CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            // body = Text("pull up load");
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            // body = Text("Load Failed!Click retry!");
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.canLoading) {
            // body = Text("release to load more");
            body = CupertinoActivityIndicator();
          } else {
            // body = Text("No more Data");
            body = SizedBox();
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      );
}
