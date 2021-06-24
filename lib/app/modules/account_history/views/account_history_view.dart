import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/account_history_controller.dart';

class AccountHistoryView extends GetView<AccountHistoryController> {
  @override
  Widget build(BuildContext context) {
    Get.put((AccountHistoryController()));
    return Scaffold(
      appBar: AppBar(
        title: Text('AccountHistoryView'),
        centerTitle: true,
      ),
      body: Container(
        child: controller.obx(
          (state) {
            final dateFormat = DateFormat('yyyy-MM-dd hh:mm');
            return ListView.separated(
              separatorBuilder: (_, __) => Divider(),
              padding: EdgeInsets.all(10),
              itemCount: state!.length,
              itemBuilder: (ctx, index) {
                final item = state[index];
                Widget icon;
                if (item.icon == Icons.arrow_circle_up) {
                  icon = Transform.rotate(
                    angle: math.pi / 4,
                    child: Icon(
                      item.icon,
                      color: Colors.red,
                    ),
                  );
                } else if (item.icon == Icons.arrow_circle_down) {
                  icon = Transform.rotate(
                    angle: math.pi / 4,
                    child: Icon(
                      item.icon,
                      color: Colors.blue,
                    ),
                  );
                } else if (item.icon == Icons.bolt) {
                  icon = Icon(
                    item.icon,
                    color: Colors.yellow,
                  );
                } else {
                  icon = Icon(item.icon, color: Colors.blue);
                }
                return Row(
                  children: [
                    icon,
                    SizedBox(width: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Get.width - 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.message!,
                                softWrap: true,
                              ),
                              SizedBox(height: 5),
                              if (item.memo?.isNotEmpty ?? false) ...[
                                Text(
                                  item.memo!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                              Text(
                                dateFormat.format(item.timestamp),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },

          // here you can put your custom loading indicator, but
          // by default would be Center(child:CircularProgressIndicator())
          onLoading: CircularProgressIndicator(),
          onEmpty: Text('No data found'),

          // here also you can set your own error widget, but by
          // default will be an Center(child:Text(error))
          onError: (error) => Text(error!),
        ),
      ),
    );
  }
}
