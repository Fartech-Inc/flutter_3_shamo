import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamo/providers/auth_provider.dart';
import 'package:shamo/providers/cart_provider.dart';
import 'package:shamo/providers/transaction_provider.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/utils/helper.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? va;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    TransactionProvider transactionProvider =
    Provider.of<TransactionProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleCheckout() async {
      // if (va == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Please select a payment method')),
      //   );
      //   return;
      // }

      setState(() {
        isLoading = true;
      });

      debugPrint("ini token ${authProvider.user.token!}");

      bool success = await transactionProvider.checkout(
        authProvider.user.token!,
        cartProvider.carts,
        cartProvider.totalPrice(),
        10000, // Shipping price (example value)
        // 'Jl. Contoh No. 123',
        ""
      );

      setState(() {
        isLoading = false;
      });

      if (success) {
        // cartProvider.removeCart();
        Navigator.pushNamedAndRemoveUntil(
            context, '/checkout-success', (route) => false);
      }
    }

    AppBar header() {
      return AppBar(
        backgroundColor: backgroundColor1,
        elevation: 0,
        centerTitle: true,
        title: const Text('Payment Details'),
      );
    }

    Widget paymentButton() {
      return Container(
        height: 50,
        width: double.infinity,
        margin: EdgeInsets.all(defaultMargin),
        child: TextButton(
          onPressed: isLoading ? null : handleCheckout,
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
            'Pay Now',
            style: primaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: bold,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor3,
      appBar: header(),
      body: Column(
        children: [
          Expanded(child: ListView(children: [])),
          paymentButton(),
        ],
      ),
    );
  }
}
