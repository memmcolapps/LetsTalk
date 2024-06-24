import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/pages/contacts/contacts_view.dart';
import 'package:openim_demo/src/pages/conversation/conversation_view.dart';
import 'package:openim_demo/src/pages/interest/interest_view.dart';
import 'package:openim_demo/src/pages/mine/mine_view.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/widgets/bottombar.dart';

import '../../routes/app_navigator.dart';
import '../../widgets/AndroidBackTop.dart';
import '../../widgets/IconText.dart';
import '../../widgets/im_widget.dart';
import 'home_logic.dart';

class HomePage extends StatelessWidget {
  final logic = Get.find<HomeLogic>();
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) => FabCircularMenu(
          key: fabKey,
          // Cannot be `Alignment.center`
          alignment: Alignment.bottomRight,
          ringColor: Color.fromRGBO(0, 128, 105, 1),
          ringDiameter: 460.0,
          ringWidth: 120.0,
          fabSize: 54.0,
          fabElevation: 8.0,
          fabIconBorder: CircleBorder(),
          // Also can use specific color based on wether
          // the menu is open or not:
          // fabOpenColor: Colors.white
          // fabCloseColor: Colors.white
          // These properties take precedence over fabColor
          fabColor: Color.fromRGBO(0, 171, 129, 1),
          fabOpenIcon: Icon(Icons.menu, color: Colors.white),
          fabCloseIcon: Icon(Icons.close, color: Colors.white),
          fabMargin: const EdgeInsets.fromLTRB(0, 0, 20.0, 30.00),
          animationDuration: const Duration(milliseconds: 800),
          animationCurve: Curves.easeInOutCirc,
          onDisplayChange: (isOpen) {
            // IMWidget.showToast("The menu is ${isOpen ? "open" : "closed"}");
          },
          children: <Widget>[
            /// 首页
            RawMaterialButton(
                onPressed: () {
                  logic.switchTab(0);
                  fabKey.currentState?.close();
                },
                shape: CircleBorder(),
                padding: const EdgeInsets.all(24.0),
                child: Stack(alignment: Alignment.center, children: [
                  Positioned(
                    top: 0.h,
                    child: Container(
                      padding: EdgeInsets.only(left: 25.w),
                      child: UnreadCountView(
                        // size: item.count,
                        count: logic.unreadMsgCount.value,
                        // qqBadge: true,
                      ),
                    ),
                  ),
                  Container(
                    child: IconText(
                      StrRes.home,
                      icon: Icon(Icons.home, color: Colors.white),
                      iconSize: 24.h,
                      padding: const EdgeInsets.all(4.0),
                      softWrap: false,
                      style: PageStyle.ts_FFFFFF_16sp,
                    ),
                  )
                ])),

            /// 联系人
            RawMaterialButton(
              onPressed: () {
                logic.switchTab(1);
                // AppNavigator.startFriendList();
                // IMWidget.showToast("You pressed 3");
                fabKey.currentState?.close();
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Container(
                child: IconText(
                  StrRes.contacts,
                  icon: ImageIcon(AssetImage(ImageRes.ic_tabContactsNor),
                      size: 24, color: Colors.white),
                  iconSize: 24.h,
                  padding: const EdgeInsets.all(4.0),
                  softWrap: false,
                  style: PageStyle.ts_FFFFFF_16sp,
                ),
              ),
            ),

            /// 朋友圈
            RawMaterialButton(
              onPressed: () {
                logic.switchTab(2);
                // AppNavigator.startMoments();
                // IMWidget.showToast(
                //     "You pressed 4. This one closes the menu on tap");
                fabKey.currentState?.close();
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Container(
                child: IconText(
                  StrRes.moments,
                  icon: Icon(Icons.add_a_photo, color: Colors.white),
                  iconSize: 24.h,
                  padding: const EdgeInsets.all(4.0),
                  softWrap: false,
                  style: PageStyle.ts_FFFFFF_16sp,
                ),
              ),
            ),

            /// 我的
            RawMaterialButton(
              onPressed: () {
                logic.switchTab(3);
                // AppNavigator.startMyInfo();
                // IMWidget.showToast("You pressed 2");
                fabKey.currentState?.close();
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(24.0),
              child: Container(
                child: IconText(
                  StrRes.myInfo,
                  icon: ImageIcon(AssetImage(ImageRes.ic_myInfo),
                      size: 24, color: Colors.white),
                  iconSize: 24.h,
                  padding: const EdgeInsets.all(4.0),
                  softWrap: false,
                  style: PageStyle.ts_FFFFFF_16sp,
                ),
              ),
            ),
            // RawMaterialButton(
            //   onPressed: () {
            //     logic.switchTab(3);
            //     // AppNavigator.startAccountSetup();
            //     // IMWidget.showToast("You pressed 1");
            //     fabKey.currentState?.close();
            //   },
            //   shape: CircleBorder(),
            //   padding: const EdgeInsets.all(24.0),
            //   child: Icon(Icons.settings, color: Colors.white),
            // ),
            // RawMaterialButton(
            //   onPressed: () {
            //     // IMWidget.showToast(
            //     //     "You pressed 4. This one closes the menu on tap");
            //     fabKey.currentState?.close();
            //   },
            //   shape: CircleBorder(),
            //   padding: const EdgeInsets.all(24.0),
            //   child: Icon(Icons.add_a_photo, color: Colors.white),
            // )
          ],
        ),
      ),
      backgroundColor: PageStyle.c_FFFFFF,
      body: WillPopScope(
        onWillPop: () async {
          // IMWidget.showToast("hello");
          AndroidBackTop.backDeskTop();
          return false;
        },
        child: Obx(() => Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    index: logic.index.value,
                    children: [
                      ConversationPage(),
                      ContactsPage(),
                      // MomentsPage(),
                      InterestPage(),
                      MinePage(),
                    ],
                  ),
                ),
                // BottomBar(
                //   index: logic.index.value,
                //   items: [
                //     BottomBarItem(
                //       selectedImgRes: ImageRes.ic_tabHomeSel,
                //       unselectedImgRes: ImageRes.ic_tabHomeNor,
                //       label: StrRes.home,
                //       imgWidth: 24.w,
                //       imgHeight: 25.h,
                //       onClick: (i) => logic.switchTab(i),
                //       // steam: logic.imLogic.unreadMsgCountCtrl.stream,
                //       count: logic.unreadMsgCount.value,
                //     ),
                //     BottomBarItem(
                //       selectedImgRes: ImageRes.ic_tabContactsSel,
                //       unselectedImgRes: ImageRes.ic_tabContactsNor,
                //       label: StrRes.contacts,
                //       imgWidth: 22.w,
                //       imgHeight: 23.h,
                //       onClick: (i) => logic.switchTab(i),
                //       count: logic.unhandledCount.value,
                //     ),
                //     BottomBarItem(
                //       selectedImgRes: ImageRes.ic_tabInterestSel,
                //       unselectedImgRes: ImageRes.ic_tabInterestNor,
                //       label: StrRes.interest,
                //       imgWidth: 24.w,
                //       imgHeight: 25.h,
                //       onClick: (i) => logic.switchTab(i),
                //       count: 0,
                //     ),
                //     BottomBarItem(
                //       selectedImgRes: ImageRes.ic_tabMineSel,
                //       unselectedImgRes: ImageRes.ic_tabMineNor,
                //       label: StrRes.mine,
                //       imgWidth: 22.w,
                //       imgHeight: 23.h,
                //       onClick: (i) => logic.switchTab(i),
                //       count: 0,
                //     ),
                //   ],
                // ),
              ],
            )),
      ),
    );
  }
}
