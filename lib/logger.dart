import 'package:logger/logger.dart';
import 'dart:developer' as developer;

final logger = Logger();
class Log {
  // static final logger = Logger();

  static void e(dynamic error, [StackTrace? stackTrace, dynamic message='ERROR']) {
    logger.e(message, error, stackTrace);
  }

  static void v(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.v(message, error, stackTrace);
  }

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.i(message, error, stackTrace);
  }

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.w(message, error, stackTrace);
  }

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.w(message, error, stackTrace);
  }

  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.wtf(message, error, stackTrace);
  }

  static void l(
    String message, {
    int level = 0,
    String name = '',
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      error: error,
      stackTrace: stackTrace,
      level: level,
      name: name,
    );
  }
}
