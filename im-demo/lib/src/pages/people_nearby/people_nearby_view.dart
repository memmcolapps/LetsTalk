import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/pages/people_nearby/people_nearby_logic.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/utils/im_util.dart';
import 'package:openim_demo/src/widgets/avatar_view.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';

import 'package:openim_demo/src/models/people_nearby.dart';


class PeopleNearbyPage extends StatelessWidget {
  final logic = Get.find<PeopleNearbyLogic>();
  final imLogic = Get.find<IMController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTitleBar.back(
        title: StrRes.peopleNearby,
      ),
      backgroundColor: PageStyle.c_FFFFFF,
      body: Obx(
        () => Column(
            children: [
              Expanded(
                  child:
                  ListView.builder(
                    itemCount: logic.list.length,
                    cacheExtent: 70.h,
                    itemBuilder: (_, index) =>
                        _buildItemView(logic.list.elementAt(index)),
                  ),
              ),
            ],
        ),
      ),
    );
  }

  Widget _buildItemView(PeopleNearbyUser peopleNearby) => Ink(
    height: 70.h,
    color: PageStyle.c_FFFFFF,
    child: InkWell(
        onTap: () => logic.openUser(peopleNearby),
        child: Container(
        height: 70.h,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Row(
          children: [
            AvatarView(
              size: 48.h,
              url: peopleNearby.avatar,
            ),
            SizedBox(
              width: 14.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    peopleNearby.name,
                    style: imLogic.userInfo.value.userID != peopleNearby.userId ? PageStyle.ts_666666_13sp : PageStyle.ts_F33E37_13sp,
                  ),
                  SizedBox(
                    height : 4.w,
                  ),
                  Text(
                    '[${peopleNearby.gender == 1 ? StrRes.man : StrRes.woman}]',
                    style: imLogic.userInfo.value.userID != peopleNearby.userId
                        ? PageStyle.ts_666666_13sp
                        : PageStyle.ts_F33E37_13sp,
                  ),
                ],
              ),
            ),
            Text( peopleNearby.getDistance() + ' km' , style: imLogic.userInfo.value.userID != peopleNearby.userId ? PageStyle.ts_666666_13sp : PageStyle.ts_F33E37_13sp,
            ),
          ],
        )
      ),
    )
  );

  Widget _buildLine() => Container(
    height: 0.5,
    color: PageStyle.c_999999_opacity40p,
  );
}
