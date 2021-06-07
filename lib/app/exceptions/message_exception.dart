class MessageException implements Exception {
  late final String message;
  late final String? code;

  MessageException(this.message, {this.code});

  @override
  String toString() {
    return message;
  }
}
