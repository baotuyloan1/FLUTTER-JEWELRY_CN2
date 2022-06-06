import 'package:furniture_app/config.dart';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

class PostReview {
  Future<int> postReview({
    required String productId,
    required String customerId,
    required String rating,
    required String comment,
  }) async {
    final response = await http.post(Uri.parse(postReviewUrl), body: {
      "product_id": productId,
      "customer_id": customerId,
      "rating": rating,
      "comments": comment
    });
    return json.decode(response.body);
  }
}
