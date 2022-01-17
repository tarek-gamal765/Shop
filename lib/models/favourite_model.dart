class FavouriteModel {
  bool? status;

  FavouriteDataModel? data;

  FavouriteModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = FavouriteDataModel.fromJson(json['data']);
  }
}

class FavouriteDataModel {
  List<DataModel> dataModel = [];

  FavouriteDataModel.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((element) {
      dataModel.add(DataModel.formJson(element));
    });
  }
}

class DataModel {
  int? id;

  FavouriteProductModel? favProduct;

  DataModel.formJson(Map<String, dynamic> json) {
    id = json['id'];
    favProduct = FavouriteProductModel.formJson(json['product']);
  }
}

class FavouriteProductModel {
  int? id;

  dynamic price;

  dynamic oldPrice;

  dynamic discount;

  String? image;

  String? name;
  String? description;

  FavouriteProductModel.formJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}
