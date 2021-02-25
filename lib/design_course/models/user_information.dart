class UserInformationModel {
  bool success;
  int code;
  User user;

  UserInformationModel({this.success, this.code, this.user});

  UserInformationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int id;
  Null provider;
  Null providerId;
  String name;
  String email;
  Null mobileNo;
  Null city;
  Null standard;
  Null board;
  Null medium;
  Null stream;
  Null emailVerifiedAt;
  Null otp;
  int status;
  String profileImage;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  User(
      {this.id,
      this.provider,
      this.providerId,
      this.name,
      this.email,
      this.mobileNo,
      this.city,
      this.standard,
      this.board,
      this.medium,
      this.stream,
      this.emailVerifiedAt,
      this.otp,
      this.status,
      this.profileImage,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    provider = json['provider'];
    providerId = json['provider_id'];
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    city = json['city'];
    standard = json['standard'];
    board = json['board'];
    medium = json['medium'];
    stream = json['stream'];
    emailVerifiedAt = json['email_verified_at'];
    otp = json['otp'];
    status = json['status'];
    profileImage = json['profile_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider'] = this.provider;
    data['provider_id'] = this.providerId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['city'] = this.city;
    data['standard'] = this.standard;
    data['board'] = this.board;
    data['medium'] = this.medium;
    data['stream'] = this.stream;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['otp'] = this.otp;
    data['status'] = this.status;
    data['profile_image'] = this.profileImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
