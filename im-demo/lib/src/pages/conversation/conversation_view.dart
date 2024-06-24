import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/res/images.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:openim_demo/src/widgets/search_box.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';
import 'package:openim_demo/src/widgets/touch_close_keyboard.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'conversation_logic.dart';

class ConversationPage extends StatelessWidget {
  final logic = Get.find<ConversationLogic>();
  final imLogic = Get.find<IMController>();
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Obx(
      () => TouchCloseSoftKeyboard(
        child: Scaffold(
          // floatingActionButton: Builder(
          //   builder: (context) => FabCircularMenu(
          //     key: fabKey,
          //     // Cannot be `Alignment.center`
          //     alignment: Alignment.bottomRight,
          //     ringColor: Color.fromRGBO(0, 128, 105, 1),
          //     ringDiameter: 460.0,
          //     ringWidth: 120.0,
          //     fabSize: 54.0,
          //     fabElevation: 8.0,
          //     fabIconBorder: CircleBorder(),
          //     // Also can use specific color based on wether
          //     // the menu is open or not:
          //     // fabOpenColor: Colors.white
          //     // fabCloseColor: Colors.white
          //     // These properties take precedence over fabColor
          //     fabColor: Color.fromRGBO(0, 171, 129, 1),
          //     fabOpenIcon: Icon(Icons.menu, color: Colors.white),
          //     fabCloseIcon: Icon(Icons.close, color: Colors.white),
          //     fabMargin: const EdgeInsets.fromLTRB(0, 0, 20.0, 30.00),
          //     animationDuration: const Duration(milliseconds: 800),
          //     animationCurve: Curves.easeInOutCirc,
          //     onDisplayChange: (isOpen) {
          //       // IMWidget.showToast("The menu is ${isOpen ? "open" : "closed"}");
          //     },
          //     children: <Widget>[
          //       RawMaterialButton(
          //         onPressed: () {
          //           AppNavigator.startAccountSetup();
          //           // IMWidget.showToast("You pressed 1");
          //           fabKey.currentState?.close();
          //         },
          //         shape: CircleBorder(),
          //         padding: const EdgeInsets.all(24.0),
          //         child: Icon(Icons.settings, color: Colors.white),
          //       ),
          //       RawMaterialButton(
          //         onPressed: () {
          //           AppNavigator.startMyInfo();
          //           // IMWidget.showToast("You pressed 2");
          //           fabKey.currentState?.close();
          //         },
          //         shape: CircleBorder(),
          //         padding: const EdgeInsets.all(24.0),
          //         child: ImageIcon(AssetImage(ImageRes.ic_myInfo),
          //             size: 24, color: Colors.white),
          //       ),
          //       RawMaterialButton(
          //         onPressed: () {
          //           AppNavigator.startFriendList();
          //           // IMWidget.showToast("You pressed 3");
          //           fabKey.currentState?.close();
          //         },
          //         shape: CircleBorder(),
          //         padding: const EdgeInsets.all(24.0),
          //         child: ImageIcon(AssetImage(ImageRes.ic_tabContactsNor),
          //             size: 24, color: Colors.white),
          //       ),
          //       RawMaterialButton(
          //         onPressed: () {
          //           AppNavigator.startMoments();
          //           // IMWidget.showToast(
          //           //     "You pressed 4. This one closes the menu on tap");
          //           fabKey.currentState?.close();
          //         },
          //         shape: CircleBorder(),
          //         padding: const EdgeInsets.all(24.0),
          //         child: Icon(Icons.add_a_photo, color: Colors.white),
          //       ),
          //       // RawMaterialButton(
          //       //   onPressed: () {
          //       //     // IMWidget.showToast(
          //       //     //     "You pressed 4. This one closes the menu on tap");
          //       //     fabKey.currentState?.close();
          //       //   },
          //       //   shape: CircleBorder(),
          //       //   padding: const EdgeInsets.all(24.0),
          //       //   child: Icon(Icons.add_a_photo, color: Colors.white),
          //       // )
          //     ],
          //   ),
          // ),
          backgroundColor: PageStyle.c_FFFFFF,
          // resizeToAvoidBottomInset: false,
          // appBar: AppBar(),
          appBar: EnterpriseTitleBar.conversationTitle(
              // title: 'xx信息技术（成都）有限公司',
              // subTitle: imLogic.userInfo.value.getShowName(),
              avatarUrl: imLogic.userInfo.value.faceURL,
              backgroundColor: PageStyle.c_008069,
              actions: _buildActions(),
              subTitleView: _buildSubTitleView(),
              onClick: () => {
                logic.viewMyInfo()}
          ),
          body: SlidableAutoCloseBehavior(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header:
                  WaterDropMaterialHeader(backgroundColor: PageStyle.c_1B72EC),
              footer: CustomFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
                builder: (BuildContext context, LoadStatus? mode) {
                  return Container(
                    height: 55.0,
                    child: Center(child: CupertinoActivityIndicator()),
                  );
                },
              ),
              controller: logic.refreshController,
              onRefresh: logic.onRefresh,
              onLoading: logic.onLoading,
              child: _buildListView(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListView() => CustomScrollView(
        slivers: [
          // SliverToBoxAdapter(
          //   child: SearchBox(
          //     enabled: false,
          //     margin: EdgeInsets.fromLTRB(22.w, 11.h, 22.w, 5.h),
          //     padding: EdgeInsets.symmetric(horizontal: 13.w),
          //   ),
          // ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ConversationItemView(
                onTap: () => logic.toChat(index),
                avatarUrl: logic.getAvatar(index),
                title: logic.getShowName(index),
                content: logic.getMsgContent(index),
                allAtMap: logic.getAtUserMap(index),
                contentPrefix: logic.getPrefixText(index),
                timeStr: logic.getTime(index),
                unreadCount: logic.getUnreadCount(index),
                notDisturb: logic.isNotDisturb(index),
                backgroundColor: logic.isPinned(index)
                    ? PageStyle.c_F3F3F3
                    : Colors.transparent,
                height: 70.h,
                contentWidth: 180.w,
                avatarSize: 48.h,
                underline: false,
                titleStyle: PageStyle.ts_333333_15sp,
                contentStyle: PageStyle.ts_666666_13sp,
                contentPrefixStyle: PageStyle.ts_F44038_13sp,
                timeStyle: PageStyle.ts_999999_12sp,
                extentRatio: logic.existUnreadMsg(index) ? 0.6 : 0.4,
                slideActions: [
                  SlideItemInfo(
                    flex: logic.isPinned(index) ? 3 : 2,
                    text: logic.isPinned(index) ? StrRes.cancelTop : StrRes.top,
                    colors: pinColors,
                    textStyle: PageStyle.ts_FFFFFF_14sp,
                    width: 77.w,
                    onTap: () => logic.pinConversation(index),
                  ),
                  if (logic.existUnreadMsg(index))
                    SlideItemInfo(
                      flex: 3,
                      text: StrRes.markRead,
                      colors: haveReadColors,
                      textStyle: PageStyle.ts_FFFFFF_16sp,
                      width: 77.w,
                      onTap: () => logic.markMessageHasRead(index),
                    ),
                  SlideItemInfo(
                    flex: 2,
                    text: StrRes.remove,
                    colors: deleteColors,
                    textStyle: PageStyle.ts_FFFFFF_16sp,
                    width: 77.w,
                    onTap: () => logic.deleteConversation(index),
                  ),
                ],
                patterns: <MatchPattern>[
                  MatchPattern(
                    type: PatternType.AT,
                    style: PageStyle.ts_666666_13sp,
                  ),
                ],
                // isCircleAvatar: false,
              ),
              childCount: logic.list.length,
            ),
          ),
        ],
      );

  List<Widget> _buildActions() => [
        TitleImageButton(
          imageStr: ImageRes.ic_searchWhite,
          imageHeight: 23.h,
          imageWidth: 23.w,
          // height: 50.h,
          onTap: () => logic.toMyFriendList(),
          // onTap: () => logic.toViewCallRecords(),
        ),
        PopButton(
          popCtrl: logic.popCtrl,
          menuBgColor: Color(0xFFFFFFFF),
          showArrow: false,
          menuBgShadowColor: Color(0xFF000000).withOpacity(0.16),
          menuBgShadowBlurRadius: 6,
          menuBgShadowSpreadRadius: 2,
          menuItemTextStyle: PageStyle.ts_333333_14sp,
          menuItemHeight: 44.h,
          // menuItemWidth: 170.w,
          menuItemPadding: EdgeInsets.only(left: 20.w, right: 30.w),
          menuBgRadius: 6,
          // menuItemIconSize: 24.h,
          menus: [
            PopMenuInfo(
              text: StrRes.scan,
              icon: ImageRes.ic_popScan,
              onTap: () => logic.toScanQrcode(),
            ),
            PopMenuInfo(
              text: StrRes.addFriend,
              icon: ImageRes.ic_popAddFriends,
              onTap: () => logic.toAddFriend(),
            ),
            PopMenuInfo(
              text: StrRes.addGroup,
              icon: ImageRes.ic_popAddGroup,
              onTap: () => logic.toAddGroup(),
            ),
            PopMenuInfo(
              text: StrRes.launchGroup,
              icon: ImageRes.ic_popLaunchGroup,
              onTap: () => logic.createGroup(),
            ),
          ],
          child: TitleImageButton(
            imageStr: ImageRes.ic_addWhite,
            imageHeight: 24.h,
            imageWidth: 23.w,
            // onTap: (){},
            // onTap: onClickAddBtn,
            // height: 50.h,
          ),
        ),
      ];

  Widget _buildSubTitleView() => Row(
        children: [
          Text(
            imLogic.userInfo.value.getShowName(),
            style: PageStyle.ts_FFFFFF_18sp,
          ),
          _onlineView(),
        ],
      );

  Widget _onlineView() => Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 8.w, right: 4.w, top: 2.h),
            width: 6.h,
            height: 6.h,
            decoration: BoxDecoration(
              color: PageStyle.c_10CC64,
              shape: BoxShape.circle,
            ),
          ),
          Text(
            StrRes.online,
            style: PageStyle.ts_FFFFFF_12sp,
          ),
        ],
      );
}
