class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException(String? message)
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException(String? message) : super(message, "Invalid Input: ");
}

class TimeoutException extends CustomException {
  TimeoutException(String? message)
      : super(message, "The connection has timed out. Please try again!");
}

class ServerErrorException extends CustomException {
  ServerErrorException(String? message) : super(message, "Server Errors");
}
