import 'package:flutter_steem_wallet_app/app/data/steem_provider.dart';
import 'package:flutter_steem_wallet_app/app/exceptions/message_exception.dart';
import 'package:flutter_steem_wallet_app/app/models/steem/steem_post.dart';
import 'package:flutter_steem_wallet_app/app/utils/ui_util.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  late final String tag;

  final loading = false.obs;
  final data = <SteemPost>[].obs;

  PostsController(this.tag);

  Future<void> loadPosts() async {
    loading(true);
    try {
      if (tag == 'feed') {
        final posts = await SteemProvider.to.getMyFriendsFeeds('anpigon');
        data.addAll(posts);
      } else {
        final posts = await SteemProvider.to.getCommunityFeeds(tag, 'anpigon');
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
