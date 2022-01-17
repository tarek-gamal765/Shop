class CategoriesModel {
  bool? status;

  CategoryDataModel? data;

  CategoriesModel. fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data =
        json['data'] != null ? CategoryDataModel.fromJson(json['data']) : null;
  }
}

class CategoryDataModel {
  int? currentPage;
  List<DataModel> data = [];

  CategoryDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    json['data'].forEach((element){
      data.add(DataModel.fromJson(element));
    });
  }
}

class DataModel {
  int? id;
  String? name;
  String? image;

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
