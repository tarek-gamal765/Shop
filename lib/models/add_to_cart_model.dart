class AddToCartModel {
  bool? status;
  String? message;
  AddToCartDataModel? data;
  AddToCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['product'] != null
        ? AddToCartDataModel.fromJson(json['product'])
        : null;
  }
}

class AddToCartDataModel {
  int? id;
  int? quantity;
  ProductDataModel? product;
  AddToCartDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product = json['product'] != null
        ? ProductDataModel.fromJson(json['product'])
        : null;
  }
}

class ProductDataModel {
  int? id;
  int? price;
  int? oldPrice;
  int? discount;
  String? name;
  String? image;
  String? description;
  ProductDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['oldPrice'];
    discount = json['discount'];
    name = json['name'];
    name = json['image'];
    name = json['description'];
  }
}
