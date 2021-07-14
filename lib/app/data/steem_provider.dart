import 'package:flutter_steem_wallet_app/app/exceptions/http_exception.dart';
import 'package:flutter_steem_wallet_app/app/models/account_history.dart';
import 'package:flutter_steem_wallet_app/app/models/steem/steem_post.dart';
import 'package:get/get.dart';

import '../models/steem/steem_subscription.dart';

class SteemProvider extends GetConnect {
  static SteemProvider to = Get.find<SteemProvider>();

  int id = 0;
  Future _request(String method, dynamic params) async {
    print(method);
    print(params);
    final body = {
      'id': id++,
      'jsonrpc': '2.0',
      'method': method,
      'params': params
    };
    final response = await post('/', body);
    final url = response.request?.url.toString();
    switch (response.statusCode) {
      case 200:
        final responseJson = response.body['result'];
        return responseJson;
      case 400:
        throw BadRequestException(response.body, url);
      case 401:
      case 403:
        throw UnAuthorizedException(response.body, url);
      case 500:
      default:
        throw FetchDataException(
            'Error occured with code : ${response.statusCode}', url);
    }
  }

  Future getAccountHistory(String account) async {
    final response = await _request('call', [
      'database_api',
      'get_state',
      ['/@$account/transfers']
    ]);

    final data = response['accounts'][account];
    final transferHistory = data['transfer_history'];
    final otherHistory = data['other_history'];

    final props = response['props'];
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

  /// 구독중인 커뮤니티 조회하기
  Future<List<SteemSubscription>> getAllSubscriptions(String account) async {
    final response =
        await _request('bridge.list_all_subscriptions', {'account': account});
    return response
        .map<SteemSubscription>((item) => SteemSubscription.fromJson(item))
        .toList();
  }

  Future<List<SteemPost>> getMyFriendsFeeds(String account) async {
    final response = await _request('bridge.get_account_posts', {
      'sort': 'feed',
      'account': account,
      'observer': account,
    });
    return response.map<SteemPost>((item) => SteemPost.fromJson(item)).toList();
  }

  Future<List<SteemPost>> getCommunityFeeds(String tag, String account,
      [String sort = 'trending']) async {
    final List response = await _request('bridge.get_ranked_posts', {
      'sort': sort,
      'tag': tag,
      'observer': account,
    });
    return response.map<SteemPost>((item) => SteemPost.fromJson(item)).toList();
  }

  @override
  void onInit() {
    httpClient.baseUrl = 'https://api.steemit.com';
  }
}
