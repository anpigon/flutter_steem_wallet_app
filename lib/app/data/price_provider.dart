import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dto/quote_lastest.dart';

class PriceProvider extends GetConnect {

  static PriceProvider get to => Get.find();

  @override
  void onInit() {
    final API_KEY = dotenv.env['COINMARKETCAP_API_KEY'];
    httpClient.baseUrl = 'https://pro-api.coinmarketcap.com';

    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['X-CMC_PRO_API_KEY'] = API_KEY!;
      return request;
    });
  }

  Future<QuoteLastest> getQuotesLatest(List<String> symbols) async {
    final response = await get<Map<String, dynamic>>(
      '/v1/cryptocurrency/quotes/latest',
      query: {'symbol': symbols.join(',')},
    );
    if (response.statusCode == 200 &&
        response.body != null &&
        response.body!['status']['error_code'] == 0) {
      return QuoteLastest.fromJson(response.body!['data']);
    } else if (response.body != null &&
        response.body!['status'] != null &&
        response.body!['status']['error_code'] > 0) {
      throw Exception(response.body!['status']['error_message']);
    } else {
      throw Exception(response.body!['message']);
    }
  }
}
