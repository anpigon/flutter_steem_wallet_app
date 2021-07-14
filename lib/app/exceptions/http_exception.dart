class HttpException implements Exception {
  late final String? message;
  late final String? prefix;
  late final String? url;

  HttpException([this.message, this.prefix, this.url]);
}

class BadRequestException extends HttpException {
  BadRequestException([String? message, String? url])
      : super(message, 'Bad Request', url);
}

class FetchDataException extends HttpException {
  FetchDataException([String? message, String? url])
      : super(message, 'Api not responded in time', url);
}

class ApiNotRespondingException extends HttpException {
  ApiNotRespondingException([String? message, String? url])
      : super(message, 'Unable to process', url);
}

class UnAuthorizedException extends HttpException {
  UnAuthorizedException([String? message, String? url])
      : super(message, 'UnAuthorized request', url);
}
