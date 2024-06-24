import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/app_controller.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/pages/chat/chat_logic.dart';
import 'package:openim_demo/src/pages/select_contacts/select_contacts_logic.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:openim_demo/src/widgets/loading_view.dart';

import '../../../widgets/custom_dialog.dart';

class ChatSetupLogic extends GetxController {
  var topContacts = false.obs;
  var noDisturb = false.obs;
  var blockFriends = false.obs;
  var burnAfterReading = false.obs;
  final chatLogic = Get.find<ChatLogic>();
  final appLogic = Get.find<AppController>();
  final imLogic = Get.find<IMController>();
  String? uid;
  String? name;
  String? icon;
  ConversationInfo? info;
  var noDisturbIndex = 0.obs;

  void toggleTopContacts() async {
    topContacts.value = !topContacts.value;
    if (info == null) return;
    await OpenIM.iMManager.conversationManager.pinConversation(
      conversationID: info!.conversationID,
      isPinned: topContacts.value,
    );
  }

  void toggleNoDisturb() {
    noDisturb.value = !noDisturb.value;
    if (!noDisturb.value) noDisturbIndex.value = 0;
    setConversationRecvMessageOpt(status: noDisturb.value ? 2 : 0);
  }

  void toggleBlockFriends() {
    blockFriends.value = !blockFriends.value;
  }

  void clearChatHistory() async {

    var confirm = await Get.dialog(CustomDialog(
      title: StrRes.areYouSureClearAllHistory,
    ));
    if (confirm == true) {
      try {
        await LoadingView.singleton.wrap(asyncFunction: () async {
          await OpenIM.iMManager.messageManager.clearC2CHistoryMessage(uid: uid!);
          chatLogic.clearAllMessage();
          IMWidget.showToast(StrRes.clearSuccess);
        });
      } catch (e) {
        // AppNavigator.startLogin();
        IMWidget.showToast('e:$e');
      }
    }
    // OpenIM.iMManager.messageManager.deleteMessageFromLocalStorage(message: message)
  }

  void toSelectGroupMember() {
    AppNavigator.startSelectContacts(
      action: SelAction.CRATE_GROUP,
      defaultCheckedUidList: [uid!],
    );
    // Get.toNamed(
    //   AppRoutes.SELECT_CONTACTS,
    //   arguments: {
    //     'action': SelAction.CRATE_GROUP,
    //     'uidList': [uid]
    //   },
    // );
  }

  @override
  void onInit() {
    uid = Get.arguments['uid'];
    name = Get.arguments['name'];
    icon = Get.arguments['icon'];
    imLogic.conversationChangedSubject.listen((newList) {
      for (var newValue in newList) {
        if (newValue.conversationID == info?.conversationID) {
          burnAfterReading.value = newValue.isPrivateChat!;
          break;
        }
      }
    });
    super.onInit();
  }

  void getConversationInfo() async {
    info = await OpenIM.iMManager.conversationManager.getOneConversation(
      sourceID: uid!,
      sessionType: 1,
    );
    topContacts.value = info!.isPinned!;
  }

  /// 消息免打扰
  /// 1: Do not receive messages, 2: Do not notify when messages are received; 0: Normal
  /// [{"conversationId":"single_13922222222","result":0}]
  void getConversationRecvMessageOpt() async {
    var list = await OpenIM.iMManager.conversationManager
        .getConversationRecvMessageOpt(
      conversationIDList: ['single_$uid'],
    );
    if (list.isNotEmpty) {
      var map = list.first;
      var status = map['result'];
      noDisturb.value = status != 0;
      if (noDisturb.value) {
        noDisturbIndex.value = status == 1 ? 1 : 0;
      }
    }
  }

  /// 消息免打扰
  /// 1: Do not receive messages, 2: Do not notify when messages are received; 0: Normal
  void setConversationRecvMessageOpt({int status = 2}) {
    var id = 'single_$uid';
    LoadingView.singleton.wrap(
        asyncFunction: () =>
            OpenIM.iMManager.conversationManager.setConversationRecvMessageOpt(
              conversationIDList: [id],
              status: status,
            ).then((value) => appLogic.notDisturbMap[id] = status != 0));
  }

  @override
  void onReady() {
    getConversationInfo();
    getConversationRecvMessageOpt();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void noDisturbSetting() {
    IMWidget.openNoDisturbSettingSheet(
      isGroup: false,
      onTap: (index) {
        setConversationRecvMessageOpt(status: index == 0 ? 2 : 1);
        noDisturbIndex.value = index;
      },
    );
  }

  void fontSize() {
    AppNavigator.startFontSizeSetup();
  }

  void background() {
    IMWidget.openPhotoSheet(
      toUrl: false,
      crop: false,
      onData: (String path, String? url) async {
        String? value = await CommonUtil.createThumbnail(
          path: path,
          minWidth: 1.sw,
          minHeight: 1.sh,
        );
        if (null != value) chatLogic.changeBackground(value);
      },
    );
  }

  void searchMessage() {
    AppNavigator.startMessageSearch(info: info!);
  }

  void searchPicture() {
    AppNavigator.startSearchPicture(info: info!, type: 0);
  }

  void searchVideo() {
    AppNavigator.startSearchPicture(info: info!, type: 1);
  }

  void searchFile() {
    AppNavigator.startSearchFile(info: info!);
  }

  /// 阅后即焚
  void togglePrivateChat() {
    LoadingView.singleton.wrap(asyncFunction: () async {
      burnAfterReading.value = !burnAfterReading.value;
      await OpenIM.iMManager.conversationManager.setOneConversationPrivateChat(
        conversationID: info!.conversationID,
        isPrivate: burnAfterReading.value,
      );
    });
  }
}
