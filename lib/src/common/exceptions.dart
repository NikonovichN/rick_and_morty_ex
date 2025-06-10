import 'package:equatable/equatable.dart';

class RepositoryException extends Equatable implements Exception {
  static const httpError = RepositoryException(message: 'Any http status code error!');

  final String message;

  const RepositoryException({required this.message});

  @override
  List<Object?> get props => [message];
}
