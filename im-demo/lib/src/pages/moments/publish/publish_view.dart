import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_luban/flutter_luban.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:nine_grid_view/nine_grid_view.dart';
import 'package:openim_demo/src/models/image.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/utils/data_persistence.dart';
import 'package:openim_demo/src/utils/im_util.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';
import 'package:openim_demo/src/widgets/titlebar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:rxdart/rxdart.dart' as rx;
import '../../../jh_common/widgets/jh_photo_browser.dart';
import '../../../routes/app_navigator.dart';
import '../../../widgets/bottom_sheet_view.dart';
import '../../../widgets/touch_close_keyboard.dart';
import 'publish_logic.dart';

class PublishPage extends StatefulWidget {
  @override
  _PublishPageState createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  final logic = Get.find<PublishLogic>();
  // final momentSubject = rx.PublishSubject<bool>();
  late final arguments;

  List<ImageBean> imageList = [];
  int moveAction = MotionEvent.actionUp;
  bool _canDelete = false;
  bool isShowLink = false;
  bool showLink = false;
  String type = 'text';
  List<String> urlList = [];

  @override
  void initState() {
    _init();
    super.initState();
  }


  void _init() {
    arguments = Get.arguments;
    print("拓展类型" + arguments.toString());
    type = arguments?['type'] ?? 'text';
    // IMWidget.showToast(arguments.toString() + '拓展类型');
    urlList = Get.arguments['url'] ?? [];
    setState(() {
      urlList = urlList;
    });
    List<ImageBean> list = [];
    for (int i = 0; i < urlList.length; i++) {
      String url = urlList[i];
      list.add(ImageBean(
        originPath: url,
        middlePath: url,
        thumbPath: url,
        originalWidth: i == 0 ? 264 : null,
        originalHeight: i == 0 ? 258 : null,
      ));
    }
    imageList = list;
  }

  void _loadAssets(BuildContext context) {
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
                        // requestType: RequestType.common,
                        textDelegate: language == 2  ? EnglishAssetPickerTextDelegate() : AssetPickerTextDelegate(),
                        maxAssets: 9 - this.imageList.length,
                        specialPickerType: SpecialPickerType.wechatMoment,
                        filterOptions: FilterOptionGroup()));
                if (null != assets) {
                  print(assets.first.file);
                  if (assets.length > 0) {
                    for (var asset in assets) {
                      File? file = await asset.file;
                      File? image = file;
                      if (image == null) {
                        return;
                      }
                      File? newImg =
                          await IMUtil.compressAndGetPic(image, 1920, 1680, 80);
                      var _path = newImg!.path;
                      setState(() {
                        this.imageList.add(ImageBean(
                              originPath: _path,
                              middlePath: _path,
                              thumbPath: _path,
                              originalWidth:
                                  this.imageList.length + 1 == 0 ? 264 : null,
                              originalHeight:
                                  this.imageList.length + 1 == 0 ? 258 : null,
                            ));
                      });
                    }
                    // IMWidget.showToast(imgs.toString());
                    // AppNavigator.startPublish(type: 'image', url: imgs);
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
          setState(() {
            this.imageList.add(ImageBean(
                  originPath: _path,
                  middlePath: _path,
                  thumbPath: _path,
                  originalWidth: this.imageList.length + 1 == 0 ? 264 : null,
                  originalHeight: this.imageList.length + 1 == 0 ? 258 : null,
                ));
          });
          // AppNavigator.startPublish(type: 'image', url: [path]);
          //如果图片
          // sendPicture(path: path);
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TouchCloseSoftKeyboard(
        child: Scaffold(
      appBar: EnterpriseTitleBar.momentTitle(
        title: StrRes.moments,
        onClickMoreBtn: () => logic.publish(type, imageList),
      ),
      body: Stack(children: [
        Positioned.fill(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 0),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(0), border: null),
                child: TextField(
                  // maxLength: , //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
                  maxLines: 5, //最大行数
                  autocorrect: true, //是否自动更正
                  autofocus: true, //是否自动对焦
                  obscureText: false, //是否是密码
                  cursorWidth: 2.0,
                  controller: logic.inputCtrl,
                  enableInteractiveSelection: true,
                  textAlign: TextAlign.left, //文本对齐方式
                  style: TextStyle(
                      fontSize: 18.0, color: Colors.black87), //输入文本的样式
                  inputFormatters: [], //允许的输入格式
                  decoration: InputDecoration(
                    hintText: "",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0),
                    ),
                    // //获得焦点下划线设为蓝色
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0),
                    ),
                  ),
                  onChanged: (text) {
                    //内容改变的回调
                    print('change $text');
                  },
                  onSubmitted: (text) {
                    //内容提交(按回车)的回调
                    print('submit $text');
                  },
                  enabled: true, //是否禁用
                ))),
        Positioned.fill(
            top: 140.0,
            left: 0,
            right: 0,
            child: Container(
                child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                if (urlList.length >= 1)
                  DragSortView(
                    imageList,
                    space: 5,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(0),
                    itemBuilder: (BuildContext context, int index) {
                      ImageBean bean = imageList[index];
                      // It is recommended to use a thumbnail picture
                      return getWidget(bean.thumbPath!);
                    },
                    initBuilder: (BuildContext context) {
                      return InkWell(
                        onTap: () {
                          _loadAssets(context);
                        },
                        child: Container(
                          color: Color(0XFFCCCCCC),
                          child: Center(
                            child: Icon(
                              Icons.add,
                            ),
                          ),
                        ),
                      );
                    },
                    onDragListener: (MotionEvent event, double itemWidth) {
                      switch (event.action) {
                        case MotionEvent.actionDown:
                          moveAction = event.action!;
                          setState(() {});
                          break;
                        case MotionEvent.actionMove:
                          double x = event.globalX! + itemWidth;
                          double y = event.globalY! + itemWidth;
                          double maxX =
                              MediaQuery.of(context).size.width - 1 * 100;
                          double maxY =
                              MediaQuery.of(context).size.height - 1 * 100;
                          print(
                              'Sky24n maxX: $maxX, maxY: $maxY, x: $x, y: $y');
                          if (_canDelete && (x < maxX || y < maxY)) {
                            setState(() {
                              _canDelete = false;
                            });
                          } else if (!_canDelete && x > maxX && y > maxY) {
                            setState(() {
                              _canDelete = true;
                            });
                          }
                          break;
                        case MotionEvent.actionUp:
                          moveAction = event.action!;
                          if (_canDelete) {
                            setState(() {
                              _canDelete = false;
                            });
                            return true;
                          } else {
                            setState(() {});
                          }
                          break;
                      }
                      return false;
                    },
                  ),
              ],
            ))),
        if (showLink)
          Stack(children: [
            Positioned(
                bottom: 0,
                child: Offstage(
                  offstage: isShowLink,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isShowLink = true;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(
                        Icons.link_sharp,
                        size: 40,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                )),
            // 展示输入框
            Positioned(
                bottom: 10,
                child: Offstage(
                    offstage: !isShowLink,
                    child: Container(
                      height: 110,
                      width: Get.width,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.blue, width: 1)),
                            child: TextField(
                              autofocus: true,
                              onSubmitted: (value) {},
                              decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 18),
                                hintText: '请输入链接地址',
                              ),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isShowLink = false;
                                    });
                                  },
                                  child: Text('取消')),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isShowLink = false;
                                    });
                                  },
                                  child: Text('完成')),
                            ],
                          )
                        ],
                      ),
                    )))
          ]),
      ]),
      floatingActionButton: moveAction == MotionEvent.actionUp
          ? null
          : FloatingActionButton(
              onPressed: () {},
              child: Icon(_canDelete ? Icons.delete : Icons.delete_outline),
            ),
    ));
  }

  static Widget getWidget(String url) {
    if (url.startsWith('http')) {
      //return CachedNetworkImage(imageUrl: url, fit: BoxFit.cover);
      return Image.network(url, fit: BoxFit.cover);
    }
    if (url.endsWith('.png')) {
      return Image.asset(url,
          fit: BoxFit.cover, package: 'flutter_gallery_assets');
    }
    return Image.file(File(url), fit: BoxFit.cover);
    // return Image.asset(getImgPath(url), fit: BoxFit.cover);
  }
}
