abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class InvalidInputFailure extends Failure {
  InvalidInputFailure(String message) : super(message);
}