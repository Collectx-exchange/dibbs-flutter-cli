import 'package:args/command_runner.dart';
import 'package:dibbs_flutter_cli/src/modules/generate.dart';

import '../command_base.dart';

class GenerateUseCaseSubCommand extends CommandBase {
  @override
  final name = 'use_case';
  @override
  final description = 'Creates a Use case';

  GenerateUseCaseSubCommand();

  @override
  Future<void> run() async {
    final argResults = this.argResults;
    if (argResults == null || argResults.rest.isEmpty) {
      throw UsageException('value not passed for Use case command', usage);
    } else {
      await Generate.useCase(argResults.rest.first);
    }
    super.run();
  }
}

class GenerateUseCaseAbbrSubCommand extends GenerateUseCaseSubCommand {
  @override
  final name = 'u';
}
