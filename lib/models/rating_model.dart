class RatingModel {
  int? ratingId;
  int? productId;
  int? customerId;
  String? customerName;
  String? customerImage;
  int? rating;
  String? comment;
  int? status;
  String? createdAt;
  String? updatedAt;

  RatingModel();

  RatingModel.fromJson(dynamic json) {
    ratingId = json["rating_id"];
    productId = json["product_id"];
    customerId = json["customer_id"];
    customerName = json["customer_name"];
    customerImage = json["customer_img"];
    rating = json["rating"];
    comment = json["comments"];
    status = json["status"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }
}
