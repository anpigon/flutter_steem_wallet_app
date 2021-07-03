import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/utils/color_utils.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WalletListItem extends StatelessWidget {
  final Widget icon;
  final double amount;
  final double price;
  final String symbol;
  final double ratio;
  final VoidCallback onTap;

  const WalletListItem({
    Key? key,
    required this.icon,
    required this.amount,
    required this.price,
    required this.symbol,
    required this.ratio,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priceNumberFormat = NumberFormat('###,###,###,###.##');
    final priceString = priceNumberFormat.format(price);
    final totalString = priceNumberFormat.format(amount * price).trim();
    final amountString = NumberFormat('###,###,###,###.###').format(amount);

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(23),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$amountString $symbol'),
                  const SizedBox(height: 5),
                  Text(
                    '\$ $priceString',
                    style: TextStyle(color: Get.theme.hintColor),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$ $totalString'),
                  const SizedBox(height: 5),
                  Text(
                    '${ratio > 0 ? '+' : ''} ${ratio.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: getRatioColor(ratio),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
