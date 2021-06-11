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
        assert(amount % 0.001 == 0),
        assert(symbol == 'STEEM' || symbol == 'SBD');

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'amount': '$amount $symbol',
        'memo': memo ?? '',
      };

  String toPrettyJson() => JsonEncoder.withIndent('  ').convert(toJson());
}
