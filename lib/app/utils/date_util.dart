import 'package:get/get.dart';

class DateUtil {
  static String displayedAt(String createdAt) {
    final date = createdAt.endsWith('Z')
        ? DateTime.parse(createdAt)
        : DateTime.parse('${createdAt}Z');
    final milliSeconds =
        DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;
    print('milliSeconds: $milliSeconds');
    final seconds = milliSeconds / 1000;
    if (seconds < 60) {
      return 'community_seconds_ago'.trArgs([seconds.toStringAsFixed(0)]);
    }
    final minutes = seconds / 60;
    if (minutes < 60) {
      return 'community_minutes_ago'.trArgs([minutes.toStringAsFixed(0)]);
    }
    final hours = minutes / 60;
    if (hours < 24) {
      return 'community_hours_ago'.trArgs([hours.toStringAsFixed(0)]);
    }
    final days = hours / 24;
    if (days < 7) {
      return 'community_days_ago'.trArgs([days.toStringAsFixed(0)]);
    }
    final weeks = days / 7;
    if (weeks < 5) {
      return 'community_weeks_ago'.trArgs([weeks.toStringAsFixed(0)]);
    }
    final months = days / 30;
    if (months < 12) {
      return 'community_months_ago'.trArgs([months.toStringAsFixed(0)]);
    }
    final years = days / 365;
    return 'community_years_ago'.trArgs([years.toStringAsFixed(0)]);
  }
}
