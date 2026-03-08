import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message});
}

class CameraFailure extends Failure {
  const CameraFailure({required super.message});
}

class MLKitFailure extends Failure {
  const MLKitFailure({required super.message});
}

class GeminiFailure extends Failure {
  const GeminiFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NoInternetFailure extends Failure {
  const NoInternetFailure({required super.message});
}
