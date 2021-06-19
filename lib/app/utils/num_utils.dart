import 'dart:math' as math;

import 'package:intl/intl.dart';

final amountFormat = NumberFormat('###,##0.0##', 'en_US');

String toFixedTrunc(num value, [int fixed = 0]) {
  final _fixed = math.pow(10, fixed);
  return ((value * _fixed).floor() / _fixed).toStringAsFixed(fixed);
}

String toCurrencyFormat(num value) {
  return amountFormat.format((value * 1000).floor() / 1000);
}
