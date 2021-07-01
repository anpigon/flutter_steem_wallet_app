import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonWalletListItem extends StatelessWidget {
  const SkeletonWalletListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const decoration = BoxDecoration(color: Colors.grey);
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(26),
        child: Row(
          children: [
            SkeletonAnimation(
              child: Container(
                height: 36,
                width: 36,
                decoration: decoration,
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonAnimation(
                  child: Container(
                    height: 15,
                    width: 140,
                    decoration: decoration,
                  ),
                ),
                const SizedBox(height: 10),
                SkeletonAnimation(
                  child: Container(
                    height: 15,
                    width: 60,
                    decoration: decoration,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SkeletonAnimation(
                  child: Container(
                    height: 15,
                    width: 80,
                    decoration: decoration,
                  ),
                ),
                const SizedBox(height: 10),
                SkeletonAnimation(
                  child: Container(
                    height: 15,
                    width: 60,
                    decoration: decoration,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
