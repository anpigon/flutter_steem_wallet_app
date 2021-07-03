import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonWalletListItem extends StatelessWidget {
  const SkeletonWalletListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const decoration = BoxDecoration(color: Colors.grey);
    return Column(
      children: [
        Card(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 26,
              right: 26,
              bottom: 26,
              left: 23,
            ),
            child: Row(
              children: [
                SkeletonAnimation(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
                SizedBox(width: 18),
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
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
