import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../controllers/wallets_controller.dart';

class WalletsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WalletsController(), permanent: true);

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
                      IconButton(
                        icon: Icon(Icons.send_rounded),
                        tooltip: 'Send Coin',
                        color: Colors.white,
                        onPressed: () {
                          Get.toNamed(Routes.SEND_COIN, arguments: {
                            'account': controller.selectedAccount,
                          });
                        },
                      ),
                      const SizedBox(width: 48),
                      const Spacer(),
                      Obx(
                        () => buildAccountDropdownBox(
                          onChanged: controller.onChangeAccount,
                          value: controller.selectedAccount(),
                          items: controller.accounts,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(Icons.history_rounded),
                        tooltip: 'History',
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.add_box),
                        tooltip: 'Add Account',
                        color: Colors.white,
                        onPressed: controller.addAccount,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  controller.obx(
                    (state) {
                      final total = ((state!.steemBalance + state.steemPower) *
                              controller.steemMarketPrice().price) +
                          (state.sbdBalance *
                              controller.sbdMarketPrice().price);
                      final _totalString =
                          NumberFormat('###,###,###,###.##').format(total);
                      return Text(
                        '\$ $_totalString USD',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      );
                    },
                    onLoading: Text(
                      '\$ 0.00 USD',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Text(
                    'Estimated Account Value',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  controller.obx(
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
                    onLoading: SizedBox(
                      height: 20,
                      child: FittedBox(
                          child:
                              CircularProgressIndicator(color: Colors.white)),
                    ),
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
                      child: controller.obx(
                        (state) {
                          return Column(
                            children: [
                              buildWalletCard(
                                icon: SvgPicture.asset(
                                    'assets/images/icon/token-steem.svg'),
                                amount: state!.steemBalance,
                                symbol: 'STEEM',
                                price: controller.steemMarketPrice().price,
                                ratio: controller.steemMarketPrice().change,
                              ),
                              const SizedBox(height: 10),
                              buildWalletCard(
                                icon: SvgPicture.asset(
                                    'assets/images/icon/token-steem-power.svg'),
                                amount: state.steemPower,
                                symbol: 'SP',
                                price: controller.steemMarketPrice().price,
                                ratio: controller.steemMarketPrice().change,
                              ),
                              const SizedBox(height: 10),
                              buildWalletCard(
                                icon: SvgPicture.asset(
                                    'assets/images/icon/token-sbd.svg'),
                                amount: state.sbdBalance,
                                symbol: 'SBD',
                                price: controller.sbdMarketPrice().price,
                                ratio: controller.sbdMarketPrice().change,
                              ),
                            ],
                          );
                        },
                        onLoading: Center(child: CircularProgressIndicator()),
                        // onEmpty: Text('No data found'),
                        // onError: (error) => Text(error.toString()),
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

  Card buildWalletCard({
    required Widget icon,
    required double amount,
    required double price,
    required String symbol,
    required double ratio,
  }) {
    final amountString = NumberFormat('###,###,###,###.###').format(amount);
    final priceString = NumberFormat('###,###,###,###.##').format(price);
    final totalString =
        NumberFormat('###,###,###,###.##').format(amount * price).trim();
    return Card(
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
    );
  }

  SizedBox buildProgressBox({
    required final String label,
    required final double value,
    required final Color color,
  }) {
    final maxWidth = Get.width > 300 ? 170.0 : 160.0;
    return SizedBox(
      width: maxWidth,
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
                          maxWidth: (Get.width - (30 + 36 + 40 + (48 * 4))),
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
