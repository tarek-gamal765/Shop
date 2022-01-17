class ChangeFavouriteModel {
  bool? status;

  String? message;

  ChangeFavouriteModel.formJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
