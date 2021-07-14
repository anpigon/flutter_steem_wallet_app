import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_text/skeleton_text.dart';

import 'package:flutter_steem_wallet_app/app/models/steem/steem_post.dart';
import 'package:flutter_steem_wallet_app/app/utils/date_util.dart';

class PostListItem extends StatelessWidget {
  final SteemPost post;
  final double maxWidth;

  const PostListItem({
    Key? key,
    required this.post,
    required this.maxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final jsonMetadata = post.jsonMetadata;
    final image =
        jsonMetadata?.image.isNotEmpty == true ? jsonMetadata?.image[0] : null;
    return Container(
      padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 8),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    'https://steemitimages.com/640x480/$image',
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SkeletonAnimation(
                        child: const GrayBox(),
                      );
                    },
                    errorBuilder: (_, __, ___) {
                      return const GrayBox();
                    },
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Container(
                width: maxWidth - (image != null ? 172 : 40),
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
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                foregroundImage: NetworkImage(
                  'https://steemitimages.com/u/${post.author}/avatar/small',
                ),
              ),
              const SizedBox(width: 6),
              Text(post.author),
              const Text(' ∙ ', style: TextStyle(color: Colors.grey)),
              Text(DateUtil.displayedAt(post.created),
                  style: TextStyle(color: Colors.grey.shade800)),
              const Spacer(),
              Text(
                '\$${post.pendingPayoutValue.split(' ')[0]}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(width: 4),
              const Text(' ∙ ', style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 4),
              GestureDetector(
                child: Icon(
                  Icons.thumb_up_alt_outlined,
                  size: 16,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${post.activeVotes.length}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: 16,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(width: 4),
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
  }
}

class GrayBox extends StatelessWidget {
  const GrayBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 80,
      color: Colors.grey.shade200,
    );
  }
}
