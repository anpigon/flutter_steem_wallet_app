import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/models/steem/steem_subscription.dart';
import 'package:flutter_steem_wallet_app/app/modules/community/controllers/posts_controller.dart';

import 'package:get/get.dart';
import 'package:skeleton_text/skeleton_text.dart';

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
                    onPressed: controller.loadPosts, child: Text('재시도')),
              ],
            ));
          }

          return LayoutBuilder(builder: (ctx, constraint) {
            return ListView.separated(
              itemBuilder: (_, index) {
                final post = controller.data[index];
                final jsonMetadata = post.jsonMetadata;
                final existMainImage = jsonMetadata?.image.isNotEmpty ?? false;
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (post.communityTitle != null) ...[
                        Text(
                          post.communityTitle!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Get.theme.accentColor,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (existMainImage) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                jsonMetadata!.image[0],
                                width: 120,
                                height: 80,
                                fit: BoxFit.cover,
                                loadingBuilder: (_, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return SkeletonAnimation(
                                    child: Container(
                                      width: 120,
                                      height: 80,
                                      color: Colors.grey.shade200,
                                    ),
                                  );
                                },
                                errorBuilder: (_, __, ___) {
                                  return Container(
                                    width: 120,
                                    height: 80,
                                    color: Colors.grey.shade200,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 12),
                          ],
                          Container(
                            width: constraint.maxWidth -
                                (existMainImage ? (120 + 12) : 0) -
                                40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  post.body,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            foregroundImage: NetworkImage(
                              'https://steemitimages.com/u/${post.author}/avatar/small',
                              // fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(post.author),
                          Text(' ∙ ', style: TextStyle(color: Colors.grey)),
                          Text(post.created,
                              style: TextStyle(color: Colors.grey.shade800)),
                          Spacer(),
                          Text(
                            '\$${post.pendingPayoutValue.split(' ')[0]}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade900,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(' ∙ ', style: TextStyle(color: Colors.grey)),
                          SizedBox(width: 4),
                          GestureDetector(
                            child: Icon(
                              Icons.thumb_up_alt_outlined,
                              size: 16,
                              color: Colors.grey.shade900,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${post.activeVotes.length}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade900,
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            child: Icon(
                              Icons.chat_bubble_outline,
                              size: 16,
                              color: Colors.grey.shade900,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${post.children}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade900,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
                //       return ListTile(
                //           title: Text(post.title!),
                //           subtitle: Text(
                //             post.content!,
                //             maxLines: 2,
                //             overflow: TextOverflow.ellipsis,
                //           ),
                //           onTap: () {
                //             Get.toNamed(Routes.POST, arguments: post.id);
                //           });
              },
              separatorBuilder: (_, __) => Divider(),
              itemCount: controller.data.length,
            );
          });
        });
  }
}
