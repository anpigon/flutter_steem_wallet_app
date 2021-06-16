import 'dart:convert';

class Transfer {
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
        assert(amount * 1000 is int),
        assert(symbol == 'STEEM' || symbol == 'SBD');

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'amount': '${amount.toStringAsFixed(3)} $symbol',
        'memo': memo ?? '',
      };

  String toPrettyJson() => JsonEncoder.withIndent('  ').convert(toJson());
}
