import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text('settings_manage_accounts'.tr),
                onTap: () {
                  Get.toNamed(Routes.MANAGE_ACCOUNTS);
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('settings_about'.tr),
                onTap: () {},
              ),
            ],
        ),
      ),
    );
  }
}
