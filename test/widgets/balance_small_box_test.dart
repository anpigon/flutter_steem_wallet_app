import 'package:flutter/material.dart';
import 'package:flutter_steem_wallet_app/app/widgets/balance_small_box.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BalanceSmallBox has a label, amount and symbol',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BalanceSmallBox(
            label: 'balance',
            amount: 1944697.913274,
            symbol: 'STEEM',
          ),
        ),
      ),
    );

    expect(find.text('balance'), findsOneWidget);
    expect(find.text('1,944,697.913'), findsOneWidget);
    expect(find.text('STEEM'), findsOneWidget);
  });
}
