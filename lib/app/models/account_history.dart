import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/constants/operation_type.dart';
import 'package:flutter_steem_wallet_app/app/utils/num_utils.dart';

class AccountHistory extends Equatable {
  late final String opType;
  late final IconData icon;
  late final int id;
  late final String trxId;
  late final int block;
  late final int trxInBlock;
  late final int opInTrx;
  late final int virtualOp;
  late final DateTime timestamp;
  late final String? message;
  late final String? author;
  late final String? permlink;
  late final String? memo;
  late final bool? positive;

  AccountHistory({
    required this.opType,
    required this.icon,
    required this.id,
    required this.trxId,
    required this.block,
    required this.trxInBlock,
    required this.opInTrx,
    required this.virtualOp,
    required this.timestamp,
    this.message,
    this.author,
    this.permlink,
    this.memo,
    this.positive,
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
    final opType = operation[0];
    final opData = operation[1];

    final trxId = tx['trx_id'] as String;
    final block = tx['block'] as int;
    final trxInBlock = tx['trx_in_block'] as int;
    final opInTrx = tx['op_in_trx'] as int;
    final virtualOp = tx['virtual_op'] as int;
    final timestamp = DateTime.parse('${tx['timestamp'] as String}Z');

    switch (opType) {
      case OperationType.CURATION_REWARD:
        // final curator = payload['curator'] as String;
        final reward = opData['reward'] as String;
        final commentAuthor = opData['comment_author'] as String;
        final commentPermlink = opData['comment_permlink'] as String;
        final spPayout = calculateVestToSteem(
            reward, totalVestingShares, totalVestingFundSteem);
        return AccountHistory(
          icon: Icons.favorite,
          opType: opType,
          id: id,
          trxId: trxId,
          block: block,
          trxInBlock: trxInBlock,
          opInTrx: opInTrx,
          virtualOp: virtualOp,
          timestamp: timestamp,
          author: commentAuthor,
          permlink: commentPermlink,
          message: 'Curation rewards: ${toFixedTrunc(spPayout, 3)} SP',
        );
      case OperationType.AUTHOR_REWARD:
      case OperationType.COMMENT_BENEFACTOR_REWARD:
        final author = opData['author'] as String;
        final permlink = opData['permlink'] as String;
        final sbdPayout = opData['sbd_payout'] as String;
        final steemPayout = opData['steem_payout'] as String;
        final vestingPayout = opData['vesting_payout'] as String;
        final spPayout = calculateVestToSteem(
            vestingPayout, totalVestingShares, totalVestingFundSteem);
        return AccountHistory(
          icon: Icons.face,
          opType: opType,
          id: id,
          trxId: trxId,
          block: block,
          trxInBlock: trxInBlock,
          opInTrx: opInTrx,
          virtualOp: virtualOp,
          timestamp: timestamp,
          author: author,
          permlink: permlink,
          message: [
            'Author reward:',
            if (sbdPayout != '0.000 SBD') '$sbdPayout and',
            if (sbdPayout != '0.000 STEEM') '$steemPayout and',
            if (spPayout > 0) '${toFixedTrunc(spPayout, 3)} SP',
          ].join(' '),
        );
      case OperationType.CLAIM_REWARD_BALANCE:
        // final account = payload['account'] as String;
        final rewardSteem = opData['reward_steem'] as String;
        final rewardSbd = opData['reward_sbd'] as String;
        final rewardVests = opData['reward_vests'] as String;
        final rewardSP = calculateVestToSteem(
            rewardVests, totalVestingShares, totalVestingFundSteem);
        return AccountHistory(
          icon: Icons.payment,
          opType: opType,
          id: id,
          trxId: trxId,
          block: block,
          trxInBlock: trxInBlock,
          opInTrx: opInTrx,
          virtualOp: virtualOp,
          timestamp: timestamp,
          message: [
            'Claim rewards:',
            if (rewardSbd != '0.000 SBD') '$rewardSbd and',
            if (rewardSteem != '0.000 STEEM') '$rewardSteem and',
            if (rewardSP > 0) '${toFixedTrunc(rewardSP, 3)} SP',
          ].join(' '),
        );
      case OperationType.TRANSFER:
      case OperationType.TRANSFER_TO_SAVINGS:
      case OperationType.TRANSFER_FROM_SAVINGS:
      case OperationType.TRANSFER_TO_VESTING:
        final amount = opData['amount'] as String;
        final from = opData['from'] as String;
        final to = opData['to'] as String;
        final memo = opData['memo'] as String?;
        String message;
        IconData icon;
        bool positive;
        if (ownerAccount == from && ownerAccount == to && memo == null) {
          // STEEM POWER UP
          icon = Icons.bolt;
          message = 'Transfer $amount POWER to $to';
          positive = true;
        } else if (ownerAccount == from) {
          icon = Icons.arrow_circle_up;
          message = 'Transfer $amount to $to';
          positive = true;
        } else {
          icon = Icons.arrow_circle_down;
          message = 'Received $amount from $from';
          positive = false;
        }
        return AccountHistory(
          icon: icon,
          opType: opType,
          id: id,
          trxId: trxId,
          block: block,
          trxInBlock: trxInBlock,
          opInTrx: opInTrx,
          virtualOp: virtualOp,
          timestamp: timestamp,
          message: message,
          memo: memo,
          positive: positive,
        );
      case OperationType.WITHDRAW_VESTING:
        // STEEM POWER DOWN
        final vestingShares = opData['vesting_shares'] as String;
        final amount = toFixedTrunc(
            calculateVestToSteem(
                vestingShares, totalVestingShares, totalVestingFundSteem),
            3);
        return AccountHistory(
          icon: Icons.bolt,
          opType: opType,
          id: id,
          trxId: trxId,
          block: block,
          trxInBlock: trxInBlock,
          opInTrx: opInTrx,
          virtualOp: virtualOp,
          timestamp: timestamp,
          message: 'Start power down of $amount STEEM',
          positive: false,
        );
      case OperationType.DELEGATE_VESTING_SHARES:
        final delegator = opData['delegator'] as String;
        final delegatee = opData['delegatee'] as String;
        final vesting_shares = opData['vesting_shares'] as String;
        final delegateSP = calculateVestToSteem(
            vesting_shares, totalVestingShares, totalVestingFundSteem);
        String message;
        if (ownerAccount == delegator) {
          message = 'Delegate ${toFixedTrunc(delegateSP, 3)} SP to $delegatee';
        } else {
          message =
              'Delegate ${toFixedTrunc(delegateSP, 3)} SP from $delegator';
        }
        return AccountHistory(
          icon: Icons.swap_horiz,
          opType: opType,
          id: id,
          trxId: trxId,
          block: block,
          trxInBlock: trxInBlock,
          opInTrx: opInTrx,
          virtualOp: virtualOp,
          timestamp: timestamp,
          message: message,
        );
      /* case 'custom_json':
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
            return AccountHistory(
                opType: opType,
                id: id,
                trxId: trxId,
                block: block,
                trxInBlock: trxInBlock,
                opInTrx: opInTrx,
                virtualOp: virtualOp,
                timestamp: timestamp,
                message: 'Scot Claim Token: $symbols',
              );
          case 'ssc-mainnet1':
            final contractName = customJson['contractName'];
            final contractAction = customJson['contractAction'];
            if (contractName == 'tokens' && contractAction == 'transfer') {
              final contractPayload = customJson['contractPayload'];
              final symbol = contractPayload['symbol'];
              final to = contractPayload['to'];
              final quantity = contractPayload['quantity'];
              return AccountHistory(
                opType: opType,
                id: id,
                trxId: trxId,
                block: block,
                trxInBlock: trxInBlock,
                opInTrx: opInTrx,
                virtualOp: virtualOp,
                timestamp: timestamp,
                message: Transfer $quantity  $symbol to $to',
                memo: contractPayload['memo'];
              );
            }
            break;
          default:
            break;
        }
        break; */
      default:
        print(tx);
    }
    return AccountHistory(
      icon: Icons.message,
      opType: opType,
      id: id,
      trxId: trxId,
      block: block,
      trxInBlock: trxInBlock,
      opInTrx: opInTrx,
      virtualOp: virtualOp,
      timestamp: timestamp,
    );
  }

  @override
  List<Object?> get props =>
      [id, trxId, block, trxInBlock, opInTrx, virtualOp, timestamp];
}
