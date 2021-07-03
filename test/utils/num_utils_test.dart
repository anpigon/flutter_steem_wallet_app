import 'package:flutter_steem_wallet_app/app/utils/num_util.dart';
import 'package:test/test.dart';

void main() {
  group('num utils', () {
    test('calculateVestToSteem', () {
      final vesting_shares = '1767119675.264989 VESTS';
      final total_vesting_shares = '236786162275.582778 VESTS';
      final total_vesting_fund_steem = '126585310.787 STEEM';
      final actual = NumUtil.calculateVestToSteem(
        vesting_shares,
        total_vesting_shares,
        total_vesting_fund_steem,
      );
      expect(actual, 944697.9128404416);
    });

    test('calculateSteemToVest', () {
      final amount = '944697.9128404416 STEEM';
      final total_vesting_shares = '236786162275.582778 VESTS';
      final total_vesting_fund_steem = '126585310.787 STEEM';
      final actual = NumUtil.calculateSteemToVest(
        amount,
        total_vesting_shares,
        total_vesting_fund_steem,
      );
      expect(actual, 1767119675.264989);
    });

    test('toFixedTrunc', () {
      final amount = 944697.9128404416;
      final actual1 = NumUtil.toFixedTrunc(amount, 3);
      expect(actual1, '944697.912');
      final actual2 = NumUtil.toFixedTrunc(amount, 6);
      expect(actual2, '944697.912840');
    });

    test('toCurrencyFormat', () {
      final amount = 1944697.9128404416;
      final actual = NumUtil.toCurrencyFormat(amount);
      expect(actual, '1,944,697.912');
    });

    test('parseInteger', () {
      final amount = '944697';
      final actual = NumUtil.parseInteger(amount);
      expect(actual, 944697);
    });

    test('parseDouble', () {
      final amount = '944697.9128404416';
      final actual = NumUtil.parseDouble(amount);
      expect(actual, 944697.9128404416);
    });
  });
}
