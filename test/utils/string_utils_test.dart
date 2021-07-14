import 'package:dio/dio.dart';
import 'package:flutter_steem_wallet_app/app/utils/string_util.dart';
import 'package:test/test.dart';

void main() {
  group('stripMarkdown', () {
    test('text', () async {
      var text = '''- list type 1
* list type 2
- list type 3
plaintext
''';
      var result = StringUtil.stripMarkdown(text);
      expect(result, '''list type 1
list type 2
list type 3
plaintext
''');
    });

    test('stripMarkdown and truncate', () async {
      var text = await Dio()
          .get(
              'https://steemit.com/kr/@anpigon/flutter-typeadapter-hive-database.json')
          .then((r) => r.data['post']['body']);
      var result = StringUtil.stripMarkdown(text);
      result = StringUtil.truncate(result, 200);
      assert(result.length == 200);
      assert(!result.contains('\n'));
    });
  });
}
