import 'dart:ffi';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:openim_demo/src/models/call_records.dart';
import 'package:openim_demo/src/models/login_certificate.dart';
import 'package:openim_demo/src/models/people_nearby.dart';
import 'package:sp_util/sp_util.dart';
import 'package:sprintf/sprintf.dart';

class DataPersistence {
  static const _FREQUENT_CONTACTS = "%s_frequentContacts";
  static const _CALL_RECORDS = "%s_callRecords";
  static const _LOGIN_INFO = 'loginCertificate';
  static const _AT_USER_INFO = '%s_atUserInfo';
  static const _SERVER = "server";
  static const _IP = 'ip';
  static const _language = "language";
  static const _ignoreUpdate = 'ignoreUpdate';
  static const _jpushLogin = '%s_jpushLogin';
  static const _chatFontSizeFactor = '%s_chatFontSizeFactor';
  static const _chatBackground = '%s_chatBackground';

  static const _Agrement = 'Agrement';
  static const _isFirstAPP = 'isFirstAPP';

  DataPersistence._();

  static LoginCertificate? getLoginCertificate() {
    return SpUtil.getObj(
        _LOGIN_INFO, (v) => LoginCertificate.fromJson(v.cast()));
  }

  static Future<bool>? putLoginCertificate(LoginCertificate info) {
    return SpUtil.putObject(_LOGIN_INFO, info);
  }

  static Future<bool>? removeLoginCertificate() {
    return SpUtil.remove(_LOGIN_INFO);
  }

  static String getKey(String key) {
    return sprintf(key, [OpenIM.iMManager.uid]);
  }

  /// 常用联系人
  static List<String>? getFrequentContacts() {
    return SpUtil.getStringList(getKey(_FREQUENT_CONTACTS));
  }

  /// 常用联系人
  static Future<bool>? putFrequentContacts(List<String> uidList) {
    return SpUtil.putStringList(getKey(_FREQUENT_CONTACTS), uidList);
  }

  static Future<bool>? addCallRecords(CallRecords records) {
    var list = SpUtil.getObjectList(getKey(_CALL_RECORDS)) ?? [];
    list.insert(0, records.toJson());
    return SpUtil.putObjectList(getKey(_CALL_RECORDS), list);
  }

  static Future<bool>? putCallRecords(List<CallRecords> list) {
    return SpUtil.putObjectList(getKey(_CALL_RECORDS), list);
  }

  static List<CallRecords>? getCallRecords() {
    return SpUtil.getObjList(
      getKey(_CALL_RECORDS),
      (v) => CallRecords.fromJson(v.cast()),
    );
  }

  static Future<bool>? putPeopleNearbyRecords(List<PeopleNearby> list) {
    return SpUtil.putObjectList(getKey(_CALL_RECORDS), list);
  }

  static List<PeopleNearby>? getPeopleNearbyRecords() {
    return SpUtil.getObjList(
      getKey(_CALL_RECORDS),
      (v) => PeopleNearby.fromJson(v.cast()),
    );
  }

  static Future<bool>? putAtUserMap(String gid, Map<String, String> atMap) {
    return SpUtil.putObject(sprintf(_AT_USER_INFO, [gid]), atMap);
  }

  static Map? getAtUserMap(String gid) {
    return SpUtil.getObject(sprintf(_AT_USER_INFO, [gid]));
  }

  static void removeAtUserMap(String gid) {
    SpUtil.remove(sprintf(_AT_USER_INFO, [gid]));
  }

  static Future<bool>? putServerConfig(Map<String, String> config) {
    return SpUtil.putObject(_SERVER, config);
  }

  static Map? getServerConfig() {
    return SpUtil.getObject(_SERVER);
  }

  static Future<bool>? putServerIP(String ip) {
    return SpUtil.putString(_IP, ip);
  }

  static String? getServerIP() {
    return SpUtil.getString(_IP);
  }

  /// 设置用户协议
  static Future<bool>? putAgrement(bool agrement) {
    return SpUtil.putBool(_Agrement, agrement);
  }

  /// 删除协议
  static Future<bool>? removeAgrement() {
    return SpUtil.remove(_Agrement);
  }

  /// 获取用户协议
  static bool? getAgrement() {
    return SpUtil.getBool(_Agrement);
  }

  /// 判断写入
  static Future<bool>? putsFirstAPP(bool agrement) {
    return SpUtil.putBool(_isFirstAPP, agrement);
  }

  /// 获取是否第一次使用APP
  static bool? getIsFirstAPP() {
    return SpUtil.getBool(_isFirstAPP);
  }

  static Future<bool>? putLanguage(int index) {
    return SpUtil.putInt(_language, index);
  }

  static int? getLanguage() {
    return SpUtil.getInt(_language);
  }

  static Future<bool>? putIgnoreVersion(String version) {
    return SpUtil.putString(_ignoreUpdate, version);
  }

  static String? getIgnoreVersion() {
    return SpUtil.getString(_ignoreUpdate);
  }

  static Future<bool>? putJpushLoginStatus(String alias) {
    return SpUtil.putBool(sprintf(_jpushLogin, [alias]), true);
  }

  static bool? getJpushLoginStatus(String alias) {
    return SpUtil.getBool(sprintf(_jpushLogin, [alias]), defValue: false);
  }

  static Future<bool>? removeJpushLoginStatus(String alias) {
    return SpUtil.remove(sprintf(_jpushLogin, [alias]));
  }

  static Future<bool>? putChatFontSizeFactor(double factor) {
    return SpUtil.putDouble(getKey(_chatFontSizeFactor), factor);
  }

  static double? getChatFontSizeFactor() {
    return SpUtil.getDouble(getKey(_chatFontSizeFactor), defValue: 1.0);
  }

  static Future<bool>? putChatBackground(String path) {
    return SpUtil.putString(getKey(_chatBackground), path);
  }

  static String? getChatBackground() {
    return SpUtil.getString(getKey(_chatBackground));
  }
}
