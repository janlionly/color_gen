import 'dart:io';

void info(String message) => stdout.writeln('INFO: $message');

void warning(String message) => stdout.writeln('WARNING: $message');

void error(String message) => stderr.writeln('ERROR: $message');

void exitWithError(String message) {
  error(message);
  exit(2);
}
