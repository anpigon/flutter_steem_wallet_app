import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/models/steem/steem_subscription.dart';
import 'package:flutter_steem_wallet_app/app/modules/community/controllers/posts_controller.dart';
import 'package:flutter_steem_wallet_app/app/modules/community/widget/post_list_item.dart';

import 'package:get/get.dart';

class PostsView extends GetView<PostsController> {
  late final SteemSubscription subscription;

  PostsView(this.subscription);

  @override
  Widget build(BuildContext context) {
    return GetX<PostsController>(
      tag: subscription.tag,
      init: PostsController(subscription.tag),
      builder: (controller) {
        if (controller.loading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.data.isEmpty) {
          return Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('아무것도 없다.'),
              ElevatedButton(
                onPressed: controller.loadPosts,
                child: Text('재시도'),
              ),
            ],
          ));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              if (subscription.tag != 'feed')
                buildTopArea(
                  controller.sort.value,
                  controller.sort,
                ),
              LayoutBuilder(
                builder: (ctx, constraint) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (_, index) {
                      return PostListItem(
                        post: controller.data[index],
                        maxWidth: constraint.maxWidth,
                      );
                    },
                    separatorBuilder: (_, __) => Divider(),
                    itemCount: controller.data.length,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Padding buildTopArea(String value, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DropdownButton(
            onChanged: onChanged,
            value: value,
            items: [
              DropdownMenuItem(
                value: 'trending',
                child: Text('community_trending'.tr),
              ),
              DropdownMenuItem(
                value: 'created',
                child: Text('community_new'.tr),
              ),
              DropdownMenuItem(
                value: 'payout',
                child: Text('community_payouts'.tr),
              ),
            ],
          )
        ],
      ),
    );
  }
}
