import 'dart:convert';

import 'package:flutter_steem_wallet_app/app/utils/string_utils.dart';

class SteemPost {
  late final int postId;
  late final String author;
  late final String permlink;
  late final String category;
  late final String title;
  late final String body;
  late final JsonMetadata? jsonMetadata;
  late final String created;
  late final String updated;
  late final int depth;
  late final int children;
  late final int netRshares;
  late final bool isPaidout;
  late final String payoutAt;
  late final double payout;
  late final String pendingPayoutValue;
  late final String authorPayoutValue;
  late final String curatorPayoutValue;
  late final String promoted;
  late final List<dynamic>? replies;
  late final List<ActiveVotes> activeVotes;
  late final double authorReputation;
  late final Stats? stats;
  late final List<dynamic>? beneficiaries;
  late final String maxAcceptedPayout;
  late final int percentSteemDollars;
  late final String url;
  late final List<dynamic>? blacklists;
  late final String? community;
  late final String? communityTitle;
  late final String? authorRole;
  late final String? authorTitle;

  SteemPost(
      {required this.postId,
      required this.author,
      required this.permlink,
      required this.category,
      required this.title,
      required this.body,
      this.jsonMetadata,
      required this.created,
      required this.updated,
      required this.depth,
      required this.children,
      required this.netRshares,
      required this.isPaidout,
      required this.payoutAt,
      required this.payout,
      required this.pendingPayoutValue,
      required this.authorPayoutValue,
      required this.curatorPayoutValue,
      required this.promoted,
      this.replies,
      required this.activeVotes,
      required this.authorReputation,
      this.stats,
      this.beneficiaries,
      required this.maxAcceptedPayout,
      required this.percentSteemDollars,
      required this.url,
      this.blacklists,
      this.community,
      this.communityTitle,
      this.authorRole,
      this.authorTitle});

  SteemPost.fromJson(Map<String, dynamic> json, [bool isCompact = true]) {
    postId = json['post_id'];
    author = json['author'];
    permlink = json['permlink'];
    category = json['category'];
    title = json['title'];
    body = isCompact
        ? StringUtils.truncate(StringUtils.stripAll(json['body']), 200)
        : json['body'];
    jsonMetadata = (json['json_metadata'] != null
        ? JsonMetadata.fromJson(json['json_metadata'])
        : null);
    created = json['created'];
    updated = json['updated'];
    depth = json['depth'];
    children = json['children'];
    netRshares = json['net_rshares'];
    isPaidout = json['is_paidout'];
    payoutAt = json['payout_at'];
    payout = json['payout'];
    pendingPayoutValue = json['pending_payout_value'];
    authorPayoutValue = json['author_payout_value'];
    curatorPayoutValue = json['curator_payout_value'];
    promoted = json['promoted'];
    replies = json['replies'];
    activeVotes = json['active_votes']
            ?.map<ActiveVotes>((v) => ActiveVotes.fromJson(v))
            .toList() ??
        <ActiveVotes>[];
    authorReputation = json['author_reputation'];
    stats = (json['stats'] != null ? Stats.fromJson(json['stats']) : null)!;
    beneficiaries = json['beneficiaries'];
    maxAcceptedPayout = json['max_accepted_payout'];
    percentSteemDollars = json['percent_steem_dollars'];
    url = json['url'];
    blacklists = json['blacklists'];
    community = json['community'];
    communityTitle = json['community_title'];
    authorRole = json['author_role'];
    authorTitle = json['author_title'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['post_id'] = postId;
    data['author'] = author;
    data['permlink'] = permlink;
    data['category'] = category;
    data['title'] = title;
    data['body'] = body;
    if (jsonMetadata != null) {
      data['json_metadata'] = jsonMetadata?.toJson();
    }
    data['created'] = created;
    data['updated'] = updated;
    data['depth'] = depth;
    data['children'] = children;
    data['net_rshares'] = netRshares;
    data['is_paidout'] = isPaidout;
    data['payout_at'] = payoutAt;
    data['payout'] = payout;
    data['pending_payout_value'] = pendingPayoutValue;
    data['author_payout_value'] = authorPayoutValue;
    data['curator_payout_value'] = curatorPayoutValue;
    data['promoted'] = promoted;
    if (replies != null) {
      data['replies'] = replies?.map((v) => v.toJson()).toList();
    }
    data['active_votes'] = activeVotes.map((v) => v.toJson()).toList();
    data['author_reputation'] = authorReputation;
    if (stats != null) {
      data['stats'] = stats?.toJson();
    }
    if (beneficiaries != null) {
      data['beneficiaries'] = beneficiaries?.map((v) => v.toJson()).toList();
    }
    data['max_accepted_payout'] = maxAcceptedPayout;
    data['percent_steem_dollars'] = percentSteemDollars;
    data['url'] = url;
    if (blacklists != null) {
      data['blacklists'] = blacklists?.map((v) => v.toJson()).toList();
    }
    data['community'] = community;
    data['community_title'] = communityTitle;
    data['author_role'] = authorRole;
    data['author_title'] = authorTitle;
    return data;
  }
}

class JsonMetadata {
  late final List<String> tags;
  late final List<String> image;
  late final String? app;
  late final String? format;

  JsonMetadata(
      {required this.tags, required this.image, this.app, this.format});

  JsonMetadata.fromJson(dynamic json) {
    if (json is String) {
      json = jsonDecode(json);
    }
    tags = json['tags']?.cast<String>() ?? <String>[];
    image = json['image']?.cast<String>() ?? <String>[];
    app = json['app'];
    format = json['format'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['tags'] = tags;
    data['image'] = image;
    data['app'] = app;
    data['format'] = format;
    return data;
  }
}

class ActiveVotes {
  late final String voter;
  late final String rshares;

  ActiveVotes({required this.voter, required this.rshares});

  ActiveVotes.fromJson(Map<String, dynamic> json) {
    voter = json['voter'];
    rshares = json['rshares'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['voter'] = voter;
    data['rshares'] = rshares;
    return data;
  }
}

class Stats {
  late final bool hide;
  late final bool gray;
  late final int totalVotes;
  late final double flagWeight;

  Stats(
      {required this.hide,
      required this.gray,
      required this.totalVotes,
      required this.flagWeight});

  Stats.fromJson(Map<String, dynamic> json) {
    hide = json['hide'];
    gray = json['gray'];
    totalVotes = json['total_votes'];
    flagWeight = json['flag_weight'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['hide'] = hide;
    data['gray'] = gray;
    data['total_votes'] = totalVotes;
    data['flag_weight'] = flagWeight;
    return data;
  }
}
