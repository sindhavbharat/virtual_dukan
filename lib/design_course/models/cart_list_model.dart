class CartListModel {
  bool success;
  List<Items> items;
  int cartCount;
  bool product;
  String hash;
  String txnId;

  CartListModel(
      {this.success,
      this.items,
      this.cartCount,
      this.product,
      this.hash,
      this.txnId});

  CartListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    cartCount = json['cart_count'];
    product = json['product'];
    hash = json['hash'];
    txnId = json['txn_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['cart_count'] = this.cartCount;
    data['product'] = this.product;
    data['hash'] = this.hash;
    data['txn_id'] = this.txnId;
    return data;
  }
}

class Items {
  int courseId;
  String title;
  String thumbnail;
  String description;
  String mrpPrice;
  String salePrice;
  String type;
  int quantity;
  int productQuantity;

  Items({this.courseId,
    this.title,
    this.thumbnail,
    this.description,
    this.mrpPrice,
    this.salePrice,
    this.type,
    this.quantity,
  this.productQuantity});

  Items.fromJson(Map<String, dynamic> json) {
    courseId = json['course_id'];
    title = json['title'];
    thumbnail = json['thumbnail'];
    description = json['description'];
    mrpPrice = json['mrp_price'];
    salePrice = json['sale_price'];
    type = json['type'];
    quantity = json['quantity'];
    productQuantity = json['product_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course_id'] = this.courseId;
    data['title'] = this.title;
    data['thumbnail'] = this.thumbnail;
    data['description'] = this.description;
    data['mrp_price'] = this.mrpPrice;
    data['sale_price'] = this.salePrice;
    data['type'] = this.type;
    data['quantity'] = this.quantity;
    data['product_quantity'] = this.productQuantity;
    return data;
  }
}
