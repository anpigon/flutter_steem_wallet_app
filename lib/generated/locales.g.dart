// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

// ignore_for_file: lines_longer_than_80_chars
// ignore: avoid_classes_with_only_static_members
class AppTranslation {
  static Map<String, Map<String, String>> translations = {
    'ko_KR': Locales.ko_KR,
    'en_US': Locales.en_US,
  };
}

class LocaleKeys {
  LocaleKeys._();
  static const powerdown_power_down = 'powerdown_power_down';
  static const powerdown_message = 'powerdown_message';
  static const powerdown_already_power_down = 'powerdown_already_power_down';
  static const powerdown_delegating = 'powerdown_delegating';
  static const powerdown_per_week = 'powerdown_per_week';
  static const powerdown_warning = 'powerdown_warning';
  static const powerdown_error = 'powerdown_error';
}

class Locales {
  static const ko_KR = {
    'powerdown_power_down': '파워 다운',
    'powerdown_message':
        '스팀 파워를 파워 다운하면 스팀을 얻을 수 있습니다. 전체 파워 다운 과정이 완료되려면 4주가 소요될 것입니다.',
    'powerdown_already_power_down':
        '이미 %(AMOUNT)s %(LIQUID_TICKER)s의 파워 다운을 진행하고 있습니다(현재까지 %(WITHDRAWN)s %(LIQUID_TICKER)s 파워 다운). 파워다운 수량을 변경하게 되면 파워 다운 일정이 초기화되니 유의하십시오..',
    'powerdown_delegating':
        '현재 %(AMOUNT)s %(LIQUID_TICKER)s을 임대 중입니다. 이 수량은 임대 종료 후 회수 기간이 완전히 지날 때까지는 파워 다운을 할 수 없습니다.',
    'powerdown_per_week': 'That\'s ~%(AMOUNT)s %(LIQUID_TICKER)s per week.',
    'powerdown_warning':
        '%(VESTING_TOKEN)s가 %(AMOUNT)s 이하로 내려가면 계정의 사용에 제약이 생깁니다.',
    'powerdown_error': '파워다운 실패: %(MESSAGE)s',
  };
  static const en_US = {
    'powerdown_power_down': 'Power Down',
    'powerdown_message':
        'Power Down your Steem Power to get liquid STEEM. The entire Power Down process will take 4 weeks.',
    'powerdown_already_power_down':
        'You are already powering down %(AMOUNT)s %(LIQUID_TICKER)s (%(WITHDRAWN)s %(LIQUID_TICKER)s paid out so far). Note that if you change the power down amount the payout schedule will reset.',
    'powerdown_delegating':
        'You are delegating %(AMOUNT)s %(LIQUID_TICKER)s. That amount is locked up and not available to power down until the delegation is removed and 5 days have passed.',
    'powerdown_per_week': 'That\'s ~%(AMOUNT)s %(LIQUID_TICKER)s per week.',
    'powerdown_warning':
        'Leaving less than %(AMOUNT)s %(VESTING_TOKEN)s in your account is not recommended and can leave your account in a unusable state.',
    'powerdown_error': 'Unable to power down (ERROR: %(MESSAGE)s)',
  };
}
