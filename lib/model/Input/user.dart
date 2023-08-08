class UserModel {
  User? user;
  UserInfo? userInfo;
  String? name;
  int? phoneNum;

  UserModel({this.user, this.userInfo, this.name, this.phoneNum});

  UserModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    userInfo = json['user_info'] != null
        ? new UserInfo.fromJson(json['user_info'])
        : null;
    name = json['name'];
    phoneNum = json['phoneNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.userInfo != null) {
      data['user_info'] = this.userInfo!.toJson();
    }
    data['name'] = this.name;
    data['phoneNum'] = this.phoneNum;
    return data;
  }
}

class User {
  String? userId;
  int? iat;

  User({this.userId, this.iat});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    iat = json['iat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['iat'] = this.iat;
    return data;
  }
}

class UserInfo {
  String? sId;
  List<String>? tripsTaken;
  String? serviceAreaId;
  bool? isVerified;
  bool? isRejected;
  bool? isBanned;
  String? licenseNum;
  int? iV;

  UserInfo(
      {this.sId,
      this.tripsTaken,
      this.serviceAreaId,
      this.isVerified,
      this.isRejected,
      this.isBanned,
      this.licenseNum,
      this.iV});

  UserInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    tripsTaken = json['tripsTaken'].cast<String>();
    serviceAreaId = json['serviceAreaId'];
    isVerified = json['isVerified'];
    isRejected = json['isRejected'];
    isBanned = json['isBanned'];
    licenseNum = json['licenseNum'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['tripsTaken'] = this.tripsTaken;
    data['serviceAreaId'] = this.serviceAreaId;
    data['isVerified'] = this.isVerified;
    data['isRejected'] = this.isRejected;
    data['isBanned'] = this.isBanned;
    data['licenseNum'] = this.licenseNum;
    data['__v'] = this.iV;
    return data;
  }
}
