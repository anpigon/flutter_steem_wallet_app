/// ref: https://developers.steem.io/apidefinitions/broadcast-ops#broadcast_ops_transfer_to_vesting
class TransferToVesting {
  late final String from;
  late final String to;
  late final double amount;

  TransferToVesting({
    required this.from,
    required this.to,
    required this.amount,
  })  : assert(amount.isFinite),
        assert(amount * 1000 is int);

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'amount': '${amount.toStringAsFixed(3)} STEEM',
      };
}
