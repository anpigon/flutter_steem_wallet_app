import 'package:flutter_steem_wallet_app/app/models/account_history.dart';
import 'package:get/get.dart';

class SteemProvider extends GetConnect {
  static SteemProvider to = Get.find<SteemProvider>();

  Future getAccountHistory(String account) async {
    final body = {
      'jsonrpc': '2.0',
      'method': 'call',
      'params': [
        'database_api',
        'get_state',
        ['/@$account/transfers']
      ]
    };
    final response = await post('/', body);

    if (response.statusCode == 200) {
      final result = response.body['result'];
      final data = result['accounts'][account];
      final transferHistory = data['transfer_history'];
      final otherHistory = data['other_history'];

      // { "base": "0.323 SBD",  "quote": "1.000 STEEM" }
      // final feed = result['feed_price'];
      final props = result['props'];
      final totalVestingFundSteem = props['total_vesting_fund_steem'] as String;
      final totalVestingShares = props['total_vesting_shares'] as String;

      final List<AccountHistory> accountHistory = transferHistory
          .map<AccountHistory>((item) => AccountHistory.fromJson(
                item,
                ownerAccount: account,
                totalVestingFundSteem: totalVestingFundSteem,
                totalVestingShares: totalVestingShares,
              ))
          .toList();

      accountHistory.addAll(otherHistory
          .map<AccountHistory>((item) => AccountHistory.fromJson(
                item,
                ownerAccount: account,
                totalVestingFundSteem: totalVestingFundSteem,
                totalVestingShares: totalVestingShares,
              ))
          .toList());

      accountHistory.sort((a, b) {
        var adate = a.timestamp;
        var bdate = b.timestamp;
        return -adate.compareTo(bdate);
      });

      return accountHistory
          .where(
            (e) => e.message?.isNotEmpty ?? false,
          )
          .toList();
    }
    return [];
  }

  @override
  void onInit() {
    httpClient.baseUrl = 'https://api.steemit.com';
  }
}
