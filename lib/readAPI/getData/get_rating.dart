import 'dart:convert';

import 'package:furniture_app/config.dart';
import 'package:furniture_app/models/rating_model.dart';
import 'package:http/http.dart' as http;

Future<List<RatingModel>> showRatings(String? productId) async {
  // final response = await http.post(Uri.parse(getBillingUrl), body: {
  //   "customer_id": cusID.toString(),
  // });
  // if (response.statusCode == 200) {
  //   final list = ((json.decode(response.body)) as List<dynamic>)
  //       .map((value) => BillingModel.fromJson(value))
  //       .toList();
  //   return list;
  // } else {
  //   throw Exception('Failed to load album');
  // }
  final response = await http.post(Uri.parse(getRatingByProductIdUrl),
      body: {"product_id": productId});
  final list = ((json.decode(response.body)) as List<dynamic>)
      .map((value) => RatingModel.fromJson(value))
      .toList();
  return list;
}
