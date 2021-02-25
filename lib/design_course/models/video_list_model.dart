class VideoListModel {
  bool success;
  List<Videos> videos;

  VideoListModel({this.success, this.videos});

  VideoListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['videos'] != null) {
      videos = new List<Videos>();
      json['videos'].forEach((v) {
        videos.add(new Videos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.videos != null) {
      data['videos'] = this.videos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Videos {
  int courseId;
  String title;
  int keepAsDemo;
  String videoUrl;
  String videoThumbnailUrl;
  int orderNo;
  String previewTitle;

  Videos(
      {this.courseId,
      this.title,
      this.keepAsDemo,
      this.videoUrl,
      this.videoThumbnailUrl,
      this.orderNo,
      this.previewTitle});

  Videos.fromJson(Map<String, dynamic> json) {
    courseId = json['course_id'];
    title = json['title'];
    keepAsDemo = json['keep_as_demo'];
    videoUrl = json['video_url'];
    videoThumbnailUrl = json['video_thumbnail_url'];
    orderNo = json['order_no'];
    previewTitle = json['preview_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course_id'] = this.courseId;
    data['title'] = this.title;
    data['keep_as_demo'] = this.keepAsDemo;
    data['video_url'] = this.videoUrl;
    data['video_thumbnail_url'] = this.videoThumbnailUrl;
    data['order_no'] = this.orderNo;
    data['preview_title'] = this.previewTitle;
    return data;
  }
}