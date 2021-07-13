class SteemSubscription {
  late final String tag;
  late final String title;
  late final String? userType;
  late final String? nickname;

  SteemSubscription({
    required this.tag,
    required this.title,
    this.userType,
    this.nickname,
  });

  factory SteemSubscription.fromJson(List<dynamic> json) {
    return SteemSubscription(
      tag: json[0] ?? '',
      title: json[1] ?? '',
      userType: json[2],
      nickname: json[3],
    );
  }
}

// {"jsonrpc":"2.0","result":[["hive-192808","TESTBED","admin",""],["hive-196917","Korea \u2022 \ud55c\uad6d \u2022 KR \u2022 KO","mod","\uc6d0\uc0ac\ub9c8"],["hive-101145","SCT.\uc554\ud638\ud654\ud3d0.Crypto","guest",""],["hive-140217","Steem Gaming","guest",""],["hive-155556","TripleA","guest",""],["hive-111111","Steem Governance","guest",""]],"id":6}
