class StandardListModel {
  bool success;
  List<Standards> standards;

  StandardListModel({this.success, this.standards});

  StandardListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['standards'] != null) {
      standards = new List<Standards>();
      json['standards'].forEach((v) {
        standards.add(new Standards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.standards != null) {
      data['standards'] = this.standards.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Standards {
  int id;
  String name;

  Standards({this.id, this.name});

  Standards.fromJson(Map<String, dynamic> json) {
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
