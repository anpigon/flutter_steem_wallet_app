import 'package:get/get.dart';
import 'package:loadmore/loadmore.dart';

import 'package:flutter_steem_wallet_app/app/data/steem_provider.dart';
import 'package:flutter_steem_wallet_app/app/exceptions/message_exception.dart';
import 'package:flutter_steem_wallet_app/app/models/steem/steem_post.dart';
import 'package:flutter_steem_wallet_app/app/utils/ui_util.dart';

class PostsController extends GetxController {
  static PostsController get to => Get.find<PostsController>();

  late final String tag;
  final sort = 'trending'.obs;

  final loading = false.obs;
  final data = <SteemPost>[].obs;

  PostsController(this.tag);

  Future<void> loadPosts([bool isLoadMore = false]) async {
    loading(true);
    try {
      if (!isLoadMore) data.clear();

      if (tag == 'feed') {
        final posts = await SteemProvider.to.getMyFriendsFeeds('anpigon');
        data.addAll(posts);
      } else {
        final posts = await SteemProvider.to
            .getCommunityFeeds(tag, 'anpigon', sort.value);
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

    ever(sort, (_) {
      loadPosts();
    });

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
