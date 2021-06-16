class Wallet {
  late String name;
  late double steemBalance;
  late double sbdBalance;
  late double steemPower;
  late double votingPower;
  late double resourceCredits;

  Wallet({
    this.name = '',
    this.steemBalance = 0.0,
    this.sbdBalance = 0.0,
    this.steemPower = 0.0,
    this.votingPower = 0.0,
    this.resourceCredits = 0.0,
  });
}
