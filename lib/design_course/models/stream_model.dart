class StreamListModel {
  bool success;
  List<Streams> streams;

  StreamListModel({this.success, this.streams});

  StreamListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['streams'] != null) {
      streams = new List<Streams>();
      json['streams'].forEach((v) {
        streams.add(new Streams.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.streams != null) {
      data['streams'] = this.streams.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Streams {
  int id;
  String name;

  Streams({this.id, this.name});

  Streams.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
