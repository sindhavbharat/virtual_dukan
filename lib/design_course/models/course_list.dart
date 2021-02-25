class CourseList {
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

  CourseList(
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
      this.thumbnailUrl});

  CourseList.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
