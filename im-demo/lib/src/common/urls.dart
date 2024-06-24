import 'config.dart';

class Urls {
  static var register2 = "${Config.imApiUrl()}/user/user_register";
  static var login2 = "${Config.imApiUrl()}/auth/user_token";
  static var importFriends = "${Config.imApiUrl()}/friend/import_friend";
  static var inviteToGroup = "${Config.imApiUrl()}/group/invite_user_to_group";
  static var onlineStatus =
      "${Config.imApiUrl()}/manager/get_users_online_status";
  static var publishMoment = "${Config.apiUrl()}/api/v1/content/sendContent";

  static var getMoment = "${Config.apiUrl()}/api/v1/content/getContentData";
  static var goodMoment = "${Config.apiUrl()}/api/v1/content/sendGood";
  static var commentMoment = "${Config.apiUrl()}/api/v1/content/sendComment";

  /// 附近人
  static var openPeopleNearby =
      "${Config.apiUrl()}/api/v1/peopleNearby/openPeopleNearby";
  static var getPeopleNearby =
      "${Config.apiUrl()}/api/v1/peopleNearby/getPeopleNearby";
  static var cleanPeopleNearby =
      "${Config.apiUrl()}/api/v1/peopleNearby/cleanPeopleNearby";

  ///
  // static const getVerificationCode = "/cpc/auth/code";
  // static const checkVerificationCode = "/cpc/auth/verify";
  // static const register = "/cpc/auth/password";
  // static const login = "/cpc/auth/login";

  /// 登录注册 独立于im的业务
  static var getVerificationCode = "${Config.appAuthUrl()}/demo/code";
  static var checkVerificationCode = "${Config.appAuthUrl()}/demo/verify";
  static var setPwd = "${Config.appAuthUrl()}/demo/password";
  static var resetPwd = "${Config.appAuthUrl()}/demo/reset_password";
  static var login = "${Config.appAuthUrl()}/demo/login";
  static var upgrade = "${Config.appAuthUrl()}/app/check";
  static var register = "${Config.appAuthUrl()}/demo/password";

  /// office
  static var getUserTags = "${Config.imApiUrl()}/office/get_user_tags";
  static var createTag = "${Config.imApiUrl()}/office/create_tag";
  static var deleteTag = "${Config.imApiUrl()}/office/delete_tag";
  static var updateTag = "${Config.imApiUrl()}/office/set_tag";
  static var sendMsgToTag = "${Config.imApiUrl()}/office/send_msg_to_tag";
  static var getSendTagLog = "${Config.imApiUrl()}/office/get_send_tag_log";
}
