import 'dart:async';

import 'package:args/command_runner.dart';

import '../../dibbs_flutter_cli.dart';

class InstallCommand extends CommandBase {
  @override
  final name = 'install';
  @override
  final description = 'Install (or update) a new package or packages:';

  InstallCommand() {
    argParser.addFlag('dev',
        negatable: false,
        help: 'Install (or update) a package in a dev dependency');
  }

  @override
  FutureOr<void> run() {
    final argResults = this.argResults;
    if (argResults == null || argResults.rest.isEmpty) {
      throw UsageException('value not passed for a module command', usage);
    } else {
      return install(argResults.rest, argResults['dev']);
    }
  }
}

class InstallCommandAbbr extends InstallCommand {
  @override
  final name = 'i';
}
