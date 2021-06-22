import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_steem_wallet_app/app/utils/num_utils.dart';

class AccountHistory extends Equatable {
  late final int id;
  late final String trxId;
  late final int block;
  late final int trxInBlock;
  late final int opInTrx;
  late final int virtualOp;
  late final DateTime timestamp;
  late String? message;
  late String? author;
  late String? permlink;
  late String? memo;

  AccountHistory({
    required this.id,
    required this.trxId,
    required this.block,
    required this.trxInBlock,
    required this.opInTrx,
    required this.virtualOp,
    required this.timestamp,
    this.message,
  });

  factory AccountHistory.fromJson(
    List<dynamic> item, {
    required String ownerAccount,
    String totalVestingFundSteem = '0.000 STEEM',
    String totalVestingShares = '0.000000 VESTS',
  }) {
    final id = item[0] as int;
    final tx = item[1] as Map<String, dynamic>;

    final operation = item[1]['op'];
    final action = operation[0];
    final payload = operation[1];

    final accountHistory = AccountHistory(
      id: id,
      trxId: tx['trx_id'] as String,
      block: tx['block'] as int,
      trxInBlock: tx['trx_in_block'] as int,
      opInTrx: tx['op_in_trx'] as int,
      virtualOp: tx['virtual_op'] as int,
      timestamp: DateTime.parse('${tx['timestamp'] as String}Z'),
    );

    switch (action) {
      case 'curation_reward':
        // final curator = payload['curator'] as String;
        final reward = payload['reward'] as String;
        final commentAuthor = payload['comment_author'] as String;
        final commentPermlink = payload['comment_permlink'] as String;
        final spPayout = calculateVestToSteem(
            reward, totalVestingShares, totalVestingFundSteem);
        accountHistory.author = commentAuthor;
        accountHistory.permlink = commentPermlink;
        accountHistory.message =
            'Curation rewards: ${toFixedTrunc(spPayout, 3)} SP';
        break;
      case 'author_reward':
      case 'comment_benefactor_reward':
        final author = payload['author'] as String;
        final permlink = payload['permlink'] as String;
        final sbdPayout = payload['sbd_payout'] as String;
        final steemPayout = payload['steem_payout'] as String;
        final vestingPayout = payload['vesting_payout'] as String;
        final spPayout = calculateVestToSteem(
            vestingPayout, totalVestingShares, totalVestingFundSteem);
        accountHistory.author = author;
        accountHistory.permlink = permlink;
        accountHistory.message = [
          'Author reward:',
          if (sbdPayout != '0.000 SBD') '$sbdPayout and',
          if (sbdPayout != '0.000 STEEM') '$steemPayout and',
          if (spPayout > 0) '${toFixedTrunc(spPayout, 3)} SP',
        ].join(' ');
        break;
      case 'claim_reward_balance':
        // final account = payload['account'] as String;
        final rewardSteem = payload['reward_steem'] as String;
        final rewardSbd = payload['reward_sbd'] as String;
        final rewardVests = payload['reward_vests'] as String;
        final rewardSP = calculateVestToSteem(
            rewardVests, totalVestingShares, totalVestingFundSteem);
        accountHistory.message = [
          'Claim rewards:',
          if (rewardSbd != '0.000 SBD') '$rewardSbd and',
          if (rewardSteem != '0.000 STEEM') '$rewardSteem and',
          if (rewardSP > 0) '${toFixedTrunc(rewardSP, 3)} SP',
        ].join(' ');
        break;
      case 'transfer':
      case 'transfer_to_savings':
      case 'transfer_from_savings':
      case 'transfer_to_vesting':
        final _amount = payload['amount'] as String;
        final _from = payload['from'] as String;
        final _to = payload['to'] as String;
        final _memo = payload['memo'] as String?;
        accountHistory.memo = _memo;
        if (ownerAccount == _from) {
          accountHistory.message = 'Transfer $_amount to $_to';
        } else if (ownerAccount == _from && ownerAccount == _to) {
          // STEEM POWER UP
          accountHistory.message = '	Transfer $_amount POWER to $_to';
        } else {
          accountHistory.message = 'Received $_amount from $_from';
        }
        break;
      case 'delegate_vesting_shares':
        final delegator = payload['delegator'] as String;
        final delegatee = payload['delegatee'] as String;
        final vesting_shares = payload['vesting_shares'] as String;
        final delegateSP = calculateVestToSteem(
            vesting_shares, totalVestingShares, totalVestingFundSteem);
        if (ownerAccount == delegator) {
          accountHistory.message =
              'Delegate ${toFixedTrunc(delegateSP, 3)} SP to $delegatee';
        } else {
          accountHistory.message =
              'Delegate ${toFixedTrunc(delegateSP, 3)} SP from $delegator';
        }
        break;
      case 'custom_json':
        final customJsonId = payload['id'] as String;
        final customJson = jsonDecode(payload['json'] as String);
        switch (customJsonId) {
          case 'scot_claim_token':
            if (customJson is List) {
              final symbols =
                  customJson.map((item) => item['symbol']).join(', ');
              accountHistory.message = 'Scot Claim Tokens: $symbols}';
            } else {
              final symbols =
                  customJson is Map ? customJson['symbol'] : customJson;
              accountHistory.message = 'Scot Claim Token: $symbols';
            }

            break;
          case 'ssc-mainnet1':
            final contractName = customJson['contractName'];
            final contractAction = customJson['contractAction'];
            if (contractName == 'tokens' && contractAction == 'transfer') {
              final contractPayload = customJson['contractPayload'];
              final symbol = contractPayload['symbol'];
              final to = contractPayload['to'];
              final quantity = contractPayload['quantity'];
              accountHistory.memo = contractPayload['memo'];
              accountHistory.message = 'Transfer $quantity  $symbol to $to';
            }
            break;
          default:
        }

        break;
    }

    return accountHistory;
  }

  @override
  List<Object?> get props =>
      [id, trxId, block, trxInBlock, opInTrx, virtualOp, timestamp];
}
