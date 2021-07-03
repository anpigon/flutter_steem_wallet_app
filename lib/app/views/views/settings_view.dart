import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('settings_manage_accounts'.tr),
              onTap: () {},
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
