import 'dart:convert';
import 'dart:io';

void upgrade() {
  var isFlutterDart = true;

  if (Platform.isWindows) {
    var process = Process.runSync('where', ['dibbs'], runInShell: true);

    isFlutterDart =
        process.stdout.toString().contains('flutter\\.pub-cache\\bin\\snow');
  } else {
    var process = Process.runSync('which', ['dibbs'], runInShell: true);
    isFlutterDart =
        process.stdout.toString().contains('flutter/.pub-cache/bin/snow');
  }

  if (isFlutterDart) {
    print('Upgrade in Flutter Dart VM');
    Process.runSync(
        'flutter', ['pub', 'global', 'activate', 'flutter_snow_blower'],
        runInShell: true);
  } else {
    print('Upgrade in Dart VM');
    Process.runSync('pub', ['global', 'activate', 'flutter_snow_blower'],
        runInShell: true);
  }

  var process =
      Process.runSync('dibbs', ['-v'], runInShell: true, stdoutEncoding: utf8);
  print(process.stdout);
}
