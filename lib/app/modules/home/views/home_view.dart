import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/widgets/loader.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarColor: Get.theme.primaryColorDark),
      child: Obx(
        () => Stack(
          children: [
            Scaffold(
              body: controller.currentPage,
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: controller.currentIndex(), //현재 선택된 Index
                onTap: controller.changePage,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_balance_wallet),
                    label: 'Wallet',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.supervisor_account),
                    label: 'Community',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.explore),
                    label: 'DApp',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  )
                ],
              ),
            ),
            if(AppController.to.loading.value) Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
              ),
              child: Center(
                // child: CircularProgressIndicator(),
                child: Loader(color: Get.theme.accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
