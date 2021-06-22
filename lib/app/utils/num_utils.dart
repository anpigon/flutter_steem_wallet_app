import 'dart:math' as math;
import 'package:steemdart_ecc/steemdart_ecc.dart' as steem;
import 'package:intl/intl.dart';

final amountFormat = NumberFormat('###,##0.0##', 'en_US');

String toFixedTrunc(num value, [int fixed = 0]) {
  final _fixed = math.pow(10, fixed);
  return ((value * _fixed).floor() / _fixed).toStringAsFixed(fixed);
}

String toCurrencyFormat(num value) {
  return amountFormat.format((value * 1000).floor() / 1000);
}

double calculateVestToSteem(String vesting_shares, String total_vesting_shares,
    String total_vesting_fund_steem) {
  final totalVestingShares = steem.Asset.from(total_vesting_shares);
  final totalVestingFundSteem = steem.Asset.from(total_vesting_fund_steem);
  final vestingShares = steem.Asset.from(vesting_shares);
  final steemPower = vestingShares.amount /
      totalVestingShares.amount *
      totalVestingFundSteem.amount;
  return steemPower;
}
