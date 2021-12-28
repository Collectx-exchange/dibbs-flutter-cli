import 'dart:convert';
import 'dart:io';

import 'package:dibbs_flutter_cli/src/utils/output_utils.dart' as output;
import 'package:yaml/yaml.dart';

Future<void> runCommand(List<String> commands) async {
  try {
    var yaml = File('pubspec.yaml');
    var node = yaml.readAsStringSync();
    var doc = loadYaml(node);
    for (var command in commands) {
      var regex = RegExp("[^\\s\"']+|\"[^\"]*\"|'[^']*'");

      if (!(doc as Map).containsKey('scripts')) {
        throw 'Please, add param \"scripts\" in your pubspec.yaml';
      }

      if (!(doc['scripts'] as Map).containsKey(command)) {
        throw "command '$command' not found";
      }

      String commandExec = doc['scripts'][command];

      for (var item in commandExec.split('&')) {
        final matchList =
            regex.allMatches(item).map((v) => v.group(0) ?? "").toList();
        await callProcess(matchList);
      }
    }
  } catch (e) {
    output.error(e);
  }
}

Future<void> callProcess(List<String> commands) async {
  try {
    var process = await Process.start(
        commands.first,
        commands.length <= 1
            ? []
            : commands.getRange(1, commands.length).toList(),
        runInShell: true);
    await for (var line in process.stdout.transform(utf8.decoder)) {
      print(line);
    }
  } catch (error) {
    throw 'Command Error';
  }
}
