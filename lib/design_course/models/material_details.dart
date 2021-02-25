class MaterialDetailList {
  bool success;
  Course course;

  MaterialDetailList({this.success, this.course});

  MaterialDetailList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    course =
        json['course'] != null ? new Course.fromJson(json['course']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.course != null) {
      data['course'] = this.course.toJson();
    }
    return data;
  }
}

class Course {
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
  String createdAt;
  String updatedAt;
  String deletedAt;
  String standardName;
  String boardName;
  String mediumName;
  String streamName;
  String thumbnailUrl;
  List<Materials> materials;
  List<Videos> videos;

  Course(
      {this.id,
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
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.standardName,
      this.boardName,
      this.mediumName,
      this.streamName,
      this.thumbnailUrl,
      this.materials,
      this.videos});

  Course.fromJson(Map<String, dynamic> json) {
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
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    standardName = json['standard_name'];
    boardName = json['board_name'];
    mediumName = json['medium_name'];
    streamName = json['stream_name'];
    thumbnailUrl = json['thumbnail_url'];
    if (json['materials'] != null) {
      materials = new List<Materials>();
      json['materials'].forEach((v) {
        materials.add(new Materials.fromJson(v));
      });
    }
    if (json['videos'] != null) {
      videos = new List<Videos>();
      json['videos'].forEach((v) {
        videos.add(new Videos.fromJson(v));
      });
    }
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['standard_name'] = this.standardName;
    data['board_name'] = this.boardName;
    data['medium_name'] = this.mediumName;
    data['stream_name'] = this.streamName;
    data['thumbnail_url'] = this.thumbnailUrl;
    if (this.materials != null) {
      data['materials'] = this.materials.map((v) => v.toJson()).toList();
    }
    if (this.videos != null) {
      data['videos'] = this.videos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Materials {
  int id;
  int courseId;
  String title;
  String type;
  String fileName;
  String thumbnail;
  int keepAsDemo;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String materialUrl;
  String materialThumbnailUrl;

  Materials(
      {this.id,
      this.courseId,
      this.title,
      this.type,
      this.fileName,
      this.thumbnail,
      this.keepAsDemo,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.materialUrl,
      this.materialThumbnailUrl});

  Materials.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseId = json['course_id'];
    title = json['title'];
    type = json['type'];
    fileName = json['file_name'];
    thumbnail = json['thumbnail'];
    keepAsDemo = json['keep_as_demo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    materialUrl = json['material_url'];
    materialThumbnailUrl = json['material_thumbnail_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_id'] = this.courseId;
    data['title'] = this.title;
    data['type'] = this.type;
    data['file_name'] = this.fileName;
    data['thumbnail'] = this.thumbnail;
    data['keep_as_demo'] = this.keepAsDemo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['material_url'] = this.materialUrl;
    data['material_thumbnail_url'] = this.materialThumbnailUrl;
    return data;
  }
}

class Videos {
  int id;
  int courseId;
  String title;
  String fileName;
  String thumbnail;
  String fileLink;
  int keepAsDemo;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String videoUrl;
  String videoThumbnailUrl;

  Videos(
      {this.id,
      this.courseId,
      this.title,
      this.fileName,
      this.thumbnail,
      this.fileLink,
      this.keepAsDemo,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.videoUrl,
      this.videoThumbnailUrl});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseId = json['course_id'];
    title = json['title'];
    fileName = json['file_name'];
    thumbnail = json['thumbnail'];
    fileLink = json['file_link'];
    keepAsDemo = json['keep_as_demo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    videoUrl = json['video_url'];
    videoThumbnailUrl = json['video_thumbnail_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_id'] = this.courseId;
    data['title'] = this.title;
    data['file_name'] = this.fileName;
    data['thumbnail'] = this.thumbnail;
    data['file_link'] = this.fileLink;
    data['keep_as_demo'] = this.keepAsDemo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['video_url'] = this.videoUrl;
    data['video_thumbnail_url'] = this.videoThumbnailUrl;
    return data;
  }
}
