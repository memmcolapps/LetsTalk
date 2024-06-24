import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sprintf/sprintf.dart';

import '../../flutter_openim_widget.dart';

late String imCachePath;

class CommonUtil {
  /// path: image path
  static Future<String?> createThumbnail({
    required String path,
    required double minWidth,
    required double minHeight,
  }) async {
    if (!(await File(path).exists())) {
      return null;
    }
    String thumbPath = await createTempPath(path, flag: 'im');
    File destFile = File(thumbPath);
    if (!(await destFile.exists())) {
      await destFile.create(recursive: true);
    } else {
      return thumbPath;
    }
    var compressFile = await compressImage(
      File(path),
      targetPath: thumbPath,
      minHeight: minHeight ~/ 1,
      minWidth: minWidth ~/ 1,
    );
    return compressFile?.path;
  }

  static Future<String> createTempPath(
    String sourcePath, {
    String flag = "",
    String dir = 'pic',
  }) async {
    var path = (await getApplicationDocumentsDirectory()).path;
    var name =
        '${flag}_${sourcePath.substring(sourcePath.lastIndexOf('/') + 1)}';
    String dest = '$path/$dir/$name';

    return dest;
  }

  /// get Now Date Milliseconds.
  static int getNowDateMs() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  // 时间显示，刚刚，x分钟前
  static String messageTime(timeStamp) {
    // 当前时间
    int time = (new DateTime.now().millisecondsSinceEpoch / 1000).round();
    // 对比
    num _distance = time - timeStamp / 1000;
    if (_distance <= 60) {
      return UILocalizations.now;
    } else if (_distance <= 3600) {
      // return '${(_distance / 60).floor()} ' + UILocalizations.minutes;
      return '${customStampStr(timestamp: timeStamp, date: 'hh:mm', toInt: false)}';
    } else if (_distance <= 43200) {
      return '${customStampStr(timestamp: timeStamp, date: 'hh:mm', toInt: false)}';
      // return '${(_distance / 60 / 60).floor()} ' + UILocalizations.hours;
    } else if (DateTime.fromMillisecondsSinceEpoch(time).year ==
        DateTime.fromMillisecondsSinceEpoch(timeStamp).year) {
      return '${customStampStr(timestamp: timeStamp, date: 'MM/DD hh:mm', toInt: false)}';
    } else {
      return '${customStampStr(timestamp: timeStamp, date: 'YY/MM/DD hh:mm', toInt: false)}';
    }
  }

  /// 时间戳转时间
  static String customStampStr({
    required int timestamp, // 为空则显示当前时间
    required String date, // 显示格式，比如：'YY年MM月DD日 hh:mm:ss'
    bool toInt = true, // 去除0开头
  }) {
    if (timestamp == null) {
      timestamp = (new DateTime.now().millisecondsSinceEpoch / 1000).round();
    }
    String timeStr =
        (DateTime.fromMillisecondsSinceEpoch(timestamp)).toString();

    dynamic dateArr = timeStr.split(' ')[0];
    dynamic timeArr = timeStr.split(' ')[1];

    String yy = dateArr.split('-')[0];
    String mm = dateArr.split('-')[1];
    String dd = dateArr.split('-')[2];

    String hh = timeArr.split(':')[0];
    String mmTime = timeArr.split(':')[1];
    String ss = timeArr.split(':')[2];

    ss = ss.split('.')[0];

    // 去除0开头
    if (toInt) {
      mm = (int.parse(mm)).toString();
      dd = (int.parse(dd)).toString();
      hh = (int.parse(hh)).toString();
      mm = (int.parse(mm)).toString();
    }

    if (date == null) {
      return timeStr;
    }

    date = date
        .replaceAll('YY', yy)
        .replaceAll('MM', mm)
        .replaceAll('DD', dd)
        .replaceAll('hh', hh)
        .replaceAll('mm', mmTime)
        .replaceAll('ss', ss);

    return date;
  }

  ///  compress file and get file.
  static Future<File?> compressImage(
    File? file, {
    required String targetPath,
    required int minWidth,
    required int minHeight,
  }) async {
    if (null == file) return null;
    var path = file.path;
    var name = path.substring(path.lastIndexOf("/"));
    // var ext = name.substring(name.lastIndexOf("."));
    CompressFormat format = CompressFormat.jpeg;
    if (name.endsWith(".jpg") || name.endsWith(".jpeg")) {
      format = CompressFormat.jpeg;
    } else if (name.endsWith(".png")) {
      format = CompressFormat.png;
    } else if (name.endsWith(".heic")) {
      format = CompressFormat.heic;
    } else if (name.endsWith(".webp")) {
      format = CompressFormat.webp;
    }

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      inSampleSize: 2,
      minWidth: minWidth,
      minHeight: minHeight,
      format: format,
    );
    return result;
  }

  //fileExt 文件后缀名
  static String? getMediaType(final String filePath) {
    var fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
    var fileExt = fileName.substring(fileName.lastIndexOf("."));
    switch (fileExt.toLowerCase()) {
      case ".jpg":
      case ".jpeg":
      case ".jpe":
        return "image/jpeg";
      case ".png":
        return "image/png";
      case ".bmp":
        return "image/bmp";
      case ".gif":
        return "image/gif";
      case ".json":
        return "application/json";
      case ".svg":
      case ".svgz":
        return "image/svg+xml";
      case ".mp3":
        return "audio/mpeg";
      case ".mp4":
        return "video/mp4";
      case ".mov":
        return "video/mov";
      case ".htm":
      case ".html":
        return "text/html";
      case ".css":
        return "text/css";
      case ".csv":
        return "text/csv";
      case ".txt":
      case ".text":
      case ".conf":
      case ".def":
      case ".log":
      case ".in":
        return "text/plain";
    }
    return null;
  }

  /// 将字节数转化为MB
  static String formatBytes(int bytes) {
    int kb = 1024;
    int mb = kb * 1024;
    int gb = mb * 1024;
    if (bytes >= gb) {
      return sprintf("%.1f GB", [bytes / gb]);
    } else if (bytes >= mb) {
      double f = bytes / mb;
      return sprintf(f > 100 ? "%.0f MB" : "%.1f MB", [f]);
    } else if (bytes > kb) {
      double f = bytes / kb;
      return sprintf(f > 100 ? "%.0f KB" : "%.1f KB", [f]);
    } else {
      return sprintf("%d B", [bytes]);
    }
  }

  static IconData fileIcon(String fileName) {
    var mimeType = mime(fileName) ?? '';
    if (mimeType == 'application/pdf') {
      return FontAwesomeIcons.solidFilePdf;
    } else if (mimeType == 'application/msword' ||
        mimeType ==
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document') {
      return FontAwesomeIcons.solidFileWord;
    } else if (mimeType == 'application/vnd.ms-excel' ||
        mimeType ==
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') {
      return FontAwesomeIcons.solidFileExcel;
    } else if (mimeType == 'application/vnd.ms-powerpoint') {
      return FontAwesomeIcons.solidFilePowerpoint;
    } else if (mimeType.startsWith('audio/')) {
    } else if (mimeType == 'application/zip' ||
        mimeType == 'application/x-rar-compressed') {
      return FontAwesomeIcons.solidFileZipper;
    } else if (mimeType.startsWith('audio/')) {
      return FontAwesomeIcons.solidFileAudio;
    } else if (mimeType.startsWith('video/')) {
      return FontAwesomeIcons.solidFileVideo;
    } else if (mimeType.startsWith('image/')) {
      return FontAwesomeIcons.solidFileImage;
    } else if (mimeType == 'text/plain') {
      return FontAwesomeIcons.solidFileCode;
    }
    return FontAwesomeIcons.solidFileLines;
  }
}
