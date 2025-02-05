import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamo/models/transaction_model.dart';
import 'package:shamo/providers/auth_provider.dart';
import 'package:shamo/providers/transaction_provider.dart';
import 'package:shamo/theme.dart';

import '../utils/helper.dart';

class TransactionHistoryPage extends StatefulWidget {
  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  void _fetchTransactions() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    TransactionProvider transactionProvider = Provider.of<TransactionProvider>(context, listen: false);

    await transactionProvider.fetchTransactions(authProvider.user.token!);
  }

  @override
  Widget build(BuildContext context) {
    TransactionProvider transactionProvider = Provider.of<TransactionProvider>(context);
    List<TransactionModel> transactions = transactionProvider.transactions;

    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History', style: primaryTextStyle),
        backgroundColor: backgroundColor1,
        centerTitle: true,
      ),
      body: transactions.isEmpty
          ? Center(
        child: Text(
          'No transactions yet',
          style: secondaryTextStyle,
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          TransactionModel transaction = transactions[index];
          return Card(
            color: Colors.black,
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                'Order #${transaction.id}',
                style: primaryTextStyle.copyWith(fontWeight: semiBold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    "Total: ${Helper().formatRupiah(transaction.totalPrice)}",
                    style: secondaryTextStyle,
                  ),
                  const SizedBox(height: 4),
                  // Text(
                  //   'Status: ${transaction.status}',
                  //   style: TextStyle(
                  //     color: transaction.status == 'pending' ? Colors.orange : Colors.green,
                  //   ),
                  // ),
                  const SizedBox(height: 4),
                  // Text(
                  //   'Date: ${transaction.created_at}',
                  //   style: secondaryTextStyle,
                  // ),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: primaryTextColor),
            ),
          );
        },
      ),
    );
  }
}
