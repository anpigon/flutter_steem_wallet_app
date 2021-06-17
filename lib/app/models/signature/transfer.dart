import 'dart:convert';

import 'signature_model.dart';

class Transfer extends SignatureModel {
  late final String to;
  late final String from;
  late final String symbol;
  late final double amount;
  late final String? memo;

  Transfer({
    required this.to,
    required this.from,
    required this.symbol,
    required this.amount,
    this.memo,
  })  : assert(amount.isFinite),
        assert(symbol == 'STEEM' || symbol == 'SBD');

  @override
  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'amount': '${amount.toStringAsFixed(3)} $symbol',
        'memo': memo ?? '',
      };
}
