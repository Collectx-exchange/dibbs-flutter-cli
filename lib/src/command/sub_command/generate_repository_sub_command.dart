import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:dibbs_flutter_cli/src/modules/generate.dart';

import '../command_base.dart';

class GenerateRepositorySubCommand extends CommandBase {
  @override
  final name = 'repository';
  @override
  final description = 'Creates a repository';

  GenerateRepositorySubCommand() {
    argParser.addFlag('notest',
        abbr: 'n', negatable: false, help: 'no create file test');
    argParser.addFlag('complete',
        abbr: 'c',
        negatable: false,
        help: 'Creates a repository with Data Sources files');
  }

  @override
  Future<FutureOr<void>> run() async {
    final argResults = this.argResults;
    if (argResults == null || argResults.rest.isEmpty) {
      throw UsageException('value not passed for a module command', usage);
    } else {
      await Generate.repository(
        argResults.rest.first,
        argResults.rest.first,
        haveTest: !argResults['notest'],
        complete: argResults['complete'],
      );
    }
    super.run();
  }
}

class GenerateRepositoryAbbrSubCommand extends GenerateRepositorySubCommand {
  @override
  final name = 'r';
}
