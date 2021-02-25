class MediumListModel {
  bool success;
  List<Mediums> mediums;

  MediumListModel({this.success, this.mediums});

  MediumListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['mediums'] != null) {
      mediums = new List<Mediums>();
      json['mediums'].forEach((v) {
        mediums.add(new Mediums.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.mediums != null) {
      data['mediums'] = this.mediums.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Mediums {
  int id;
  String name;

  Mediums({this.id, this.name});

  Mediums.fromJson(Map<String, dynamic> json) {
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
