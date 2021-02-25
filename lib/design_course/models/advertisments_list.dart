class AdvertisementsModel {
  bool success;
  List<SliderAdvertisements> sliderAdvertisements;
  SliderAdvertisements popupAdvertisement;

  AdvertisementsModel(
      {this.success, this.sliderAdvertisements, this.popupAdvertisement});

  AdvertisementsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['slider_advertisements'] != null) {
      sliderAdvertisements = new List<SliderAdvertisements>();
      json['slider_advertisements'].forEach((v) {
        sliderAdvertisements.add(new SliderAdvertisements.fromJson(v));
      });
    }
    popupAdvertisement = json['popup_advertisement'] != null
        ? new SliderAdvertisements.fromJson(json['popup_advertisement'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.sliderAdvertisements != null) {
      data['slider_advertisements'] =
          this.sliderAdvertisements.map((v) => v.toJson()).toList();
    }
    if (this.popupAdvertisement != null) {
      data['popup_advertisement'] = this.popupAdvertisement.toJson();
    }
    return data;
  }
}

class SliderAdvertisements {
  int id;
  String type;
  String fileName;
  String fileUrl;
  String startDate;
  String endDate;
  String createdAt;
  String updatedAt;

  SliderAdvertisements(
      {this.id,
      this.type,
      this.fileName,
      this.fileUrl,
      this.startDate,
      this.endDate,
      this.createdAt,
      this.updatedAt});

  SliderAdvertisements.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    fileName = json['file_name'];
    fileUrl = json['file_url'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['file_name'] = this.fileName;
    data['file_url'] = this.fileUrl;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
