import 'package:flutter_steem_wallet_app/app/models/signature/signature_model.dart';
import 'package:flutter_steem_wallet_app/app/utils/num_util.dart';

/// ref: https://developers.steem.io/apidefinitions/broadcast-ops#broadcast_ops_transfer_to_vesting
class DelegateVestingShares extends SignatureModel {
  late final String delegator;
  late final String delegatee;
  late final double vesting_shares;

  DelegateVestingShares({
    required this.delegator,
    required this.delegatee,
    required this.vesting_shares,
  }) : assert(vesting_shares.isFinite);

  @override
  Map<String, dynamic> toJson() => {
        'delegator': delegator,
        'delegatee': delegatee,
        'vesting_shares':
            '${NumUtil.toFixedTrunc(vesting_shares, 6)} VESTS',
      };
}
