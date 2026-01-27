import 'dart:collection';
import 'package:flutter/foundation.dart';

enum AppLogLevel { debug, info, warn, error, fatal }

class CrashLogEntry {
  CrashLogEntry({
    required this.id,
    required this.timestamp,
    required this.tag,
    required this.message,
    required this.level,
  });

  final String id;
  final DateTime timestamp;
  final String tag;
  final String message;
  final AppLogLevel level;

  String toLine() {
    final iso = timestamp.toIso8601String();
    return '[$iso] ${level.name.toUpperCase()} $tag: $message';
  }
}

class CrashLogBuffer {
  static const int _capacity = 200;
  static final ListQueue<CrashLogEntry> _entries =
      ListQueue<CrashLogEntry>(_capacity);
  static final ValueNotifier<CrashLogEntry?> fatalNotifier =
      ValueNotifier<CrashLogEntry?>(null);

  static void log(
    String tag,
    String message, {
    AppLogLevel level = AppLogLevel.info,
  }) {
    if (kReleaseMode &&
        (level == AppLogLevel.debug || level == AppLogLevel.info)) {
      return;
    }
    final entry = CrashLogEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      tag: tag,
      message: message,
      level: level,
    );
    if (_entries.length >= _capacity) {
      _entries.removeFirst();
    }
    _entries.add(entry);
    if (level == AppLogLevel.fatal) {
      fatalNotifier.value = entry;
    }
  }

  static List<CrashLogEntry> get entries => List.unmodifiable(_entries);

  static CrashLogEntry recordFatal(
    String tag,
    String message,
  ) {
    log(tag, message, level: AppLogLevel.fatal);
    return fatalNotifier.value ??
        CrashLogEntry(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          timestamp: DateTime.now(),
          tag: tag,
          message: message,
          level: AppLogLevel.fatal,
        );
  }

  static String exportText() {
    return _entries.map((entry) => entry.toLine()).join('\n');
  }
}

void appLog(
  String tag,
  String message, {
  AppLogLevel level = AppLogLevel.info,
}) {
  CrashLogBuffer.log(tag, message, level: level);
  if (kDebugMode) {
    debugPrint('[${level.name.toUpperCase()}] $tag: $message');
  }
}
