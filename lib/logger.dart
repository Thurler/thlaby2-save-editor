import 'dart:io';

class Logger {
  static final Logger _logger = Logger._internal();
  static const String filename = 'applicationlog.txt';

  factory Logger() {
    return _logger;
  }

  Logger._internal();

  Future<void> log(dynamic message) async {
    try {
      File logFile = File(filename);
      IOSink sink = logFile.openWrite(mode: FileMode.append);
      sink.writeln(message.toString());
      await sink.flush();
      await sink.close();
    } on FileSystemException {
      // Can't do much - if I can't open the log file, I can't log the error
    }
  }
}
