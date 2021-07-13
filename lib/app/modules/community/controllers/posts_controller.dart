import 'package:flutter_steem_wallet_app/app/data/steem_provider.dart';
import 'package:flutter_steem_wallet_app/app/exceptions/message_exception.dart';
import 'package:flutter_steem_wallet_app/app/models/steem/steem_post.dart';
import 'package:flutter_steem_wallet_app/app/models/steem/steem_subscription.dart';
import 'package:flutter_steem_wallet_app/app/utils/ui_util.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  late final SteemSubscription subscription;

  final loading = false.obs;
  final data = <SteemPost>[].obs;

  PostsController(this.subscription);

  Future<void> loadPosts() async {
    loading(true);
    try {
      if (subscription.tag == 'feed') {
        final posts = await SteemProvider.to.getMyFriendsFeeds('anpigon');
        data.addAll(posts);
      } else {
        final posts = await SteemProvider.to
            .getCommunityFeeds(subscription.tag, 'anpigon');
        data.addAll(posts);
      }
    } on MessageException catch (ex) {
      UIUtil.showErrorMessage(ex.message);
    } finally {
      loading(false);
    }
  }

  @override
  void onInit() {
    loadPosts();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
