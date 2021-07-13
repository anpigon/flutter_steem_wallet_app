class Wallet {
  late String name;
  late double steemBalance;
  late double sbdBalance;
  late double steemPower;
  late double votingPower;
  late double resourceCredits;
  late double toWithdraw; // 파워다운 총 스팀량
  late double withdrawn; // 현재까지 파워다운된 스팀량
  late double delegatedSteemPower;
  late double receivedSteemPower;
  late double nextSteemPowerWithdrawRate;
  late DateTime? nextSteemPowerWithdrawal;

  late String rewardSbdBalance; // 0.587 SBD
  late String rewardSteemBalance; // 0.000 STEEM
  late String rewardVestingBalance; // 4784.672240 VESTS
  late String rewardVestingSteem; 

  Wallet({
    this.name = '',
    this.steemBalance = 0.0,
    this.sbdBalance = 0.0,
    this.steemPower = 0.0,
    this.votingPower = 0.0,
    this.resourceCredits = 0.0,
    this.toWithdraw = 0.0,
    this.withdrawn = 0.0,
    this.delegatedSteemPower = 0.0,
    this.receivedSteemPower = 0.0,
    this.nextSteemPowerWithdrawRate = 0.0,
    this.nextSteemPowerWithdrawal,
    this.rewardSbdBalance = '0.000 SBD',
    this.rewardSteemBalance = '0.000 STEEM',
    this.rewardVestingBalance = '0.000000 VESTS',
    this.rewardVestingSteem = '0.000 STEEM',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'steemBalance': steemBalance,
        'sbdBalance': sbdBalance,
        'steemPower': steemPower,
        'votingPower': votingPower,
        'resourceCredits': resourceCredits,
        'toWithdraw': toWithdraw,
        'withdrawn': withdrawn,
        'rewardSbdBalance': rewardSbdBalance,
        'rewardSteemBalance': rewardSteemBalance,
        'rewardVestingBalance': rewardVestingBalance,
        'rewardVestingSteem': rewardVestingSteem,
      };

  void update(Wallet val) {
    name = val.name;
    steemBalance = val.steemBalance;
    sbdBalance = val.sbdBalance;
    steemPower = val.steemPower;
    votingPower = val.votingPower;
    resourceCredits = val.resourceCredits;
    toWithdraw = val.toWithdraw;
    withdrawn = val.withdrawn;
    delegatedSteemPower = val.delegatedSteemPower;
    receivedSteemPower = val.receivedSteemPower;
    nextSteemPowerWithdrawRate = val.nextSteemPowerWithdrawRate;
    nextSteemPowerWithdrawal = val.nextSteemPowerWithdrawal;
    rewardSbdBalance=val.rewardSbdBalance;
    rewardSteemBalance=val.rewardSteemBalance;
    rewardVestingBalance=val.rewardVestingBalance;
    rewardVestingSteem=val.rewardVestingSteem;
  }
}
