class QuoteLastest {
  const QuoteLastest({
    required this.items,
  });

  final Map<String, QuoteLastestItem> items;

  factory QuoteLastest.fromJson(Map<String, dynamic> json) {
    final items = <String, QuoteLastestItem>{};
    for (final item in json.entries) {
      items[item.key] = QuoteLastestItem.fromJson(item.value);
    }
    return QuoteLastest(items: items);
  }
}

class QuoteLastestItem {
  const QuoteLastestItem({
    required this.id,
    required this.name,
    required this.symbol,
    required this.slug,
    required this.numMarketPairs,
    required this.dateAdded,
    required this.tags,
    required this.maxSupply,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.isActive,
    required this.platform,
    required this.cmcRank,
    required this.isFiat,
    required this.lastUpdated,
    required this.quote,
  });

  final int id;
  final String name;
  final String symbol;
  final String slug;
  final int numMarketPairs;
  final DateTime dateAdded;
  final List<String> tags;
  final dynamic maxSupply;
  final double circulatingSupply;
  final double totalSupply;
  final int isActive;
  final dynamic platform;
  final int cmcRank;
  final int isFiat;
  final DateTime lastUpdated;
  final Quote quote;

  factory QuoteLastestItem.fromJson(Map<String, dynamic> json) =>
      QuoteLastestItem(
        id: json['id'],
        name: json['name'],
        symbol: json['symbol'],
        slug: json['slug'],
        numMarketPairs: json['num_market_pairs'],
        dateAdded: DateTime.parse(json['date_added']),
        tags: List<String>.from(json['tags'].map((x) => x)),
        maxSupply: json['max_supply'],
        circulatingSupply: json['circulating_supply'].toDouble(),
        totalSupply: json['total_supply'].toDouble(),
        isActive: json['is_active'],
        platform: json['platform'],
        cmcRank: json['cmc_rank'],
        isFiat: json['is_fiat'],
        lastUpdated: DateTime.parse(json['last_updated']),
        quote: Quote.fromJson(json['quote']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'symbol': symbol,
        'slug': slug,
        'num_market_pairs': numMarketPairs,
        'date_added': dateAdded.toIso8601String(),
        'tags': List<dynamic>.from(tags.map((x) => x)),
        'max_supply': maxSupply,
        'circulating_supply': circulatingSupply,
        'total_supply': totalSupply,
        'is_active': isActive,
        'platform': platform,
        'cmc_rank': cmcRank,
        'is_fiat': isFiat,
        'last_updated': lastUpdated.toIso8601String(),
        'quote': quote.toJson(),
      };
}

class Quote {
  const Quote({
    required this.usd,
  });

  final Usd usd;

  factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        usd: Usd.fromJson(json['USD']),
      );

  Map<String, dynamic> toJson() => {
        'USD': usd.toJson(),
      };
}

class Usd {
  const Usd({
    required this.price,
    required this.volume24H,
    required this.percentChange1H,
    required this.percentChange24H,
    required this.percentChange7D,
    required this.percentChange30D,
    required this.percentChange60D,
    required this.percentChange90D,
    required this.marketCap,
    required this.lastUpdated,
  });

  final double price;
  final double volume24H;
  final double percentChange1H;
  final double percentChange24H;
  final double percentChange7D;
  final double percentChange30D;
  final double percentChange60D;
  final double percentChange90D;
  final double marketCap;
  final DateTime lastUpdated;

  factory Usd.fromJson(Map<String, dynamic> json) => Usd(
        price: json['price'].toDouble(),
        volume24H: json['volume_24h'].toDouble(),
        percentChange1H: json['percent_change_1h'].toDouble(),
        percentChange24H: json['percent_change_24h'].toDouble(),
        percentChange7D: json['percent_change_7d'].toDouble(),
        percentChange30D: json['percent_change_30d'].toDouble(),
        percentChange60D: json['percent_change_60d'].toDouble(),
        percentChange90D: json['percent_change_90d'].toDouble(),
        marketCap: json['market_cap'].toDouble(),
        lastUpdated: DateTime.parse(json['last_updated']),
      );

  Map<String, dynamic> toJson() => {
        'price': price,
        'volume_24h': volume24H,
        'percent_change_1h': percentChange1H,
        'percent_change_24h': percentChange24H,
        'percent_change_7d': percentChange7D,
        'percent_change_30d': percentChange30D,
        'percent_change_60d': percentChange60D,
        'percent_change_90d': percentChange90D,
        'market_cap': marketCap,
        'last_updated': lastUpdated.toIso8601String(),
      };
}
