class ApiResp {
  int errCode;
  String errMsg;
  dynamic data;

  ApiResp.fromJson(Map<String, dynamic> map)
      : errCode = map["errCode"],
        errMsg = map["errMsg"],
        data = map["data"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['errCode'] = errCode;
    data['errMsg'] = errMsg;
    data['data'] = data;
    return data;
  }
}

class MomentApiResp {
  int code;
  String msg;
  dynamic data;
  int errCode;

  MomentApiResp.fromJson(Map<String, dynamic> map)
      : errCode = map["errCode"] ?? 0,
        msg = map["msg"],
        code = map["code"],
        data = map["data"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = errCode;
    data['errCode'] = errCode;
    data['msg'] = msg;
    data['data'] = data;
    return data;
  }
}
