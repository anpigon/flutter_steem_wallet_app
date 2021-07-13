import 'dart:async';

import 'package:flutter_steem_wallet_app/app/models/signature/delegate_vesting_shares.dart';
import 'package:flutter_steem_wallet_app/app/models/signature/withdraw_vesting.dart';
import 'package:flutter_steem_wallet_app/app/models/wallet.dart';
import 'package:flutter_steem_wallet_app/app/utils/num_util.dart';
import 'package:get/get.dart';
import 'package:steemdart_ecc/steemdart_ecc.dart' as steem;

import '../models/signature/transfer.dart';
import '../models/signature/transfer_to_vesting.dart';

const STEEM_API_NODES = [
  'https://api.steemit.com',
  'https://steem.ecosynthesizer.com',
  'https://steem.61bts.com',
  'https://e51ewpb9dk.execute-api.us-east-1.amazonaws.com/release',
  'https://api.steemzzang.com',
  'https://justyy.azurewebsites.net/api/steem',
  'https://api.justyy.com',
  'https://cn.steems.top',
  'https://api.steemyy.com',
  'https://steem.justyy.workers.dev',
  'https://x68bp3mesd.execute-api.ap-northeast-1.amazonaws.com/release',
  'https://api.steem.fans',
  'https://api.steem.buzz',
  'https://api.steemitdev.com'
]; // ref: https://steemyy.com/node-status.php

class SteemService extends GetxService {
  late final steem.Client client;

  static SteemService get to => Get.find<SteemService>();

  Future<SteemService> init() async {
    client = steem.Client(STEEM_API_NODES[0]);
    return this;
  }

  void changeServer(String url) {
    client = steem.Client(url);
  }

  Future<steem.Account?> getAccount(String username) async {
    final accounts = await client.database.getAccounts([username]);
    if (accounts.isNotEmpty) {
      final account = accounts[0];
      return account;
    }
    return null;
  }

  Future<steem.Manabar> getRCMana(String username) async {
    return await client.rc.getRCMana(username);
  }

  Future<steem.Manabar> getVPMana(String username) async {
    return await client.rc.getVPMana(username);
  }

  steem.Manabar calculateVPMana(steem.Account account) {
    return client.rc.calculateVPMana(account);
  }

  Future<steem.DynamicGlobalProperties> getDynamicGlobalProperties() async {
    return await client.database.getDynamicGlobalProperties();
  }

  Future<double> calculateSteemToVest(dynamic amount) async {
    final props = await SteemService.to.getDynamicGlobalProperties();
    return NumUtil.calculateSteemToVest(amount, props.total_vesting_shares, props.total_vesting_fund_steem);
  }

  Future<Map<String, dynamic>> transfer(Transfer data, String key) async {
    return await client.broadcast
        .transfer(data.toJson(), steem.SteemPrivateKey.fromString(key));
  }

  Future<Map<String, dynamic>> powerUp(
    TransferToVesting transferToVesting,
    String key,
  ) async {
    final operation = steem.Operation(
      'transfer_to_vesting',
      transferToVesting.toJson(),
    );
    return await client.broadcast
        .sendOperations([operation], steem.SteemPrivateKey.fromString(key));
  }

  Future<Map<String, dynamic>> powerDown(
    WithdrawVesting withdrawVesting,
    String key,
  ) async {
    final operation = steem.Operation(
      'withdraw_vesting',
      withdrawVesting.toJson(),
    );
    return await client.broadcast
        .sendOperations([operation], steem.SteemPrivateKey.fromString(key));
  }

  Future<Map<String, dynamic>> delegate(
    DelegateVestingShares delegateVestingShares,
    String key,
  ) async {
    final operation = steem.Operation(
      'delegate_vesting_shares',
      delegateVestingShares.toJson(),
    );
    return await client.broadcast
        .sendOperations([operation], steem.SteemPrivateKey.fromString(key));
  }

  Future<Wallet?> loadAccountDetails(String username) async {
    final globalProperties = await getDynamicGlobalProperties();
    final data = await getAccount(username);
    if (data != null) {
      // steem power 계산
      final steemPower = NumUtil.calculateVestToSteem(
        data.vesting_shares,
        globalProperties.total_vesting_shares,
        globalProperties.total_vesting_fund_steem,
      );

      // 보팅 파워 계산
      final currentVotingPower = calculateVPMana(data).percentage;

      // RC 계산
      final currentResourceCredits = (await getRCMana(username)).percentage;

      // reward_sbd_balance, // 0.587 SBD
      // reward_steem_balance, // 0.000 STEEM
      // reward_vesting_balance, // 4784.672240 VESTS
      // reward_vesting_steem, // 2.560 STEEM

      return Wallet(
        name: data.name,
        steemBalance: double.parse(data.balance.split(' ')[0]),
        sbdBalance: double.parse(data.sbd_balance.split(' ')[0]),
        steemPower: steemPower,
        votingPower: currentVotingPower / 100,
        resourceCredits: currentResourceCredits / 100,
        toWithdraw: NumUtil.calculateVestToSteem(
              data.to_withdraw,
              globalProperties.total_vesting_shares,
              globalProperties.total_vesting_fund_steem,
            ) /
            1e6,
        withdrawn: NumUtil.calculateVestToSteem(
              data.withdrawn,
              globalProperties.total_vesting_shares,
              globalProperties.total_vesting_fund_steem,
            ) /
            1e6,
        delegatedSteemPower: NumUtil.calculateVestToSteem(
          data.delegated_vesting_shares,
          globalProperties.total_vesting_shares,
          globalProperties.total_vesting_fund_steem,
        ),
        receivedSteemPower: NumUtil.calculateVestToSteem(
          data.received_vesting_shares,
          globalProperties.total_vesting_shares,
          globalProperties.total_vesting_fund_steem,
        ),
        nextSteemPowerWithdrawRate: NumUtil.calculateVestToSteem(
          data.vesting_withdraw_rate,
          globalProperties.total_vesting_shares,
          globalProperties.total_vesting_fund_steem,
        ),
        nextSteemPowerWithdrawal:
            DateTime.parse('${data.next_vesting_withdrawal}Z'),
        rewardSbdBalance: data.reward_sbd_balance,
        rewardSteemBalance: data.reward_steem_balance,
        rewardVestingBalance: data.reward_vesting_balance,
        rewardVestingSteem: data.reward_vesting_steem,
      );
    }

    return null;
  }
}
