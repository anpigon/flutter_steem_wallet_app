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
  static const powerdown = 'powerdown';
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
  static const delegate = 'delegate';
  static const delegate_power = 'delegate_power';
  static const delegate_available = 'delegate_available';
  static const delegate_current = 'delegate_current';
  static const delegate_message = 'delegate_message';
  static const delegate_incoming = 'delegate_incoming';
  static const delegate_outgoing = 'delegate_outgoing';
  static const delegate_to_user = 'delegate_to_user';
  static const delegate_total_outgoing = 'delegate_total_outgoing';
  static const delegate_total_incoming = 'delegate_total_incoming';
  static const delegate_hint_username = 'delegate_hint_username';
  static const delegate_hint_amount = 'delegate_hint_amount';
  static const add_account = 'add_account';
  static const add_account_info = 'add_account_info';
  static const add_account_hint_username = 'add_account_hint_username';
  static const add_account_hint_key = 'add_account_hint_key';
  static const add_account_message = 'add_account_message';
  static const add_account_import_key = 'add_account_import_key';
  static const main_send_something = 'main_send_something';
}

class Locales {
  static const ko_KR = {
    'powerdown': '파워 다운',
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
    'delegate': '임대',
    'delegate_power': '임대하기',
    'delegate_available': '임대 가능',
    'delegate_current': '전체 파워',
    'delegate_message':
        '스팀 파워(SP)를 다른 사용자에게 임대할 수 있습니다. 임대한 수량을 변경하거나 리뷰하고 싶다면 임대한 수량을 클릭하세요.',
    'delegate_incoming': '임대 받은 수량: %s',
    'delegate_outgoing': '임대 받은 수량: %s',
    'delegate_to_user': '사용자에게 임대하기',
    'delegate_total_outgoing': '임대한 수량 합계',
    'delegate_total_incoming': '임대 받은 수량 합계',
    'delegate_hint_username': '임대할 Steem 계정을 입력하세요.',
    'delegate_hint_amount': '임대할 SP 수량을 입력하세요.',
    'add_account': '계정 추가',
    'add_account_info':
        'Steem 계정을 입력하고 Private Posting key 또는 Private Active key 중 하나를 Private Key에 입력하세요.',
    'add_account_hint_username': 'Steem 계정을 입력하세요.',
    'add_account_hint_key': 'Private Key를 입력하세요.',
    'add_account_message':
        '사용자의 Private key 정보를 수집하지 않습니다. Private key는 암호화되어 디바이스에 안전하게 저장됩니다.',
    'add_account_import_key': '키 가져오기',
    'main_send_something': '%s 보내기',
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
    'delegate': 'Delegate',
    'delegate_power': 'Delegate Power',
    'delegate_available': 'Available',
    'delegate_current': 'Current',
    'delegate_message':
        'You may delegate your Steem Power (SP) to another user. Click on the Outgoing amount to review or make changes.',
    'delegate_incoming': 'Incoming %s',
    'delegate_outgoing': 'Outgoing %s',
    'delegate_to_user': 'Delegate to user',
    'delegate_total_outgoing': 'Total Outgoing',
    'delegate_total_incoming': 'Total Incoming',
    'delegate_hint_username': 'Enter the Steem account to delegate.',
    'delegate_hint_amount': 'Enter the amount of SP to delegate.',
    'add_account': 'Add Account',
    'add_account_info':
        'Enter your Steem account name and either the private posting or active key for that account below.',
    'add_account_hint_username': 'Enter your Steem account.',
    'add_account_hint_key': 'Enter your Private Key.',
    'add_account_message':
        'We do not collect user\'s private key information. Your private key is encrypted and stored securely on your device.',
    'add_account_import_key': 'Import Key',
    'main_send_something': 'Send %s',
  };
}
