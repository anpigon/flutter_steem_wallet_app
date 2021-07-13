import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/modules/community/views/posts_view.dart';

import 'package:get/get.dart';

import '../controllers/community_controller.dart';

class CommunityView extends GetView {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommunityController());

    return controller.obx(
      (state) {
        if (state == null) {
          return Scaffold(
            appBar: AppBar(title: Text('Community')),
          );
        }
        return DefaultTabController(
          length: state.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Community'),
              bottom: TabBar(
                isScrollable: true,
                controller: controller.tabController,
                tabs: state.map((community) {
                  return Tab(text: community.title);
                }).toList(),
              ),
            ),
            body: TabBarView(
              controller: controller.tabController,
              children: state.map((community) {
                return PostsView(community);
              }).toList(),
            ),
          ),
        );
      },
      onError: (error) => Text(error.toString()),
    );
  }
}
