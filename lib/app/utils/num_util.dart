import 'dart:math' as math;

import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

class NumUtil {
  static const int maxDecimalDigits = 3;
  static final amountFormat = NumberFormat('###,###,###,##0.0##', 'en_US');

  static String toFixedTrunc(num value, [int digits = 0]) {
    final fixed = math.pow(10, digits);
    return ((value * fixed).floor() / fixed).toStringAsFixed(digits);
  }

  static String toCurrencyFormat(num value) {
    final fixed = math.pow(10, maxDecimalDigits);
    return amountFormat.format((value * fixed).floor() / fixed);
  }

  static double calculateVestToSteem(
    dynamic vesting_shares,
    dynamic total_vesting_shares,
    dynamic total_vesting_fund_steem,
  ) {
    final totalVestingShares =
        double.parse(toStr(total_vesting_shares).split(' ')[0]);
    final totalVestingFundSteem =
        double.parse(toStr(total_vesting_fund_steem).split(' ')[0]);
    final vestingShares = double.parse(toStr(vesting_shares).split(' ')[0]);
    final steem = vestingShares / totalVestingShares * totalVestingFundSteem;
    return steem;
  }

  static double calculateSteemToVest(
    dynamic amount,
    dynamic total_vesting_shares,
    dynamic total_vesting_fund_steem,
  ) {
    final totalVestingShares =
        double.parse(toStr(total_vesting_shares).split(' ')[0]);
    final totalVestingFundSteem =
        double.parse(toStr(total_vesting_fund_steem).split(' ')[0]);
    final steem = double.parse(toStr(amount).split(' ')[0]);
    final vestingShares = steem / totalVestingFundSteem * totalVestingShares;
    return vestingShares;
  }

  static int parseInteger(dynamic value) {
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

  static double parseDouble(dynamic value) {
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

  static String toStr(dynamic value) {
    return '$value';
  }

  static double truncateDecimal(Decimal input,
      {int digits = maxDecimalDigits}) {
    final fixed = math.pow(10, digits);
    return (input * Decimal.fromInt(fixed.toInt())).truncateToDouble() / fixed;
  }
}
