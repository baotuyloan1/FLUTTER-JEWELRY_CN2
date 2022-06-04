import 'package:furniture_app/config.dart';

import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

class DeleteBilling {
  Future<int> deleteBilling({
    required int? idBilling,
  }) async {
    final response = await http.post(Uri.parse(deleteBillingUrl), body: {
      "billing_id": idBilling.toString(),
    });
    return json.decode(response.body);
  }
}
