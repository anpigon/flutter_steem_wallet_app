import 'package:equatable/equatable.dart';

class Wallet {
  late String name;
  late double steemBalance;
  late double sbdBalance;
  late double steemPower;
  late double votingPower;
  late double resourceCredits;
  late double to_withdraw; // 파워다운 총 스팀량
  late double withdrawn; // 현재까지 파워다운된 스팀량

  Wallet({
    this.name = '',
    this.steemBalance = 0.0,
    this.sbdBalance = 0.0,
    this.steemPower = 0.0,
    this.votingPower = 0.0,
    this.resourceCredits = 0.0,
    this.to_withdraw = 0.0,
    this.withdrawn = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'steemBalance': steemBalance,
        'sbdBalance': sbdBalance,
        'steemPower': steemPower,
        'votingPower': votingPower,
        'resourceCredits': resourceCredits,
        'to_withdraw': to_withdraw,
        'withdrawn': withdrawn,
      };
}
