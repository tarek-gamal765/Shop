class GetFromCartModel {
  bool? status;

  GetFromCartDataModel? data;

  GetFromCartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null
        ? GetFromCartDataModel.fromJson(json['data'])
        : null;
  }
}

class GetFromCartDataModel {
  List<CartItemsDataModel> cartItems = [];

  GetFromCartDataModel.fromJson(Map<String, dynamic> json) {
    json['cart_items'].forEach((element) {
      cartItems.add(CartItemsDataModel.fromJson(element));
    });
  }
}

class CartItemsDataModel {
  int? id;
  int? quantity;
  ProductCartDataModel? product;

  CartItemsDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    product = json['product'] != null
        ? ProductCartDataModel.fromJson(json['product'])
        : null;
  }
}

class ProductCartDataModel {
  int? id;
  dynamic price;
  dynamic oldPrice;
  int? discount;
  String? image;
  String? name;
  String? description;
  List<dynamic>? images;
  bool? inFavorites;
  bool? inCart;

  ProductCartDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
    images = json['images'];
  }
}
