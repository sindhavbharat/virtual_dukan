class InstitutesModel {
  bool success;
  List<Institutes> institutes;

  InstitutesModel({this.success, this.institutes});

  InstitutesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['institutes'] != null) {
      institutes = new List<Institutes>();
      json['institutes'].forEach((v) {
        institutes.add(new Institutes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.institutes != null) {
      data['institutes'] = this.institutes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Institutes {
  int id;
  int isSuperadmin;
  String name;
  String email;
  String mobileNo;
  String emailVerifiedAt;
  int status;
  String profileImage;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String profileImageUrl;

  Institutes(
      {this.id,
      this.isSuperadmin,
      this.name,
      this.email,
      this.mobileNo,
      this.emailVerifiedAt,
      this.status,
      this.profileImage,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.profileImageUrl});

  Institutes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isSuperadmin = json['is_superadmin'];
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    emailVerifiedAt = json['email_verified_at'];
    status = json['status'];
    profileImage = json['profile_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    profileImageUrl = json['profile_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_superadmin'] = this.isSuperadmin;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['status'] = this.status;
    data['profile_image'] = this.profileImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['profile_image_url'] = this.profileImageUrl;
    return data;
  }
}
