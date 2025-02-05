import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shamo/models/cart_model.dart';
import 'package:shamo/models/midtrans_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/transaction_model.dart';

class TransactionService {
  String baseUrl = 'https://doorprize-admin.my.id/api';

  Future<void> checkout({
    required String token,
    required List<CartModel> carts,
    required double totalPrice,
    required double shippingPrice,
    required String address,
  }) async {
    var url = '$baseUrl/checkout';
    debugPrint("ini token $token");
    debugPrint("ini carts $carts");
    debugPrint("ini total price $totalPrice");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var body = jsonEncode({
      'items': carts.map((cart) => {
        'id': cart.product.id,
        'quantity': cart.quantity,
      }).toList(),
      'total_price': totalPrice,
      'shipping_price': shippingPrice,
      'address': address,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String? paymentUrl = data['data']['payment_url'];
      debugPrint("payment url $paymentUrl");

      // Membuka URL pembayaran dengan url_launcher
      if (paymentUrl != null) {
        Uri paymentUri = Uri.parse(paymentUrl);
        // if (await canLaunchUrl(paymentUri)) {
        //   await launchUrl(paymentUri);
        // } else {
        //   throw 'Tidak dapat membuka URL pembayaran';
        // }
        await launchUrl(paymentUri);
      }
    } else {
      throw Exception('Gagal melakukan checkout');
    }
  }

  Future<List<TransactionModel>> getTransactions(String token) async {
    var url = '$baseUrl/transactions';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body); // Ubah ke Map<String, dynamic>

      print(jsonResponse['data']['data']); // Debugging, cek isi data

      // Pastikan data benar-benar diakses dengan ['data']['data']
      return TransactionModel.fromJsonList(jsonResponse['data']['data']);
    } else {
      throw Exception('Gagal mengambil transaksi');
    }
  }
}
