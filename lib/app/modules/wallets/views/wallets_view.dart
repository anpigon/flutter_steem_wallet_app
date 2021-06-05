import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/wallets_controller.dart';

class WalletsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WalletsController());

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Center(
                child: Obx(() => DropdownButton(
                      onChanged: controller.onChangeAccount,
                      value: controller.selectedAccount.value,
                      items: controller.accounts
                          .map(
                            (account) => DropdownMenuItem(
                              value: account,
                              child: Text(account),
                            ),
                          )
                          .toList(),
                    )),
              ),
              controller.obx(
                (state) {
                  print('state');
                  print(state);
                  return Container();
                },
                onLoading: CircularProgressIndicator(),
                onEmpty: Text('No data found'),
                onError: (error) => Text(error.toString()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
