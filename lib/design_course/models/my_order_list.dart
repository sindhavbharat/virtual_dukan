class MyOrderListModel {
  bool success;
  List<Orders> orders;

  MyOrderListModel({this.success, this.orders});

  MyOrderListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['orders'] != null) {
      orders = new List<Orders>();
      json['orders'].forEach((v) {
        orders.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.orders != null) {
      data['orders'] = this.orders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  int id;
  String txnId;
  int userId;
  int courseId;
  int instituteId;
  int quantity;
  String amount;
  Items items;
  String address;
  String city;
  String pincode;
  String createdAt;
  String updatedAt;

  Orders(
      {this.id,
        this.txnId,
        this.userId,
        this.courseId,
        this.instituteId,
        this.quantity,
        this.amount,
        this.items,
        this.address,
        this.city,
        this.pincode,
        this.createdAt,
        this.updatedAt});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    txnId = json['txn_id'];
    userId = json['user_id'];
    courseId = json['course_id'];
    instituteId = json['institute_id'];
    quantity = json['quantity'];
    amount = json['amount'];
    items = json['items'] != null ? new Items.fromJson(json['items']) : null;
    address = json['address'];
    city = json['city'];
    pincode = json['pincode'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['txn_id'] = this.txnId;
    data['user_id'] = this.userId;
    data['course_id'] = this.courseId;
    data['institute_id'] = this.instituteId;
    data['quantity'] = this.quantity;
    data['amount'] = this.amount;
    if (this.items != null) {
      data['items'] = this.items.toJson();
    }
    data['address'] = this.address;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Items {
  String username;
  int productId;
  int instituteId;
  String instituteName;
  String productTitle;
  String thumbnail;
  String description;
  String mrpPrice;
  String salePrice;
  String type;

  Items(
      {this.username,
        this.productId,
        this.instituteId,
        this.instituteName,
        this.productTitle,
        this.thumbnail,
        this.description,
        this.mrpPrice,
        this.salePrice,
        this.type});

  Items.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    productId = json['product_id'];
    instituteId = json['institute_id'];
    instituteName = json['institute_name'];
    productTitle = json['product_title'];
    thumbnail = json['thumbnail'];
    description = json['description'];
    mrpPrice = json['mrp_price'];
    salePrice = json['sale_price'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['product_id'] = this.productId;
    data['institute_id'] = this.instituteId;
    data['institute_name'] = this.instituteName;
    data['product_title'] = this.productTitle;
    data['thumbnail'] = this.thumbnail;
    data['description'] = this.description;
    data['mrp_price'] = this.mrpPrice;
    data['sale_price'] = this.salePrice;
    data['type'] = this.type;
    return data;
  }
}