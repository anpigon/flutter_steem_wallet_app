import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
            return ListView.separated(
                itemBuilder: (ctx, index) {
                  return ListTile(
                    title: Text(state![index].message ?? ''),
                  );
                },
                separatorBuilder: (_, __) => Divider(),
                itemCount: state!.length);
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
