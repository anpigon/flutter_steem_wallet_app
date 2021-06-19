import 'package:flutter_steem_wallet_app/app/models/signature/signature_model.dart';

class WithdrawVesting extends SignatureModel {
  late final String account;
  late final double vesting_shares;

  WithdrawVesting({
    required this.account,
    required this.vesting_shares,
  }) : assert(vesting_shares.isFinite);

  @override
  Map<String, dynamic> toJson() => {
        'account': account,
        'vesting_shares':
            '${((vesting_shares * 1000000).floor() / 1000000).toStringAsFixed(6)} VESTS',
      };
}
