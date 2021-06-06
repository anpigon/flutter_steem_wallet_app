class Wallet {
  final String name;
  final double steemBalance;
  final double sbdBalance;
  final double steemPower;
  final double votingPower;
  final double resourceCredits;

  Wallet({
    required this.name,
    required this.steemBalance,
    required this.sbdBalance,
    required this.steemPower,
    required this.votingPower,
    required this.resourceCredits,
  });
}
