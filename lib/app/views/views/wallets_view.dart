import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/controllers/wallets_controller.dart';
import 'package:flutter_steem_wallet_app/app/routes/app_pages.dart';
import 'package:flutter_steem_wallet_app/app/utils/show_simple_menu_dialog.dart';
import 'package:flutter_steem_wallet_app/app/widgets/skeleton_wallet_list_item.dart';
import 'package:flutter_steem_wallet_app/app/widgets/wallet_list_item.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_text/skeleton_text.dart';

import '../../constants.dart';

class WalletsView extends GetView<WalletsController> {
  final appController = AppController.to;

  @override
  Widget build(BuildContext context) {
    // 송금 화면으로 이동
    void goSendCoin({String symbol = 'STEEM'}) {
      Get.toNamed(Routes.SEND_COIN, arguments: {
        'account': appController.selectedAccount,
        'symbol': symbol,
      });
    }

    // 파워업 화면으로 이동
    void goPowerUp() {
      Get.toNamed(Routes.POWER_UP, arguments: {
        'account': appController.selectedAccount,
      });
    }

    // 파워다운 화면으로 이동
    void goPowerDown() {
      Get.toNamed(Routes.POWER_DOWN, arguments: {
        'account': appController.selectedAccount,
      });
    }

    void goDelegateDown() {
      Get.toNamed(Routes.DELEGATE_POWER, arguments: {
        'account': appController.selectedAccount,
      });
    }

    void goAccountHistory() {
      Get.toNamed(Routes.ACCOUNT_HISTORY, arguments: {
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
                  LayoutBuilder(
                    builder: (ctx, constraints) {
                      return Row(
                        children: [
                          if (Get.width >= 400) ...[
                            IconButton(
                              icon: const Icon(Icons.send_rounded),
                              tooltip: 'Send Coin',
                              color: Colors.white,
                              onPressed: goSendCoin,
                            ),
                            const SizedBox(width: 48),
                          ],
                          const Spacer(),
                          GetBuilder<AppController>(
                            id: 'selectedAccount',
                            builder: (controller) {
                              return buildAccountDropdownBox(
                                onChanged: appController.onChangeAccount,
                                value: appController.selectedAccount.value,
                                items: appController.accounts,
                              );
                            },
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.history_rounded),
                            tooltip: 'History',
                            color: Colors.white,
                            onPressed: goAccountHistory,
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_box),
                            tooltip: 'Add Account',
                            color: Colors.white,
                            onPressed: appController.goAddAccount,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  appController.obx(
                    (state) {
                      final total = ((state!.steemBalance + state.steemPower) *
                              appController.steemMarketPrice().price) +
                          (state.sbdBalance *
                              appController.sbdMarketPrice().price);
                      final estimatedAccountValue =
                          NumberFormat('###,###,###,###.##').format(total);
                      return Text(
                        '\$ $estimatedAccountValue USD',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      );
                    },
                    onLoading: Text(
                      'Loading...',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onError: (error) => Text(error.toString()),
                  ),
                  Text(
                    'Estimated Account Value',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  appController.obx(
                    (state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildProgressBox(
                            label: 'Resource Credits',
                            value: state!.resourceCredits,
                            color: Colors.green.shade800,
                          ),
                          buildProgressBox(
                            label: 'Voting Power',
                            value: state.votingPower,
                            color: Colors.lightBlue.shade800,
                          ),
                        ],
                      );
                    },
                    onLoading: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildProgressBox(
                          label: 'Resource Credits',
                          value: 100,
                          color: Colors.green.shade800,
                          loading: true,
                        ),
                        buildProgressBox(
                          label: 'Voting Power',
                          value: 100,
                          color: Colors.lightBlue.shade800,
                          loading: true,
                        ),
                      ],
                    ),
                    onError: (error) => Text(error.toString()),
                  ),
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
                      child: appController.obx(
                        (wallet) {
                          return Column(
                            children: [
                              // Wallet List
                              WalletListItem(
                                icon: SvgPicture.asset(
                                    'assets/images/icon/token-steem.svg'),
                                amount: wallet!.steemBalance,
                                symbol: 'STEEM',
                                price: appController.steemMarketPrice().price,
                                ratio: appController.steemMarketPrice().change,
                                onTap: () async {
                                  await showSimpleMenuDialog(
                                    [
                                      SimpleMenuDialogOption(
                                        Icon(
                                          Icons.send_rounded,
                                          color: Colors.green.shade600,
                                          size: 24,
                                        ),
                                        'STEEM 보내기',
                                        () => goSendCoin(symbol: Symbols.STEEM),
                                      ),
                                      SimpleMenuDialogOption(
                                        Icon(
                                          Icons.bolt_rounded,
                                          color: Colors.yellow.shade700,
                                          size: 36,
                                        ),
                                        '파워 업',
                                        goPowerUp,
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              WalletListItem(
                                icon: SvgPicture.asset(
                                    'assets/images/icon/token-steem-power.svg'),
                                amount: wallet.steemPower,
                                symbol: 'SP',
                                price: appController.steemMarketPrice().price,
                                ratio: appController.steemMarketPrice().change,
                                onTap: () async {
                                  await showSimpleMenuDialog(
                                    [
                                      SimpleMenuDialogOption(
                                        Icon(
                                          Icons.swap_horiz_rounded,
                                          color: Colors.green.shade600,
                                          size: 36,
                                        ),
                                        '임대',
                                        goDelegateDown,
                                      ),
                                      SimpleMenuDialogOption(
                                        Icon(
                                          Icons.bolt_rounded,
                                          color: Colors.orange.shade700,
                                          size: 36,
                                        ),
                                        '파워 다운',
                                        goPowerDown,
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              WalletListItem(
                                icon: SvgPicture.asset(
                                    'assets/images/icon/token-sbd.svg'),
                                amount: wallet.sbdBalance,
                                symbol: 'SBD',
                                price: appController.sbdMarketPrice().price,
                                ratio: appController.sbdMarketPrice().change,
                                onTap: () async {
                                  await showSimpleMenuDialog(
                                    [
                                      SimpleMenuDialogOption(
                                        Icon(
                                          Icons.send_rounded,
                                          color: Colors.green.shade600,
                                          size: 24,
                                        ),
                                        'SBD 보내기',
                                        () => goSendCoin(symbol: Symbols.SBD),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        },
                        onLoading: Column(
                          children: [
                            SkeletonWalletListItem(),
                            const SizedBox(height: 10),
                            SkeletonWalletListItem(),
                            const SizedBox(height: 10),
                            SkeletonWalletListItem(),
                          ],
                        ),
                      ),
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



  SizedBox buildProgressBox({
    required final String label,
    required final double value,
    required final Color color,
    bool? loading = false,
  }) {
    final width = math.min(Get.width / 2 - 20, 170).toDouble();
    return SizedBox(
      width: width,
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
                    loading == true
                        ? 'Loading...'
                        : '${value.toStringAsFixed(2)}%',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: loading == true
                ? SkeletonAnimation(
                    shimmerColor: color,
                    child: Container(
                      height: 4,
                      width: width,
                      decoration: BoxDecoration(color: Colors.grey),
                    ),
                  )
                : LinearProgressIndicator(
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
    return Container(
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
    );
  }
}
