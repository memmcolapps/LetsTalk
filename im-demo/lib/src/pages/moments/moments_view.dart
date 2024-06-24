import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/core/controller/im_controller.dart';
import 'package:openim_demo/src/jh_common/utils/jh_color_utils.dart';
import 'package:openim_demo/src/jh_common/utils/jh_screen_utils.dart';
import 'package:openim_demo/src/jh_common/widgets/jh_nine_picture.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/res/styles.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/im_util.dart';
import 'package:openim_demo/src/widgets/base_appbar.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

import '../../routes/PopRoute.dart';
import '../../widgets/InputButtomWidget.dart';
import '../../widgets/avatar_view.dart';
import 'moments_logic.dart';

class WxFriendsCirclePage extends StatefulWidget {
  @override
  // StatefulWidget 是一个抽象类
  // _WxFriendsCirclePageState _wxFriendsCirclePageState = new _WxFriendsCirclePageState();
  _WxFriendsCirclePageState createState() => _WxFriendsCirclePageState();
}

class _WxFriendsCirclePageState extends State<WxFriendsCirclePage> {
  final logic = Get.find<MomentsLogic>();
  final imLogic = Get.find<IMController>();

  ScrollController _scrollController = ScrollController();


  bool isLikeIng = false;
  double _imgNormalHeight = 300;
  double _imgExtraHeight = 0;
  double _imgChangeHeight = 0;
  double _scrollMinOffSet = 0;
  double _navH = 0;
  double _appbarOpacity = 0.0;
  String title = '';
  bool isZoom = false;
  int _page = 1;
  var _dataArr = [];
  double _width = 0;
  bool _isShow = false;

  get name => null;

  @override
  void initState() {
    super.initState();
    _navH = JhScreenUtils.navigationBarHeight;
    _imgChangeHeight = _imgNormalHeight + _imgExtraHeight;
    _scrollMinOffSet = _imgNormalHeight - _navH;
    _loadData();
    _addListener();

  }

  void _loadData() async {
    // 获取微信运动排行榜数据
    var data = await Apis.getMoment(
      uid: imLogic.userInfo.value.userID.toString(),
      page: this._page,
    );
    print(data);

    if (data != null) {
      // Map dic = data;
      List dataArr = data!;
      dataArr.forEach((item) {
        double _width = 0;
        item['width'] = _width;
      });
      _dataArr = dataArr;
      setState(() {
        _dataArr = dataArr;
      });
    }
  }

  //滚动监听
  void _addListener() {
    _scrollController.addListener(() {
      double _y = _scrollController.offset;
      print("滑动距离: $_y");

      if (_y < _scrollMinOffSet) {
        _imgExtraHeight = -_y;
//        print(_topH);
        setState(() {
          _imgChangeHeight = _imgNormalHeight + _imgExtraHeight;
        });
      } else {
        setState(() {
          _imgChangeHeight = _navH;
        });
      }
      //小于0 ，下拉放大
      if (_y < 0) {
        print("放大中...");
        if(isZoom){
          return;
        }
        if(_y < - 100){
          isZoom = true;
          _loadData();
          // IMWidget.showToast('放大刷新朋友圈' + _y.toString());
        }
      } else {
        isZoom = false;
      }

      //appbar 透明度
      double appBarOpacity = _y / _navH;
      if (appBarOpacity < 0) {
        //透明
        appBarOpacity = 0.0;
        title = '';
      } else if (appBarOpacity > 1) {
        //不透明
        title = StrRes.moments;
        appBarOpacity = 1.0;
      }

      //更新透明度
      setState(() {
        _appbarOpacity = appBarOpacity;
        title = title;
        // print('_appbarO: ${_appbarOpacity}');
      });
    });
  }

  @override
  void dispose() {
    //为了避免内存泄露，_scrollController.dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context, _dataArr),
    );
  }

  Widget _body(context, dataArr) {
    return Stack(children: <Widget>[
      Container(
        color: Colors.white,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(

              controller: _scrollController,
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: dataArr.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                    width: double.infinity,
                    height: _imgNormalHeight,
                  );
                }
                return _cell(context, dataArr[index - 1]);
              }),
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        height: _imgChangeHeight,
        child: _header(context),
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: backAppBar(context, title,
            backgroundColor:
                PageStyle.kWeiXinBgColor.withOpacity(_appbarOpacity),
            brightness:
                _appbarOpacity == 1.0 ? Brightness.light : Brightness.dark,
            rightImgPath: 'assets/wechat/discover/ic_xiangji.png',
            rightLongCallBack: () {
          AppNavigator.startPublish(type: 'text', url: []);
        }, rightItemCallBack: () {
          logic.clickPublish();
        }),
      ),
    ]);
  }

  //_header
  Widget _header(context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20),
          color: Colors.white,
          // child: Image.network(
          //   'http://img1.mukewang.com/5c18cf540001ac8206000338.jpg',
          //   fit: BoxFit.cover,
          // ),
          child: Image.asset(
            'assets/images/banner.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
            right: 20,
            bottom: 0,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    imLogic.userInfo.value.getShowName(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  child: AvatarView(
                    size: 55.h,
                    isCircle: false,
                    borderRadius: BorderRadius.circular(10),
                    url: imLogic.userInfo.value.faceURL,
                  ),
                  onTap: () => logic.jumpInfo(),
                ),
              ],
            )),
      ],
    );
  }

  //cell
  Widget _cell(context, item) {
    return InkWell(
        onTap: () => logic.clickCell(item['name']),
        child: Container(
            color: Color(0XFFFEFFFE),
            child: Column(
              children: <Widget>[
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                      child: AvatarView(
                        size: 40.h,
                        url: item['face_url'],
                        isCircle: false,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 70, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  item['name'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0XFF566B94),
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  item['content'],
                                  style: TextStyle(fontSize: 14),
                                ),
                                if (item['images'] != null &&
                                    item['images'].length >= 1)
                                  _imgs(context, item),
                                // makePictureCount(widget.model.pics),
                              ],
                            )))
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(left: 70),
                        child: Text(
                          IMUtil.getChatTimeline(item['add_time'] * 1000),
                          style:
                              TextStyle(fontSize: 13, color: Color(0XFFB2B2B2)),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              AnimatedContainer(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color(0XFF4C5154)),
                                  duration: Duration(milliseconds: 100),
                                  width: double.parse(item['width'].toString()),
                                  height: 30,
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                // _starCount++;
                                                likeMoments(item);
                                                isShow(item['id']);
                                              });
                                            },
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.white,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    item['isGood'] == 1
                                                        ? StrRes.nlikeMoments
                                                        : StrRes.likeMoments,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  )
                                                ]),
                                          )),
                                      Expanded(
                                          flex: 1,
                                          child: InkWell(
                                              onTap: () {
                                                comment(context, item);
                                                setState(() {
                                                  _talkCount++;
                                                  isShow(item['id']);
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.sms,
                                                    color: Colors.white,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    StrRes.commentMoments,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  )
                                                ],
                                              )))
                                    ],
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                  onTap: () {
                                    // setState(() {
                                    //   show_
                                    // });
                                    // isShow();

                                    isShow(item['id']);
                                  },
                                  child: Image.asset(
                                    'assets/wechat/discover/ic_diandian.png',
                                    color: PageStyle.kWeiXinTextBlueColor,
                                    width: 22,
                                  )),
                            ],
                          ),
                        ))
                  ],
                ),
                Offstage(
                  offstage: item['goodList'].length == 0 ? true : false,
                  child: Container(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    margin: EdgeInsets.fromLTRB(70, 10, 15, 0),
                    padding: EdgeInsets.all(5),
                    color: Color(0XFFF3F3F5),
                    child: Wrap(
                        alignment: WrapAlignment.start,
                        runSpacing: 5,
                        spacing: 5,
                        children: likeView(item)),
                  ),
                ),
                Offstage(
                  offstage: item['commentList'].length == 0 ? true : false,
                  child: Container(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    margin: EdgeInsets.fromLTRB(70, 0, 15, 0),
                    padding: EdgeInsets.all(5),
                    color: Color(0XFFF3F3F5),
                    child: Wrap(
                        alignment: WrapAlignment.start,
                        runSpacing: 5,
                        spacing: 5,
                        children: talkView(item)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 0.5,
                  width: double.infinity,
                  color: Colors.black26,
                ),
              ],
            )));
  }

  void isShow(int? id) {
    _dataArr.forEach((item) {
      if (item['id'] == id) {
        item['width'] =
            item['width'] == 0 ? double.parse('120') : double.parse('0');
      } else {
        item['width'] = double.parse('0');
      }
    });
    // _isShow = !_isShow;
    setState(() {
      _dataArr = _dataArr;
    });
  }

  void comment(context, item) async {
    var id = item['id'];
    Navigator.push(context, PopRoute(child: InputButtomWidget(
      onEditingCompleteText: (text) {
        print('点击发送 ---$text');
        var result = Apis.publishComment(
            id: id,
            uid: imLogic.userInfo.value.userID.toString(),
            content: text);
        // print('调试 ---' + result.toString() + result.runtimeType.toString());
        // IMWidget.showToast(result.toString());
        try {
          _dataArr.forEach((item) {
            if (item['id'] == id) {
              List commentList = item['commentList'];
              DateTime dateTime = DateTime.now();
              dateTime.toString().substring(0, 19);
              commentList.add({
                'name': imLogic.userInfo.value.getShowName(),
                'id': id,
                'content': text,
                'moments_id': null,
                'create_time': dateTime
              });
              item['commentList'] = commentList;
            }
          });
          // _isShow = !_isShow;
          setState(() {
            _dataArr = _dataArr;
          });
          isLikeIng = false;
        } catch (e) {
          isLikeIng = false;
        }
      },
    )));
  }

  /// 朋友圈
  void likeMoments(item) async {
    if (isLikeIng) {
      return;
    }

    var id = item['id'];
    if (id == null) {
      return;
    }
    isLikeIng = true;
    Apis.goods(id: id, uid: imLogic.userInfo.value.userID.toString());

    try {
      _dataArr.forEach((item) {
        // GoodList.containsValue(value)
        if (item['id'] == id) {
          item['isGood'] = item['isGood'] == 0 ? 1 : 0;
          List goodList = item['goodList'];
          if (item['isGood'] == 1) {
            goodList.add({'name': imLogic.userInfo.value.getShowName()});
            item['goodList'] = goodList;
            IMWidget.showToast('👍');
          } else {
            goodList.removeWhere((user) =>
                user['name'].toString() ==
                imLogic.userInfo.value.getShowName());
          }
        }
      });
      // _isShow = !_isShow;
      setState(() {
        _dataArr = _dataArr;
      });
      isLikeIng = false;
    } catch (e) {
      isLikeIng = false;
    }
  }

  var _starCount = 0;
  var _talkCount = 0;

  List<Widget> likeView(dynamic? data) {
    List<Widget> result = [];
    // print(data['goodList'].toString() + ' 这里是测试效果');
    var lists = data['goodList'];

    for (var i = 0; i < lists.length; i++) {
      if (lists[i]['name'] != null) {
        // print(lists[i]['name'] + '点赞名称');
        result.add(Container(
          width: 70,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.favorite_border,
                size: 13,
                color: Color(0XFF566B94),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                lists[i]['name'],
                style: TextStyle(
                    color: Color(0XFF566B94),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ));
      }
    }
    return result;
  }

  List<Widget> talkView(dynamic? data) {
    List<Widget> result = [];
    var commentList = data['commentList'];
    for (var i = 0; i < commentList.length; i++) {
      // print('评论---' + commentList[i]['name']);
      result.add(Container(
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: commentList[i]['name'] + "：",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFF566B94))),
                TextSpan(
                  text: commentList[i]['content'],
                  style: TextStyle(fontSize: 14),
                )
              ]),
              textAlign: TextAlign.start,
            )),
          ],
        ),
      ));
    }
    // for (int i = 0; i < count; i++) {
    //   result.add(Container(
    //     child: Row(
    //       children: <Widget>[
    //         Expanded(
    //             child: Text.rich(
    //           TextSpan(children: [
    //             TextSpan(
    //                 text: "sunnytu：",
    //                 style: TextStyle(
    //                     fontSize: 15,
    //                     fontWeight: FontWeight.w500,
    //                     color: Color(0XFF566B94))),
    //             TextSpan(
    //               text: "66666",
    //               style: TextStyle(fontSize: 14),
    //             )
    //           ]),
    //           textAlign: TextAlign.start,
    //         )),
    //       ],
    //     ),
    //   ));
    // }

    return result;
  }

  //图片view
  Widget _imgs(context, item) {
    var images = item['images'];

    return Container(
        child: JhNinePicture(
      imgData: images,
      lRSpace: (80.0 + 20.0),
      onLongPress: () {
        // print('objonLongPressect:');
        // JhBottomSheet.showText(context,
        //     title: '请选择动作',
        //     dataArr: ["保存图片"],
        //     clickCallback: (int selectIndex, String selectText) {});
      },
    ));
  }
}






// class MomentsPage extends Widget {
//   final logic = Get.find<MomentsLogic>();
// }
