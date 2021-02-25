class FilterListModel {
  bool success;
  List<Courses> courses;

  FilterListModel({this.success, this.courses});

  FilterListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['courses'] != null) {
      courses = new List<Courses>();
      json['courses'].forEach((v) {
        courses.add(new Courses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.courses != null) {
      data['courses'] = this.courses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Courses {
  int id;
  String title;
  String description;
  String typeOfCourse;
  String thumbnail;
  String standardName;
  String boardName;
  String mediumName;
  String streamName;
  String subjectName;
  String thumbnailUrl;

  Courses(
      {this.id,
      this.title,
      this.description,
      this.typeOfCourse,
      this.thumbnail,
      this.standardName,
      this.boardName,
      this.mediumName,
      this.streamName,
      this.subjectName,
      this.thumbnailUrl});

  Courses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    typeOfCourse = json['type_of_course'];
    thumbnail = json['thumbnail'];
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
    data['description'] = this.description;
    data['type_of_course'] = this.typeOfCourse;
    data['thumbnail'] = this.thumbnail;
    data['standard_name'] = this.standardName;
    data['board_name'] = this.boardName;
    data['medium_name'] = this.mediumName;
    data['stream_name'] = this.streamName;
    data['subject_name'] = this.subjectName;
    data['thumbnail_url'] = this.thumbnailUrl;
    return data;
  }
}
