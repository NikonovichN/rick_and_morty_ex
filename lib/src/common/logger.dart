import 'package:logger/logger.dart';

mixin AppLogger {
  final _logger = Logger(printer: PrettyPrinter());

  void info(String message) => _logger.i(message);

  void debug(String message) => _logger.d(message);

  void warning(String message) => _logger.w(message);

  void error(String message) => _logger.e(message);
}

class AppLoggerInst with AppLogger {
  AppLoggerInst();
}
