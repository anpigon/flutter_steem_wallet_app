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

double calculateVestToSteem(
  dynamic vesting_shares,
  dynamic total_vesting_shares,
  dynamic total_vesting_fund_steem,
) {
  final totalVestingShares =
      double.parse(toString(total_vesting_shares).split(' ')[0]);
  final totalVestingFundSteem =
      double.parse(toString(total_vesting_fund_steem).split(' ')[0]);
  final vestingShares = double.parse(toString(vesting_shares).split(' ')[0]);
  final steem = vestingShares / totalVestingShares * totalVestingFundSteem;
  return steem;
}

double calculateSteemToVest(
  dynamic amount,
  dynamic total_vesting_shares,
  dynamic total_vesting_fund_steem,
) {
  final totalVestingShares =
      double.parse(toString(total_vesting_shares).split(' ')[0]);
  final totalVestingFundSteem =
      double.parse(toString(total_vesting_fund_steem).split(' ')[0]);
  final steem = double.parse(toString(amount).split(' ')[0]);
  final vestingShares =  steem / totalVestingFundSteem * totalVestingShares ;
  return vestingShares;
}

int parseInteger(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is double) {
    return value.toInt();
  }
  if (value is String) {
    return int.parse(value);
  }
  return 0;
}

double parseDouble(dynamic value) {
  if (value is double) {
    return value;
  }
  if (value is double) {
    return value.toDouble();
  }
  if (value is String) {
    return double.parse(value);
  }
  return 0;
}

String toString(dynamic value) {
  return '$value';
}
