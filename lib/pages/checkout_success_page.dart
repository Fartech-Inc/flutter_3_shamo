import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shamo/providers/transaction_provider.dart';
import 'package:shamo/theme.dart';

class CheckoutSuccessPage extends StatelessWidget {
  const CheckoutSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionProvider transactionProvider =
    Provider.of<TransactionProvider>(context);

    AppBar header() {
      return AppBar(
        backgroundColor: backgroundColor1,
        centerTitle: true,
        title: const Text(
          'Checkout Success',
        ),
        elevation: 0,
      );
    }

    Widget content() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon_empty_cart.png',
              width: 80,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'You made a transaction',
              style: primaryTextStyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'Lakukan pembayaran untuk menyelesaikan transaksi',
              style: secondaryTextStyle,
              textAlign: TextAlign.center,
            ),
            // if (transactionProvider.midtrans.grossAmount != null)
            //   Text(
            //     'Total Harga : Rp ${transactionProvider.midtrans.grossAmount}',
            //     style: primaryTextStyle.copyWith(fontWeight: bold),
            //     textAlign: TextAlign.center,
            //   ),
            // if (transactionProvider.midtrans.vaNumbers != null &&
            //     transactionProvider.midtrans.vaNumbers!.isNotEmpty)
            //   Column(
            //     children: [
            //       Text(
            //         'Bank : ${transactionProvider.midtrans.vaNumbers!.first.bank.toUpperCase()}',
            //         style: secondaryTextStyle,
            //         textAlign: TextAlign.center,
            //       ),
            //       Text(
            //         'VA Number : ${transactionProvider.midtrans.vaNumbers!.first.vaNumber}',
            //         style: secondaryTextStyle,
            //         textAlign: TextAlign.center,
            //       ),
            //     ],
            //   ),
            Container(
              width: 196,
              height: 44,
              margin: EdgeInsets.only(top: defaultMargin),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Order Other Shoes',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                  ),
                ),
                onPressed: () {
                  // Navigator.pushNamedAndRemoveUntil(
                  //     context, '/home', (route) => false);
                  context.replace('home');
                },
              ),
            ),
            Container(
              width: 196,
              height: 44,
              margin: const EdgeInsets.only(top: 12),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff39374B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'View My Order',
                  style: primaryTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: medium,
                    color: const Color(0xffB7B6BF),
                  ),
                ),
                onPressed: () {
                  // Navigator.pushNamed(context, '/my-orders');
                  context.push('/my-orders');
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor3,
      appBar: header(),
      body: content(),
    );
  }
}
