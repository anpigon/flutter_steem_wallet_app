import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/utils/num_utils.dart';
import 'package:intl/intl.dart';

class BalanceSmallBox extends StatelessWidget {
  final double amount;
  final String label;
  final String symbol;
  final bool loading;

  const BalanceSmallBox({
    Key? key,
    required this.label,
    required this.amount,
    required this.symbol,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textStyle = TextStyle(color: Colors.grey.shade600);

    return Container(
      margin: EdgeInsets.only(left: 5),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(width: 1, color: Colors.grey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: _textStyle),
          const SizedBox(width: 10),
          if (loading)
            Container(
              height: 10,
              width: 10,
              margin: EdgeInsets.only(right: 5),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey,
              ),
            ),
          if (!loading)
            Text(
              toCurrencyFormat(amount),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          const SizedBox(width: 5),
          Text(symbol, style: _textStyle),
        ],
      ),
    );
  }
}
