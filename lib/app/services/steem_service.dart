import 'dart:async';
import 'package:get/get.dart';
import 'package:steemdart_ecc/steemdart_ecc.dart' as steem;

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
}
