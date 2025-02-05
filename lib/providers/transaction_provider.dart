import 'package:flutter/material.dart';
import 'package:shamo/models/cart_model.dart';
import 'package:shamo/services/transaction_service.dart';

import '../models/transaction_model.dart';

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

  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  Future<void> fetchTransactions(String token) async {
    try {
      _transactions = await TransactionService().getTransactions(token);
      notifyListeners();
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }
}