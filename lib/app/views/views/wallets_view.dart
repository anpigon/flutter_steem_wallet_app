import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/controllers/app_controller.dart';
import 'package:flutter_steem_wallet_app/app/controllers/wallets_controller.dart';
import 'package:flutter_steem_wallet_app/app/models/wallet.dart';
import 'package:flutter_steem_wallet_app/app/routes/app_pages.dart';
import 'package:flutter_steem_wallet_app/app/utils/num_util.dart';
import 'package:flutter_steem_wallet_app/app/utils/show_simple_menu_dialog.dart';
import 'package:flutter_steem_wallet_app/app/widgets/skeleton_wallet_list_item.dart';
import 'package:flutter_steem_wallet_app/app/widgets/wallet_list_item.dart';
import 'package:get/get.dart';
import 'package:skeleton_text/skeleton_text.dart';

import '../../constants.dart';
import 'account_dropdown_buttons.dart';

class WalletsView extends GetView<WalletsController> {
  final appController = AppController.to;

  @override
  Widget build(BuildContext context) {
    // 송금 화면으로 이동
    void goSendCoin([String? symbol = 'STEEM']) {
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
                              return AccountDropdownButtons(
                                items: appController.accounts,
                                value: appController.selectedAccount.value,
                                onChanged: appController.onChangeAccount,
                                color: Get.theme.buttonColor.withOpacity(0.1),
                                minWidth: 100,
                                maxWidth:
                                    (math.max(Get.mediaQuery.size.width, 400) -
                                        (106 + (48 * 4))),
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
                          NumUtil.toPriceFormat(total);
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
                          final rewards = wallet?.getRewards() ?? []; // 미청구 보상

                          return Column(
                            children: [
                              if (rewards.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(23.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'wallet_current_rewards'
                                            .trArgs([rewards.join(', ')]),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed:
                                            appController.claimRewardBalance,
                                        icon: Icon(Icons.redeem_outlined),
                                        label: Text('wallet_redeem_rewards'.tr),
                                      ),
                                    ],
                                  ),
                                ),
                              buildWalletList(
                                wallet!,
                                goSendCoin: goSendCoin,
                                goPowerUp: goPowerUp,
                                goDelegateDown: goDelegateDown,
                                goPowerDown: goPowerDown,
                              ),
                            ],
                          );
                        },
                        onLoading: Column(
                          children: List.filled(
                            3,
                            SkeletonWalletListItem(),
                          ).toList(),
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

  Widget buildWalletList(
    Wallet wallet, {
    required void Function([String? symbol]) goSendCoin,
    required VoidCallback goPowerUp,
    required VoidCallback goDelegateDown,
    required VoidCallback goPowerDown,
  }) {
    return Column(
      children: [
        // Wallet List
        WalletListItem(
          icon: WalletIcons.STEEM,
          amount: wallet.steemBalance,
          symbol: Symbols.STEEM,
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
                  'main_send_something'.trArgs([Symbols.STEEM]),
                  () => goSendCoin(Symbols.STEEM),
                ),
                SimpleMenuDialogOption(
                  Icon(
                    Icons.bolt_rounded,
                    color: Colors.yellow.shade700,
                    size: 36,
                  ),
                  'powerup'.tr,
                  goPowerUp,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        WalletListItem(
          icon: WalletIcons.SP,
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
                  'delegate_power'.tr,
                  goDelegateDown,
                ),
                SimpleMenuDialogOption(
                  Icon(
                    Icons.bolt_rounded,
                    color: Colors.orange.shade700,
                    size: 36,
                  ),
                  'powerdown'.tr,
                  goPowerDown,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        WalletListItem(
          icon: WalletIcons.SBD,
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
                  'main_send_something'.trArgs([Symbols.SBD]),
                  () => goSendCoin(Symbols.SBD),
                ),
              ],
            );
          },
        ),
      ],
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
              ),
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
}
