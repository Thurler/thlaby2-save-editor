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
  static final String delimiter = List<String>.filled(20, '-').join();
  static const String filename = './applicationlog.txt';

  factory Logger() {
    return _logger;
  }

  Logger._internal();

  Future<void> log(LogLevel level, dynamic message) async {
    try {
      File logFile = File(filename);
      IOSink sink = logFile.openWrite(mode: FileMode.append);
      sink.write('${DateTime.now().toLocal().toIso8601String()} | ');
      sink.write('${level.name.toUpperCase()} | ');
      sink.writeln(message.toString());
      await sink.flush();
      await sink.close();
    } on Exception catch(e, s) {
      // Can't do much - if I can't open the log file, I can't log the error
      // ignore: avoid_print
      print('Exception: $e');
      // ignore: avoid_print
      print('Stack Trace: $s');
    }
  }
}
