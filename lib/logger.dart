import 'dart:io';
import 'package:thlaby2_save_editor/views/settings.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  none,
}

class Logger {
  static final Logger _logger = Logger._internal();
  static const String filename = './applicationlog.txt';
  static const String version = '0.2.0';
  LogLevel logLevel = LogLevel.info;
  late IOSink sink;

  String get _currentTimestamp => DateTime.now().toLocal().toIso8601String();

  factory Logger() {
    return _logger;
  }

  Logger._internal() {
    try {
      File settingsFile = File('./settings.json');
      if (settingsFile.existsSync()) {
        logLevel = Settings.fromJson(settingsFile.readAsStringSync()).logLevel;
      }
    } catch (e) {
      // If we fail to load the settings file, keep going with default settings
    }
    File logFile = File(filename);
    sink = logFile.openWrite();
    sink.writeln('$_currentTimestamp | Save Editor v$version opened');
  }

  String _buildLogLine(LogLevel level, dynamic message) =>
    '$_currentTimestamp | ${level.name.toUpperCase()} | $message';

  void logBuffer(LogLevel level, dynamic message) {
    if (level.index >= logLevel.index) {
      sink.writeln(_buildLogLine(level, message));
    }
  }

  Future<void> log(LogLevel level, dynamic message) async {
    logBuffer(level, message);
    return flush();
  }

  Future<void> flush() async {
    try {
      await sink.flush();
    } on Exception catch(e, s) {
      // Can't do much - if I can't open the log file, I can't log the error
      // ignore: avoid_print
      print('Exception: $e');
      // ignore: avoid_print
      print('Stack Trace: $s');
    }
  }
}

mixin Loggable {
  final Logger _logger = Logger();

  Future<void> log(LogLevel level, dynamic message) =>
    _logger.log(level, message);

  void logBuffer(LogLevel level, dynamic message) =>
    _logger.logBuffer(level, message);

  Future<void> logFlush() => _logger.flush();

  set logLevel(LogLevel level) => _logger.logLevel = level;
}
