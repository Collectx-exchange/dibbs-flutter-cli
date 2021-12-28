import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:dibbs_flutter_cli/src/modules/run.dart';

import '../../dibbs_flutter_cli.dart';

class RunCommand extends CommandBase {
  @override
  final name = 'run';

  @override
  final description = 'run scripts in pubspec.yaml';

  @override
  final invocationSuffix = '<project name>';

  @override
  FutureOr<void> run() {
    final argResults = this.argResults;
    if (argResults == null || argResults.rest.isEmpty) {
      throw UsageException('script name not passed for a run command', usage);
    } else {
      return runCommand(argResults.rest);
    }
  }
}
