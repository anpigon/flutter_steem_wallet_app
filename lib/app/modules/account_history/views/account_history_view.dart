import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'dart:math' as math;

import 'package:flutter_steem_wallet_app/app/models/account_history.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/account_history_controller.dart';

class AccountHistoryView extends GetView<AccountHistoryController> {
  final dateFormat = DateFormat('yyyy-MM-dd hh:mm');

  @override
  Widget build(BuildContext context) {
    Get.put((AccountHistoryController()));
    return Scaffold(
      appBar: AppBar(
        title: Text('Account History'),
        centerTitle: true,
      ),
      body: Container(
        child: controller.obx(
          (state) => ListView.separated(
            separatorBuilder: (_, __) => Divider(),
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(10),
            itemCount: state!.length,
            itemBuilder: (ctx, index) => buildListItem(state[index]),
          ),
          onLoading: buildLoading(),
          onEmpty: Text('No data found'),
          onError: (error) => Center(child: Text(error!)),
        ),
      ),
    );
  }

  Widget buildLoading() {
    final boxDecoration = BoxDecoration(color: Colors.grey.shade300);
    return ListView.separated(
      itemCount: 20,
      padding: EdgeInsets.all(10),
      separatorBuilder: (_, __) => Divider(),
      itemBuilder: (_, __) => Container(
        child: Row(
          children: [
            SkeletonAnimation(
              child: Container(
                width: 24,
                height: 24,
                decoration: boxDecoration,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonAnimation(
                    child: Container(
                      width: double.infinity,
                      height: 18,
                      decoration: boxDecoration,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SkeletonAnimation(
                    child: Container(
                      width: 150,
                      height: 11,
                      decoration: boxDecoration,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIcon(IconData iconData, [bool? positive]) {
    Widget icon;
    if (iconData == Icons.arrow_circle_up) {
      icon = Transform.rotate(
        angle: math.pi / 4,
        child: Icon(
          iconData,
          color: Colors.red,
        ),
      );
    } else if (iconData == Icons.arrow_circle_down) {
      icon = Transform.rotate(
        angle: math.pi / 4,
        child: Icon(
          iconData,
          color: Colors.blue,
        ),
      );
    } else if (iconData == Icons.bolt) {
      icon = Icon(
        iconData,
        color: positive == true ? Colors.yellow.shade800 : Colors.red,
      );
    } else {
      icon = Icon(iconData, color: Colors.blue);
    }
    return icon;
  }

  Widget buildListItem(AccountHistory item) {
    final icon = buildIcon(item.icon, item.positive);
    return Row(
      children: [
        icon,
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.message!,
                softWrap: true,
              ),
              const SizedBox(height: 5),
              if (item.memo?.isNotEmpty ?? false) ...[
                Text(
                  item.memo!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 5),
              ],
              Text(
                dateFormat.format(item.timestamp),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
