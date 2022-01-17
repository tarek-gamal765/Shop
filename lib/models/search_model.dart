class SearchModel {
  bool? status;

  SearchDataModel? data;

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? SearchDataModel.fromJson(json['data']) : null;
  }
}

class SearchDataModel {
  List<DataModel> dataModel = [];

  SearchDataModel.fromJson(Map<String, dynamic> json) {
    json['data'].forEach((element) {
      dataModel.add(DataModel.formJson(element));
    });
  }
}

class DataModel {
  int? id;

  dynamic price;

  dynamic oldPrice;

  dynamic discount;

  String? image;

  String? name;

  DataModel.formJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
  }
}
