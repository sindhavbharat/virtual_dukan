class StationaryDetailsListModel {
  bool success;
  Product product;

  StationaryDetailsListModel({this.success, this.product});

  StationaryDetailsListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    return data;
  }
}

class Product {
  int id;
  int stationaryId;
  String name;
  String subTitle;
  String keywords;
  String description;
  int publisherId;
  String thumbnail;
  int commonProduct;
  String setOf;
  String quantity;
  String subjectId;
  String mrpPrice;
  String sellPrice;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String thumbnailUrl;
  String subjectName;
  StationaryInfo stationaryInfo;

  Product({this.id,
    this.stationaryId,
    this.name,
    this.subTitle,
    this.keywords,
    this.description,
    this.publisherId,
    this.thumbnail,
    this.commonProduct,
    this.setOf,
    this.quantity,
    this.subjectId,
    this.mrpPrice,
    this.sellPrice,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.thumbnailUrl,
    this.subjectName,
    this.stationaryInfo});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stationaryId = json['stationary_id'];
    name = json['name'];
    subTitle = json['sub_title'];
    keywords = json['keywords'];
    description = json['description'];
    publisherId = json['publisher_id'];
    thumbnail = json['thumbnail'];
    commonProduct = json['common_product'];
    setOf = json['set_of'];
    quantity = json['quantity'];
    subjectId = json['subject_id'];
    mrpPrice = json['mrp_price'];
    sellPrice = json['sell_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    thumbnailUrl = json['thumbnail_url'];
    subjectName = json['subject_name'];
    stationaryInfo = json['stationary_info'] != null
        ? new StationaryInfo.fromJson(json['stationary_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stationary_id'] = this.stationaryId;
    data['name'] = this.name;
    data['sub_title'] = this.subTitle;
    data['keywords'] = this.keywords;
    data['description'] = this.description;
    data['publisher_id'] = this.publisherId;
    data['thumbnail'] = this.thumbnail;
    data['common_product'] = this.commonProduct;
    data['set_of'] = this.setOf;
    data['quantity'] = this.quantity;
    data['subject_id'] = this.subjectId;
    data['mrp_price'] = this.mrpPrice;
    data['sell_price'] = this.sellPrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['subject_name'] = this.subjectName;
    if (this.stationaryInfo != null) {
      data['stationary_info'] = this.stationaryInfo.toJson();
    }
    return data;
  }
}

class StationaryInfo {
  int id;
  String name;
  String profileImage;
  String profileImageUrl;

  StationaryInfo({this.id, this.name, this.profileImage, this.profileImageUrl});

  StationaryInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profile_image'];
    profileImageUrl = json['profile_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    data['profile_image_url'] = this.profileImageUrl;
    return data;
  }
}
