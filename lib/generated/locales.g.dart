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
  static const powerdown_next_power_down_is_scheduled_to_happen =
      'powerdown_next_power_down_is_scheduled_to_happen';
  static const powerdown_available = 'powerdown_available';
  static const powerdown_current = 'powerdown_current';
  static const powerup = 'powerup';
  static const powerup_influence_token = 'powerup_influence_token';
  static const powerup_non_transferable = 'powerup_non_transferable';
  static const powerup_converted_VESTING_TOKEN_can_be_sent_to_yourself_but_can_not_transfer_again =
      'powerup_converted_VESTING_TOKEN_can_be_sent_to_yourself_but_can_not_transfer_again';
  static const powerdown = 'powerdown';
}

class Locales {
  static const ko_KR = {
    'powerdown_power_down': '파워 다운',
    'powerdown_message':
        '스팀 파워를 파워 다운하면 스팀을 얻을 수 있습니다. 전체 파워 다운 과정이 완료되려면 4주가 소요됩니다.',
    'powerdown_already_power_down':
        '이미 @AMOUNT STEEM의 파워 다운을 진행하고 있습니다(현재까지 @WITHDRAWN STEEM 파워 다운). 파워다운 수량을 변경하게 되면 파워 다운 일정이 초기화되니 유의하십시오.',
    'powerdown_delegating':
        '현재 @AMOUNT STEEM을 임대 중입니다. 이 수량은 임대 종료 후 회수 기간이 완전히 지날 때까지는 파워 다운을 할 수 없습니다.',
    'powerdown_per_week': 'That\'s ~@AMOUNT)s STEEM per week.',
    'powerdown_warning': '@VESTING_TOKEN가 @AMOUNT 이하로 내려가면 계정의 사용에 제약이 생깁니다.',
    'powerdown_error': '파워다운 실패: @MESSAGE',
    'powerdown_next_power_down_is_scheduled_to_happen': '다음 파워다운 예정: %s %s',
    'powerdown_available': '이용 가능',
    'powerdown_current': '현재 잔액',
    'powerup': '파워 업',
    'powerup_influence_token':
        '스팀잇에서의 영향력을 나타냅니다. 스팀 파워가 높을수록 보팅 금액이 더 높아지고, 큐레이션 보상도 더 많이 받을 수 있습니다.',
    'powerup_non_transferable':
        'STEEM POWER는 전송이 불가능하며, 다시 STEEM으로 전환하기 위해서는 1달이 소요됩니다. (4회로 나누어 전환 됩니다)',
    'powerup_converted_VESTING_TOKEN_can_be_sent_to_yourself_but_can_not_transfer_again':
        'STEEM POWER는 본인 또는 다른 사람에게 보낼 수 있지만 다시 STEEM으로 전환하지 않고는 전송할 수 없습니다.',
  };
  static const en_US = {
    'powerdown': 'Power Down',
    'powerdown_message':
        'Power Down your Steem Power to get liquid STEEM. The entire Power Down process will take 4 weeks.',
    'powerdown_already_power_down':
        'You are already powering down @AMOUNT STEEM (@WITHDRAWN STEEM paid out so far). Note that if you change the power down amount the payout schedule will reset.',
    'powerdown_delegating':
        'You are delegating @AMOUNT STEEM. That amount is locked up and not available to power down until the delegation is removed and 5 days have passed.',
    'powerdown_per_week': 'That\'s ~@AMOUNT STEEM per week.',
    'powerdown_warning':
        'Leaving less than @AMOUNT @VESTING_TOKEN in your account is not recommended and can leave your account in a unusable state.',
    'powerdown_error': 'Unable to power down (ERROR: @MESSAGE)',
    'powerdown_next_power_down_is_scheduled_to_happen':
        'The next power down is scheduled to happen: %s %s',
    'powerdown_available': 'Available',
    'powerdown_current': 'Current',
    'powerup': 'Power Up',
    'powerup_influence_token':
        'Influence tokens which give you more control over post payouts and allow you to earn on curation rewards.',
    'powerup_non_transferable':
        'STEEM POWER is non-transferable and requires 1 month (4 payments) to convert back to STEEM.',
    'powerup_converted_VESTING_TOKEN_can_be_sent_to_yourself_but_can_not_transfer_again':
        'Converted STEEM POWER can be sent to yourself or someone else but can not transfer again without converting back to STEEM.',
  };
}
