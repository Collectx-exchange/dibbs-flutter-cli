import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:dart_console/dart_console.dart';
import 'package:pubspec_yaml/pubspec_yaml.dart';
import 'package:rxdart/rxdart.dart';

import '../../dibbs_flutter_cli.dart';
import '../utils/output_utils.dart' as output;

class RunCommand extends CommandBase {
  String? stateCLIOptions(String title, List<String> options) {
    stdin.echoMode = false;
    stdin.lineMode = false;
    var console = Console();
    var isRunning = true;
    var selected = 0;

    while (isRunning) {
      print('\x1B[2J\x1B[0;0H');
      output.title('Slidy CLI Interactive\n');
      output.warn(title);
      for (var i = 0; i < options.length; i++) {
        if (selected == i) {
          print(output.green(options[i]));
        } else {
          print(output.white(options[i]));
        }
      }

      print('\nUse ↑↓ (keyboard arrows)');
      print('Press \'q\' to quit.');

      var key = console.readKey();

      if (key.controlChar == ControlCharacter.arrowDown) {
        if (selected < options.length - 1) {
          selected++;
        }
      } else if (key.controlChar == ControlCharacter.arrowUp) {
        if (selected > 0) {
          selected--;
        }
      } else if (key.controlChar == ControlCharacter.enter) {
        isRunning = false;
        print('\x1B[2J\x1B[0;0H');
        return options[selected];
      } else if (key.char == 'q') {
        return null;
      }
    }
    print('\x1B[2J\x1B[0;0H');
    return null;
  }

  @override
  final name = 'run';

  @override
  final description = 'run scripts in pubspec.yaml';

  @override
  final invocationSuffix = '<project name>';

  @override
  FutureOr<void> run() {
    final argResults = this.argResults;
    var yaml = File('pubspec.yaml');
    var node = yaml.readAsStringSync();
    PubspecYaml pubspec = PubspecYaml.loadFromYamlString(node);

    Map<String, dynamic> scripts;
    try {
      scripts = pubspec.customFields['scripts'];
    } catch (e) {
      output.error('Please, add param \'scripts\' in your pubspec.yaml');
      return Future.value();
    }

    final vars = <String, String>{};
    try {
      Map<String, dynamic> varsLine = pubspec.customFields['vars'];
      for (var key in varsLine.keys) {
        vars[key] = varsLine[key];
      }
      // ignore: empty_catches
    } catch (e) {}

    final commands =
        argResults?.rest.isNotEmpty == true ? List<String>.from(argResults!.rest) : <String>[];

    if (commands.isEmpty) {
      final command = stateCLIOptions('Select a command', scripts.keys.toList().cast());
      if (command != null) {
        commands.add(command);
      }
    }

    if (commands.isEmpty) {
      throw UsageException('script name not passed for a run command', usage);
    }
    return runCommand(commands, scripts, vars);
  }

  Future<void> runCommand(List<String> commands, Map<String, dynamic> scripts, Map vars) async {
    for (var command in commands) {
      var regex = RegExp("[^\\s\'']+|\'[^\']*\'|'[^']*'");
      var regexVar = RegExp(r'\$([a-zA-Z0-9]+)');

      late String commandExec;
      try {
        commandExec = scripts[command] as String;
      } catch (e) {
        commandExec = '';
        output.error('command "$command" not found');
        return;
      }

      for (var match in regexVar.allMatches(commandExec)) {
        if (match.groupCount != 0) {
          var variable = match.group(0)?.replaceFirst('\$', '');
          if (variable != null && vars.containsKey(variable)) {
            commandExec = commandExec.replaceAll(match.group(0) ?? '', vars[variable] ?? '');
          }
        }
      }

      for (final item in commandExec.split('&')) {
        final matchList = regex
            .allMatches(item)
            .map((v) => v.group(0)!)
            .toList()
            .map<String>((e) => (e.startsWith('\$') ? vars[e.replaceFirst('\$', '')] ?? e : e))
            .toList();
        await callProcess(matchList);
      }
    }
  }

  Future callProcess(List<String> commands) async {
    try {
      var process = await Process.start(commands.first,
          commands.length <= 1 ? [] : commands.getRange(1, commands.length).toList(),
          runInShell: true);

      final error = process.stderr.transform(utf8.decoder).map(output.red);
      final success = process.stdout.transform(utf8.decoder).map(output.green);

      await for (var line in Rx.merge([success, error])) {
        print(line);
      }
      if (await process.exitCode == 0) {
        output.success(commands.join(' '));
      } else {
        output.error(commands.join(' '));
        exit(await process.exitCode);
      }
    } catch (error) {
      output.error(commands.join(' '));
      exit(1);
    }
  }
}
