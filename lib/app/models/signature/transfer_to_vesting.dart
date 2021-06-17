import 'package:flutter_steem_wallet_app/app/models/signature/signature_model.dart';

/// ref: https://developers.steem.io/apidefinitions/broadcast-ops#broadcast_ops_transfer_to_vesting
class TransferToVesting extends SignatureModel {
  late final String from;
  late final String to;
  late final double amount;

  TransferToVesting({
    required this.from,
    required this.to,
    required this.amount,
  }) : assert(amount.isFinite);

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'amount':
            '${((amount * 1000).floor() / 1000).toStringAsFixed(3)} STEEM',
      };
}
