import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/views/views/account_dropdown_buttons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../controllers/manage_accounts_controller.dart';

class ManageAccountsView extends GetView<ManageAccountsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings_manage_accounts'.tr),
        centerTitle: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 23.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: AccountDropdownButtons(
                    items: AppController.to.accounts,
                    value: controller.selectedAccount.value,
                    onChanged: controller.onChangeAccount,
                    color: Get.theme.accentColor,
                    minWidth: 250,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                    bottom: 20,
                    left: 23,
                    right: 23,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('manage_accounts_info_message'.tr),
                      SizedBox(height: 23),
                      Text(
                        'manage_accounts_warning_message'.tr,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
                controller.obx(
                  (state) {
                    return Column(
                      children: [
                        buildKeyListItem(
                          backgroundColor: Colors.grey.shade200,
                          title: 'Posting Key',
                          public: state!.postingPublicKey!,
                          private: controller.privateKey.posting,
                          onAddKey: () => showAddKeyDialog(
                              'ADD POSTING KEY', state.postingPublicKey!),
                          showKey: controller.showKey.posting.value,
                          onShowKey: () => controller.showKey
                              .toggle(controller.showKey.posting),
                        ),
                        buildKeyListItem(
                          title: 'Active Key',
                          public: state.activePublicKey!,
                          private: controller.privateKey.active,
                          onAddKey: () => showAddKeyDialog(
                              'ADD ACTIVE KEY', state.activePublicKey!),
                          showKey: controller.showKey.active.value,
                          onShowKey: () => controller.showKey
                              .toggle(controller.showKey.active),
                        ),
                        buildKeyListItem(
                          backgroundColor: Colors.grey.shade200,
                          title: 'Memo Key',
                          public: state.memoPublicKey!,
                          private: controller.privateKey.memo,
                          onAddKey: () => showAddKeyDialog(
                              'ADD MEMO KEY', state.memoPublicKey!),
                          showKey: controller.showKey.memo.value,
                          onShowKey: () => controller.showKey
                              .toggle(controller.showKey.memo),
                        ),
                      ],
                    );
                  },
                  onLoading: Container(
                    height: Get.height,
                  ),
                ),
                SizedBox(height: 23),
                Center(
                  // child: ElevatedButton.styleFrom(),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red.shade800,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 50),
                    ),
                    child: Text('manage_delete_account'.tr),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildKeyListItem({
  required String title,
  required String public,
  String? private,
  bool? showKey = false,
  Color? backgroundColor,
  VoidCallback? onDelete,
  VoidCallback? onAddKey,
  VoidCallback? onShowKey,
}) {
  final titleStyle =
      Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.w600);
  final subtitleStyle =
      Get.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w400);
  final textStyle = Get.textTheme.bodyText2!.copyWith(
    color: Get.textTheme.caption!.color,
    fontFamily: 'monospace',
  );

  void clipboardData(String text) {
    Clipboard.setData(ClipboardData(text: text)).then((value) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'manage_copied_clipboard'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    });
  }

  return Container(
    color: backgroundColor,
    padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title.toUpperCase(), style: titleStyle),
            if (private != null && private.isNotEmpty)
              IconButton(
                icon: Icon(Icons.delete_forever, color: Colors.red),
                onPressed: onDelete,
              ),
          ],
        ),
        Text('Public'.toUpperCase(), style: subtitleStyle),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => clipboardData(public),
          child: Text(public, style: textStyle),
        ),
        const SizedBox(height: 20),
        Text('Private'.toUpperCase(), style: subtitleStyle),
        const SizedBox(height: 5),
        if (private == null || private.isEmpty)
          Container(
            width: double.infinity,
            child: TextButton(
              onPressed: onAddKey,
              child: Text('Add Key'),
            ),
          ),
        if (private != null && private.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: () => showKey == true ? clipboardData(private) : null,
                  child: Text(
                    showKey == true ? private : List.filled(51, '•').join(''),
                    style: textStyle,
                    softWrap: true,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  showKey == true
                      ? Icons.remove_red_eye
                      : Icons.remove_red_eye_outlined,
                ),
                onPressed: onShowKey,
              ),
            ],
          ),
      ],
    ),
  );
}

Future<bool> showAddKeyDialog(String title, String public) async {
  final controller = Get.find<ManageAccountsController>();

  final result = await showDialog(
    context: Get.overlayContext!,
    builder: (ctx) {
      return Dialog(
        insetPadding: EdgeInsets.all(23.0),
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(title),
            transitionBetweenRoutes: false,
            automaticallyImplyLeading: false,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Get.back(),
              child: Icon(Icons.close_rounded),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(23.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller.privateKeyController,
                        validator: controller.privateKeyValidator,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'add_account_hint_key'.tr,
                          prefixIcon: const Icon(Icons.vpn_key),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.qr_code_scanner),
                            onPressed: null,
                          ),
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                      ),
                      SizedBox(height: 23),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (true == await controller.addKey()) {
                              Get.back(result: true);
                            }
                          },
                          child: Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  controller.privateKeyController.clear();
  controller.publicKeyForValidate = null;

  if (result) {
    await controller.loadAccount();
  }

  return result;
}
