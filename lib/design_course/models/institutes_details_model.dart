class InstitutesDetailsModel {
  bool success;
  Institutes institutes;

  InstitutesDetailsModel({this.success, this.institutes});

  InstitutesDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    institutes = json['institutes'] != null
        ? new Institutes.fromJson(json['institutes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.institutes != null) {
      data['institutes'] = this.institutes.toJson();
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
  String lastLogin;
  int orderNo;
  String loginCount;
  int views;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String profileImageUrl;
  InstituteInfo instituteInfo;
  List<Courses> courses;

  Institutes(
      {this.id,
      this.isSuperadmin,
      this.name,
      this.email,
      this.mobileNo,
      this.emailVerifiedAt,
      this.status,
      this.profileImage,
      this.lastLogin,
      this.orderNo,
      this.loginCount,
      this.views,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.profileImageUrl,
      this.instituteInfo,
      this.courses});

  Institutes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isSuperadmin = json['is_superadmin'];
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    emailVerifiedAt = json['email_verified_at'];
    status = json['status'];
    profileImage = json['profile_image'];
    lastLogin = json['last_login'];
    orderNo = json['order_no'];
    loginCount = json['login_count'];
    views = json['views'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    profileImageUrl = json['profile_image_url'];
    instituteInfo = json['institute_info'] != null
        ? new InstituteInfo.fromJson(json['institute_info'])
        : null;
    if (json['courses'] != null) {
      courses = new List<Courses>();
      json['courses'].forEach((v) {
        courses.add(new Courses.fromJson(v));
      });
    }
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
    data['last_login'] = this.lastLogin;
    data['order_no'] = this.orderNo;
    data['login_count'] = this.loginCount;
    data['views'] = this.views;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['profile_image_url'] = this.profileImageUrl;
    if (this.instituteInfo != null) {
      data['institute_info'] = this.instituteInfo.toJson();
    }
    if (this.courses != null) {
      data['courses'] = this.courses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InstituteInfo {
  int id;
  int userId;
  String instituteType;
  String dob;
  String address;
  String city;
  String zip;
  String state;
  String country;
  String website;
  String whatsappNo;
  String mobileNo;
  String callTime;
  String qualification;
  String experience;
  String standardId;
  String streamId;
  String mediumId;
  String boardId;
  String primarySubject;
  String punchLine;
  String createdAt;
  String updatedAt;
  String standardName;
  String boardName;
  String mediumName;
  String streamName;
  String subjectName;

  InstituteInfo({this.id,
    this.userId,
    this.instituteType,
    this.dob,
    this.address,
    this.city,
    this.zip,
    this.state,
    this.country,
    this.website,
    this.whatsappNo,
    this.mobileNo,
    this.callTime,
    this.qualification,
    this.experience,
    this.standardId,
    this.streamId,
    this.mediumId,
    this.boardId,
    this.primarySubject,
    this.punchLine,
    this.createdAt,
    this.updatedAt,
    this.standardName,
    this.boardName,
    this.mediumName,
    this.streamName,
    this.subjectName});

  InstituteInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    instituteType = json['institute_type'];
    dob = json['dob'];
    address = json['address'];
    city = json['city'];
    zip = json['zip'];
    state = json['state'];
    country = json['country'];
    website = json['website'];
    whatsappNo = json['whatsapp_no'];
    mobileNo = json['mobile_no'];
    callTime = json['call_time'];
    qualification = json['qualification'];
    experience = json['experience'];
    standardId = json['standard_id'];
    streamId = json['stream_id'];
    mediumId = json['medium_id'];
    boardId = json['board_id'];
    primarySubject = json['primary_subject'];
    punchLine = json['punch_line'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    standardName = json['standard_name'];
    boardName = json['board_name'];
    mediumName = json['medium_name'];
    streamName = json['stream_name'];
    subjectName = json['subject_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['institute_type'] = this.instituteType;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['city'] = this.city;
    data['zip'] = this.zip;
    data['state'] = this.state;
    data['country'] = this.country;
    data['website'] = this.website;
    data['whatsapp_no'] = this.whatsappNo;
    data['mobile_no'] = this.mobileNo;
    data['call_time'] = this.callTime;
    data['qualification'] = this.qualification;
    data['experience'] = this.experience;
    data['standard_id'] = this.standardId;
    data['stream_id'] = this.streamId;
    data['medium_id'] = this.mediumId;
    data['board_id'] = this.boardId;
    data['primary_subject'] = this.primarySubject;
    data['punch_line'] = this.punchLine;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['standard_name'] = this.standardName;
    data['board_name'] = this.boardName;
    data['medium_name'] = this.mediumName;
    data['stream_name'] = this.streamName;
    data['subject_name'] = this.subjectName;
    return data;
  }
}

class Courses {
  int id;
  String title;
  String subTitle;
  String description;
  String keywords;
  String thumbnail;
  int instituteId;
  int standardId;
  String boardId;
  String mediumId;
  int streamId;
  int subjectId;
  String typeOfCourse;
  String mrpPrice;
  String salePrice;
  int orderNo;
  String views;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String standardName;
  String boardName;
  String mediumName;
  String streamName;
  String subjectName;
  String thumbnailUrl;

  Courses({this.id,
    this.title,
    this.subTitle,
    this.description,
    this.keywords,
    this.thumbnail,
    this.instituteId,
    this.standardId,
    this.boardId,
    this.mediumId,
    this.streamId,
    this.subjectId,
    this.typeOfCourse,
    this.mrpPrice,
    this.salePrice,
    this.orderNo,
    this.views,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.standardName,
    this.boardName,
    this.mediumName,
    this.streamName,
    this.subjectName,
    this.thumbnailUrl});

  Courses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subTitle = json['sub_title'];
    description = json['description'];
    keywords = json['keywords'];
    thumbnail = json['thumbnail'];
    instituteId = json['institute_id'];
    standardId = json['standard_id'];
    boardId = json['board_id'];
    mediumId = json['medium_id'];
    streamId = json['stream_id'];
    subjectId = json['subject_id'];
    typeOfCourse = json['type_of_course'];
    mrpPrice = json['mrp_price'];
    salePrice = json['sale_price'];
    orderNo = json['order_no'];
    views = json['views'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    standardName = json['standard_name'];
    boardName = json['board_name'];
    mediumName = json['medium_name'];
    streamName = json['stream_name'];
    subjectName = json['subject_name'];
    thumbnailUrl = json['thumbnail_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['sub_title'] = this.subTitle;
    data['description'] = this.description;
    data['keywords'] = this.keywords;
    data['thumbnail'] = this.thumbnail;
    data['institute_id'] = this.instituteId;
    data['standard_id'] = this.standardId;
    data['board_id'] = this.boardId;
    data['medium_id'] = this.mediumId;
    data['stream_id'] = this.streamId;
    data['subject_id'] = this.subjectId;
    data['type_of_course'] = this.typeOfCourse;
    data['mrp_price'] = this.mrpPrice;
    data['sale_price'] = this.salePrice;
    data['order_no'] = this.orderNo;
    data['views'] = this.views;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['standard_name'] = this.standardName;
    data['board_name'] = this.boardName;
    data['medium_name'] = this.mediumName;
    data['stream_name'] = this.streamName;
    data['subject_name'] = this.subjectName;
    data['thumbnail_url'] = this.thumbnailUrl;
    return data;
  }
}