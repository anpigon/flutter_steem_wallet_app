import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/controllers/wallets_controller.dart';
import 'package:flutter_steem_wallet_app/app/routes/app_pages.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class WalletsView extends GetView<WalletsController> {
  final appController = AppController.to;

  @override
  Widget build(BuildContext context) {
    final isSmallWidth = Get.width < 400;

    // 송금 화면으로 이동
    void goSendCoin({String symbol = 'STEEM'}) {
      Get.toNamed(Routes.SEND_COIN, arguments: {
        'account': appController.selectedAccount.value,
        'symbol': symbol,
      });
    }

    // 파워업 화면으로 이동
    void goPowerUp() {
      Get.toNamed(Routes.POWER_UP, arguments: {
        'account': appController.selectedAccount.value,
      });
    }

    // 파워다운 화면으로 이동
    void goPowerDown() {
      Get.toNamed(Routes.POWER_DOWN, arguments: {
        'account': appController.selectedAccount.value,
      });
    }

    return SafeArea(
      child: Container(
        child: Column(
          children: [
            // Start top area
            Container(
              decoration: buildLinearGradientDecoration(),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    children: [
                      if (!isSmallWidth) ...[
                        IconButton(
                          icon: const Icon(Icons.send_rounded),
                          tooltip: 'Send Coin',
                          color: Colors.white,
                          onPressed: goSendCoin,
                        ),
                        const SizedBox(width: 48),
                      ],
                      const Spacer(),
                      Obx(
                        () => buildAccountDropdownBox(
                          onChanged: appController.onChangeAccount,
                          value: appController.selectedAccount(),
                          items: appController.accounts,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.history_rounded),
                        tooltip: 'History',
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_box),
                        tooltip: 'Add Account',
                        color: Colors.white,
                        onPressed: appController.goAddAccount,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    final wallet = appController.wallet();
                    final total = ((wallet.steemBalance + wallet.steemPower) *
                            appController.steemMarketPrice().price) +
                        (wallet.sbdBalance *
                            appController.sbdMarketPrice().price);
                    final _totalString =
                        NumberFormat('###,###,###,###.##').format(total);
                    return Text(
                      '\$ $_totalString USD',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    );
                  }),
                  Text(
                    'Estimated Account Value',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  Obx(() {
                    final wallet = appController.wallet();
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildProgressBox(
                          label: 'Resource Credits',
                          value: wallet.resourceCredits,
                          color: Colors.green.shade800,
                        ),
                        buildProgressBox(
                          label: 'Voting Power',
                          value: wallet.votingPower,
                          color: Colors.lightBlue.shade800,
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // End top area
            TabBar(
              controller: controller.tabController,
              labelColor: Get.theme.primaryColor,
              tabs: [
                Tab(text: 'Primary'),
                Tab(text: 'Tokens'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Obx(() {
                        final wallet = appController.wallet();
                        return Column(
                          children: [
                            // Wallet List
                            buildWalletCard(
                              icon: SvgPicture.asset(
                                  'assets/images/icon/token-steem.svg'),
                              amount: wallet.steemBalance,
                              symbol: 'STEEM',
                              price: appController.steemMarketPrice().price,
                              ratio: appController.steemMarketPrice().change,
                              onTap: () async {
                                final result = await Get.dialog(
                                  SimpleDialog(
                                    children: [
                                      buildSimpleDialogOption(
                                        id: 0,
                                        text: 'STEEM 보내기',
                                        icon: Icon(
                                          Icons.send_rounded,
                                          color: Colors.green.shade600,
                                          size: 24,
                                        ),
                                      ),
                                      Divider(),
                                      buildSimpleDialogOption(
                                        id: 1,
                                        text: ' 파워 업',
                                        icon: Icon(
                                          Icons.bolt,
                                          color: Colors.yellow.shade700,
                                          size: 36,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                switch (result) {
                                  case 0:
                                    return goSendCoin(symbol: Symbols.STEEM);
                                  case 1:
                                    return goPowerUp();
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            buildWalletCard(
                              icon: SvgPicture.asset(
                                  'assets/images/icon/token-steem-power.svg'),
                              amount: wallet.steemPower,
                              symbol: 'SP',
                              price: appController.steemMarketPrice().price,
                              ratio: appController.steemMarketPrice().change,
                              onTap: () {},
                            ),
                            const SizedBox(height: 10),
                            buildWalletCard(
                              icon: SvgPicture.asset(
                                  'assets/images/icon/token-sbd.svg'),
                              amount: wallet.sbdBalance,
                              symbol: 'SBD',
                              price: appController.sbdMarketPrice().price,
                              ratio: appController.sbdMarketPrice().change,
                              onTap: () async {
                                final result = await Get.dialog(
                                  SimpleDialog(
                                    children: [
                                      buildSimpleDialogOption(
                                        id: 0,
                                        text: 'SBD 보내기',
                                        icon: Icon(
                                          Icons.send_rounded,
                                          color: Colors.green.shade600,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                goSendCoin(symbol: Symbols.SBD);
                              },
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  Center(child: Text('Tokens')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SimpleDialogOption buildSimpleDialogOption({
    required int id,
    required String text,
    required Icon icon,
  }) {
    return SimpleDialogOption(
      onPressed: () => Get.back(result: id),
      child: SizedBox(
        height: 35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(text), icon],
        ),
      ),
    );
  }

  Widget buildWalletCard({
    required Widget icon,
    required double amount,
    required double price,
    required String symbol,
    required double ratio,
    required VoidCallback onTap,
  }) {
    final amountString = NumberFormat('###,###,###,###.###').format(amount);
    final priceString = NumberFormat('###,###,###,###.##').format(price);
    final totalString =
        NumberFormat('###,###,###,###.##').format(amount * price).trim();
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(23),
          child: Row(
            children: [
              icon,
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$amountString $symbol'),
                  SizedBox(height: 5),
                  Text(
                    '\$ $priceString',
                    style: TextStyle(color: Get.theme.hintColor),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$ $totalString'),
                  SizedBox(height: 6.8),
                  Text(
                    '${ratio > 0 ? '+' : ''} ${ratio.toStringAsFixed(2)}%',
                    style: TextStyle(
                        color: ratio > 0
                            ? Colors.green
                            : ratio < 0
                                ? Colors.red
                                : Get.theme.hintColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox buildProgressBox({
    required final String label,
    required final double value,
    required final Color color,
  }) {
    return SizedBox(
      width: math.min(Get.width / 2 - 20, 170),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: FittedBox(
                  child: Text(
                    '$label: ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: FittedBox(
                  child: Text(
                    '${value.toStringAsFixed(2)}%',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color?>(color),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration buildLinearGradientDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Get.theme.primaryColorDark,
          Get.theme.primaryColor,
        ],
      ),
    );
  }

  Widget buildAccountDropdownBox({
    void Function(String?)? onChanged,
    String? value,
    required List<String> items,
  }) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Get.theme.buttonColor.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(50)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 7),
        // constraints: const BoxConstraints(minWidth: 100, maxWidth: 180),
        child: DropdownButton(
          onChanged: onChanged,
          value: value,
          items: items
              .map<DropdownMenuItem<String>>(
                (username) => DropdownMenuItem(
                  value: username,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(18),
                        ),
                        child: ColoredBox(
                          color: Colors.white,
                          child: Image.network(
                            'https://steemitimages.com/u/$username/avatar',
                            fit: BoxFit.cover,
                            width: 36,
                            height: 36,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.account_circle,
                                size: 36,
                                color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 100,
                          // username이 매우 긴 계정 때문에...
                          maxWidth: (math.max(Get.mediaQuery.size.width, 400) -
                              (106 + (48 * 4))),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(username),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          underline: Container(),
          icon: const Icon(Icons.expand_more),
          style: Get.theme.textTheme.subtitle1!.copyWith(color: Colors.white),
          iconEnabledColor: Colors.white,
          dropdownColor: Get.theme.primaryColor,
        ),
      ),
    );
  }
}
