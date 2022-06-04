class DiscountModel {
  int? discountId;
  String? discountName;
  int? discountPercent;
  String? discountImage;
  String? discountObject;
  int? status;
  String? createdAt;
  String? updatedAt;

  DiscountModel(
      {required this.discountId,
      required this.discountName,
      required this.discountPercent,
      required this.discountImage,
      required this.discountObject,
      required this.status,
      required this.createdAt,
      required this.updatedAt});

  // DiscountModel.fromJson(dynamic json) {
  //   print(json);
  //   discount_id = json["discount_id"];
  //   discount_name = json["discount_name"];
  //   discount_percent = json["discount_percent"];
  //   discount_image = json["discount_image"];
  //   discount_object = json["discount_object"];
  //   status = json["status"];
  //   createdAt = json["created_at"];
  //   updatedAt = json["updated_at"];
  // }

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
        discountId: json["discount_id"],
        discountName: json["discount_name"],
        discountPercent: json["discount_percent"],
        discountImage: json["discount_image"],
        discountObject: json["discount_object"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"]);
  }
}
