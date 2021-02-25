class ProductListModel {
  bool success;
  List<Products> products;

  ProductListModel({this.success, this.products});

  ProductListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
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
  String offeredVendorDiscount;
  String discount;
  String sellPrice;
  String createdAt;
  String updatedAt;
  Null deletedAt;
  String thumbnailUrl;
  String subjectName;

  Products(
      {this.id,
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
        this.offeredVendorDiscount,
        this.discount,
        this.sellPrice,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.thumbnailUrl,
        this.subjectName});

  Products.fromJson(Map<String, dynamic> json) {
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
    offeredVendorDiscount = json['offered_vendor_discount'];
    discount = json['discount'];
    sellPrice = json['sell_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    thumbnailUrl = json['thumbnail_url'];
    subjectName = json['subject_name'];
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
    data['offered_vendor_discount'] = this.offeredVendorDiscount;
    data['discount'] = this.discount;
    data['sell_price'] = this.sellPrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['subject_name'] = this.subjectName;
    return data;
  }
}