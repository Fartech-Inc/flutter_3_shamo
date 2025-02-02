import 'package:flutter/material.dart';
import 'package:shamo/models/cart_model.dart';
import 'package:shamo/services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  Future<bool> checkout(
      String token,
      List<CartModel> carts,
      double totalPrice,
      double shippingPrice,
      String address,
      ) async {
    try {
      await TransactionService().checkout(
        token: token,
        carts: carts,
        totalPrice: totalPrice,
        shippingPrice: shippingPrice,
        address: address,
      );

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}