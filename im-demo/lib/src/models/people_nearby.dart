class PeopleNearby {
  int code;
  String msg;
  dynamic data;
  int errCode;

  // PeopleNearby({
  //   int code;
  //   String msg;
  //   dynamic data;
  //   int errCode;
  // });

  PeopleNearby.fromJson(Map<String, dynamic> map)
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

class PeopleNearbyUser {
  String? userId;
  String avatar;
  String name;
  int gender;
  String createTime;
  String distance;

  getDistance(){
    double distanceInMeters = double.parse(distance);
    double distanceInKiloMeters = distanceInMeters * 10;
    double.parse((distanceInKiloMeters).toStringAsFixed(2));
    return distanceInKiloMeters.toStringAsFixed(1);
  }

  PeopleNearbyUser.fromJson(Map<String, dynamic> map) :
        userId = map["user_id"] ?? 0,
        avatar = map["avatar"],
        name = map["name"],
        gender = map["gender"],
        createTime = map["create_time"],
        distance = map["distance"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['avatar'] = avatar;
    data['name'] = name;
    data['gender'] = gender;
    data['create_time'] = createTime;
    data['distance'] = distance;
    return data;
  }
}