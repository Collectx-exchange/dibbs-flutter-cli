import 'package:args/command_runner.dart';
import 'package:dibbs_flutter_cli/src/modules/generate.dart';

import '../command_base.dart';

class GenerateEntitySubCommand extends CommandBase {
  @override
  final name = 'entity';
  @override
  final description = 'Creates a entity (Only for Clean Architecture)';

  GenerateEntitySubCommand();

  @override
  Future<void> run() async {
    final argResults = this.argResults;
    final rest = argResults?.rest;
    if (rest == null || rest.isEmpty) {
      throw UsageException('value not passed for Entity command', usage);
    } else {
      await Generate.entity(rest.first);
    }
    super.run();
  }
}

class GenerateEntityAbbrSubCommand extends GenerateEntitySubCommand {
  @override
  final name = 'e';
}
