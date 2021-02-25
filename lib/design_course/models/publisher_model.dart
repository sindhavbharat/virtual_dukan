class PublisherModel {
  bool success;
  List<Publishers> publishers;

  PublisherModel({this.success, this.publishers});

  PublisherModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['publishers'] != null) {
      publishers = new List<Publishers>();
      json['publishers'].forEach((v) {
        publishers.add(new Publishers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.publishers != null) {
      data['publishers'] = this.publishers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Publishers {
  int id;
  String name;
  String logo;
  String logoUrl;

  Publishers({this.id, this.name, this.logo, this.logoUrl});

  Publishers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    logoUrl = json['logo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['logo_url'] = this.logoUrl;
    return data;
  }
}