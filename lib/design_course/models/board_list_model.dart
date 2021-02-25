class BoardListModel {
  bool success;
  List<Boards> boards;

  BoardListModel({this.success, this.boards});

  BoardListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['boards'] != null) {
      boards = new List<Boards>();
      json['boards'].forEach((v) {
        boards.add(new Boards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.boards != null) {
      data['boards'] = this.boards.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Boards {
  int id;
  String name;

  Boards({this.id, this.name});

  Boards.fromJson(Map<String, dynamic> json) {
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
