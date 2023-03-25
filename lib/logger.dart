import 'dart:io';

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
  bool _hasInitialized = false;
  late IOSink sink;

  String _currentTimestamp() {
    return DateTime.now().toLocal().toIso8601String();
  }

  Future<void> _initializeLog() async {
    File logFile = File(filename);
    sink = logFile.openWrite();
    sink.writeln('${_currentTimestamp()} | Save Editor v0.1.0 opened');
    await sink.flush();
  }

  factory Logger() {
    return _logger;
  }

  Logger._internal();

  Future<void> log(LogLevel level, dynamic message) async {
    try {
      if (!_hasInitialized) {
        _hasInitialized = true;
        await _initializeLog();
      }
      sink.write('${_currentTimestamp()} | ');
      sink.write('${level.name.toUpperCase()} | ');
      sink.writeln(message.toString());
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
