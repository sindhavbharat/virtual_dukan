class MeetingListModel {
  int currentPage;
  List<Data> data;
  int lastPage;
  int perPage;
  int total;

  MeetingListModel(
      {this.currentPage, this.data, this.lastPage, this.perPage, this.total});

  MeetingListModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['last_page'] = this.lastPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    return data;
  }
}

class Data {
  String uuid;
  int id;
  String hostId;
  String topic;
  int type;
  String startTime;
  int duration;
  String timezone;
  String agenda;
  String createdAt;
  String joinUrl;
  String userId;

  Data(
      {this.uuid,
        this.id,
        this.hostId,
        this.topic,
        this.type,
        this.startTime,
        this.duration,
        this.timezone,
        this.agenda,
        this.createdAt,
        this.joinUrl,
        this.userId});

  Data.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    id = json['id'];
    hostId = json['host_id'];
    topic = json['topic'];
    type = json['type'];
    startTime = json['start_time'];
    duration = json['duration'];
    timezone = json['timezone'];
    agenda = json['agenda'];
    createdAt = json['created_at'];
    joinUrl = json['join_url'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['id'] = this.id;
    data['host_id'] = this.hostId;
    data['topic'] = this.topic;
    data['type'] = this.type;
    data['start_time'] = this.startTime;
    data['duration'] = this.duration;
    data['timezone'] = this.timezone;
    data['agenda'] = this.agenda;
    data['created_at'] = this.createdAt;
    data['join_url'] = this.joinUrl;
    data['user_id'] = this.userId;
    return data;
  }
}
// class MeetingListModel {
//   int pageSize;
//   int totalRecords;
//   String nextPageToken;
//   List<Meetings> meetings;
//
//   MeetingListModel(
//       {this.pageSize, this.totalRecords, this.nextPageToken, this.meetings});
//
//   MeetingListModel.fromJson(Map<String, dynamic> json) {
//     pageSize = json['page_size'];
//     totalRecords = json['total_records'];
//     nextPageToken = json['next_page_token'];
//     if (json['meetings'] != null) {
//       meetings = new List<Meetings>();
//       json['meetings'].forEach((v) {
//         meetings.add(new Meetings.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['page_size'] = this.pageSize;
//     data['total_records'] = this.totalRecords;
//     data['next_page_token'] = this.nextPageToken;
//     if (this.meetings != null) {
//       data['meetings'] = this.meetings.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Meetings {
//   String uuid;
//   int id;
//   String hostId;
//   String topic;
//   int type;
//   String startTime;
//   int duration;
//   String timezone;
//   String createdAt;
//   String joinUrl;
//
//   Meetings(
//       {this.uuid,
//       this.id,
//       this.hostId,
//       this.topic,
//       this.type,
//       this.startTime,
//       this.duration,
//       this.timezone,
//       this.createdAt,
//       this.joinUrl});
//
//   Meetings.fromJson(Map<String, dynamic> json) {
//     uuid = json['uuid'];
//     id = json['id'];
//     hostId = json['host_id'];
//     topic = json['topic'];
//     type = json['type'];
//     startTime = json['start_time'];
//     duration = json['duration'];
//     timezone = json['timezone'];
//     createdAt = json['created_at'];
//     joinUrl = json['join_url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['uuid'] = this.uuid;
//     data['id'] = this.id;
//     data['host_id'] = this.hostId;
//     data['topic'] = this.topic;
//     data['type'] = this.type;
//     data['start_time'] = this.startTime;
//     data['duration'] = this.duration;
//     data['timezone'] = this.timezone;
//     data['created_at'] = this.createdAt;
//     data['join_url'] = this.joinUrl;
//     return data;
//   }
// }
